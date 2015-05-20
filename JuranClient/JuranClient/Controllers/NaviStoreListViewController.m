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
#import "ProductFilterViewController.h"
#import "GlobalPopupAlert.h"
#import "UIAlertView+Blocks.h"
#import "KxMenu.h"

@interface NaviStoreListViewController ()<BMKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelCity;
@property (strong, nonatomic) IBOutlet UITableView *tableViewStore;
@property (strong, nonatomic) IBOutlet UIButton *btnChangeCity;
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) BMKPointAnnotation *selfAnnotation;
@property (strong, nonatomic) NSString *cityName;
//@property (strong, nonatomic) UserLocation *location;
- (IBAction)naviLeftClick:(id)sender;
- (IBAction)naviRightClick:(id)sender;
- (IBAction)changeCityClick:(id)sender;

@end

@implementation NaviStoreListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataList = nil;
        _naviType = NaviTypeStore;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableViewStore registerNib:[UINib nibWithNibName:@"NaviStoreCell" bundle:nil] forCellReuseIdentifier:@"NaviStoreCell"];
    _cityName = @"北京市";
    if(ApplicationDelegate.gLocation.isSuccessLocation)
        _btnChangeCity.hidden = YES;
    if (_naviType == NaviTypeStore) {
        self.navigationItem.title = @"门店导航";
    }else {
        self.navigationItem.title = @"店铺位置";
    }
    [self CheckLoctionStatus];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    
    NSDictionary *param;
    NSString *url;
    if (_naviType == NaviTypeStore) {
        param = @{@"cityName": _cityName};
        url = JR_NAVI_STORE_LIST;
    }else{
        param = @{@"shopId": @(_shopId),@"cityName": _cityName};
        url = JR_SHOP_LOCATION;
    }
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
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
    [_mapView removeAnnotation:_selfAnnotation];
    if (ApplicationDelegate.gLocation.isSuccessLocation) {
        _selfAnnotation = [[BMKPointAnnotation alloc]init];
        _selfAnnotation.coordinate = ApplicationDelegate.gLocation.location.coordinate;
        _selfAnnotation.title = @"我的位置";
        [_mapView addAnnotation:_selfAnnotation];
    }
    for (JRStore *store in _dataList) {
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(store.latitude, store.longitude);
        annotation.title = _naviType == NaviTypeStore ? store.storeName :store.stallName;
        [_mapView addAnnotation:annotation];
    }
    _labelCity.text = [NSString stringWithFormat:@"当前城市：%@",_cityName];
    if (!ApplicationDelegate.gLocation.isSuccessLocation) {
        _btnChangeCity.hidden = NO;
    }
    [_tableViewStore reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    if (_naviType == NaviTypeStore) {
        cell.labelName.text = store.storeName;
    }else {
        cell.labelName.text = store.stallName;
    }
    if (ApplicationDelegate.gLocation.isSuccessLocation) {
//        BMKMapPoint pointStore = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(store.latitude, store.longitude));
//        BMKMapPoint pointSelf = BMKMapPointForCoordinate(_selfAnnotation.coordinate);
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:store.latitude longitude:store.longitude];
        double distance = [ApplicationDelegate.gLocation.location distanceFromLocation:location];
        //CLLocationDistance distance = BMKMetersBetweenMapPoints(pointStore,pointSelf);
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
    info.naviType = _naviType;
    info.store = store;
    [self.navigationController pushViewController:info animated:YES];
}

- (IBAction)naviLeftClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)naviRightClick:(id)sender {
    [self showAppMenu:nil];
    //    ProductFilterViewController *vc = [[ProductFilterViewController alloc]initWithKeyword:nil Sort:9 Store:nil IsInShop:NO ShopId:0];
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changeCityClick:(id)sender {
    NaviStoreSelCityViewController *vc = [[NaviStoreSelCityViewController alloc] init];
    [vc setFinishBlock:^(JRAreaInfo *areaInfo) {
        //ApplicationDelegate.gLocation.cityName = areaInfo.cityName;
        _cityName = areaInfo.cityName;
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

- (void)CheckLoctionStatus {
    if(!ApplicationDelegate.gLocation.isSuccessLocation) {
        [UIAlertView showWithTitle:nil message:@"当前定位服务未开启,请在设置中启用定位服务" cancelButtonTitle:@"知道了" otherButtonTitles:nil tapBlock:nil];
    }
}
@end
