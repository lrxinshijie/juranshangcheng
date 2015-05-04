//
//  NaviStoreListViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/4/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "NaviStoreListViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "NaviStoreCell.h"
#import "NaviStoreInfoViewController.h"
#import "JRStore.h"
#import "JRAreaInfo.h"
#import "NaviStoreSelCityViewController.h"
#import "ShopListViewController.h"
#import "UserLocation.h"
#import "AppDelegate.h"
#import "UIViewController+Login.h"
#import "UIViewController+Menu.h"

@interface NaviStoreListViewController ()<BMKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelCity;
@property (strong, nonatomic) IBOutlet UITableView *tableViewStore;
@property (strong, nonatomic) IBOutlet UIButton *btnChangeCity;
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) BMKPointAnnotation *selfAnnotation;
//@property (strong, nonatomic) UserLocation *location;
- (IBAction)naviLeftClick:(id)sender;
- (IBAction)naviRightClick:(id)sender;
- (IBAction)changeCityClick:(id)sender;

@end

@implementation NaviStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //latitude=39.944213,longitude=116.438717
    self.navigationItem.title = @"门店导航";
    [_tableViewStore registerNib:[UINib nibWithNibName:@"NaviStoreCell" bundle:nil] forCellReuseIdentifier:@"NaviStoreCell"];
    if(ApplicationDelegate.gLocation.isSuccessLocation)
        _btnChangeCity.hidden = YES;
    if (!_dataList)
        [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    NSDictionary *param = @{@"cityName": ApplicationDelegate.gLocation.cityName};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_NAVI_STORE_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ((NSNull *)data != [NSNull null]) {
                _dataList = [JRStore buildUpWithValueForList:[data objectForKey:@"stallInfoList"]];
            }
            else {
                _dataList = nil;
            }
            [self reloadView];
        }
    }];
}

- (void)reloadView {
    _mapView.zoomLevel = 11;
    if (ApplicationDelegate.gLocation.isSuccessLocation) {
        UserLocation *location = [[UserLocation alloc]init];
        [location GeoCode:ApplicationDelegate.gLocation.cityName Handler:^(UserLocation *loc) {
            _mapView.centerCoordinate = loc.location.coordinate;
        }];
    }
    for (BMKPointAnnotation* ann in _mapView.annotations) {
        [_mapView removeAnnotation:ann];
    }
    if (ApplicationDelegate.gLocation.isSuccessLocation) {
        _selfAnnotation = [[BMKPointAnnotation alloc]init];
        _selfAnnotation.coordinate = ApplicationDelegate.gLocation.location.coordinate;
        _selfAnnotation.title = @"我的位置";
        [_mapView addAnnotation:_selfAnnotation];
    }
    for (JRStore *store in _dataList) {
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(store.latitude, store.longitude);
        annotation.title = store.storeName;
        [_mapView addAnnotation:annotation];
    }
    _labelCity.text = [NSString stringWithFormat:@"当前城市：%@",ApplicationDelegate.gLocation.cityName];
    if (!ApplicationDelegate.gLocation.isSuccessLocation) {
        _btnChangeCity.hidden = NO;
    }
    [_tableViewStore reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = annotation==_selfAnnotation?BMKPinAnnotationColorRed:BMKPinAnnotationColorGreen;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NaviStoreCell *cell = (NaviStoreCell *)[tableView dequeueReusableCellWithIdentifier:@"NaviStoreCell"];
    int index = [indexPath row];
    JRStore *store = [_dataList objectAtIndex:index];
    cell.labelName.text = store.storeName;
    BMKMapPoint pointStore = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(store.latitude, store.longitude));
    BMKMapPoint pointSelf = BMKMapPointForCoordinate(_selfAnnotation.coordinate);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(pointStore,pointSelf);
    if (ApplicationDelegate.gLocation.isSuccessLocation) {
        cell.imageNode.image = [UIImage imageNamed:@"icon-map-node-2.png"];
        cell.labelDistance.text = [NSString stringWithFormat:@"%.2fkm",distance/1000];
    }else {
        cell.imageNode.image = nil;
        cell.labelDistance.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableViewStore deselectRowAtIndexPath:indexPath animated:YES];
    JRStore *store = [_dataList objectAtIndex:[indexPath row]];
    NaviStoreInfoViewController *info = [[NaviStoreInfoViewController alloc]init];
    info.store = store;
    [self.navigationController pushViewController:info animated:YES];
}

- (IBAction)naviLeftClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)naviRightClick:(id)sender {
    [self showAppMenuIsShare:NO];
}

- (IBAction)changeCityClick:(id)sender {
    NaviStoreSelCityViewController *vc = [[NaviStoreSelCityViewController alloc] init];
    [vc setFinishBlock:^(JRAreaInfo *areaInfo) {
        ApplicationDelegate.gLocation.cityName = areaInfo.cityName;
        UserLocation *location = [[UserLocation alloc]init];
        [location GeoCode:areaInfo.cityName Handler:^(UserLocation *loc) {
            _mapView.centerCoordinate = loc.location.coordinate;
            [self loadData];
        }];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    //    ShopListViewController *vc = [[ShopListViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
}
@end
