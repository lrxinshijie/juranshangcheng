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
#import "NaviStoreSelCityViewController.h"
#import "JRAreaInfo.h"

@interface NaviStoreListViewController ()
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *labelCity;
@property (strong, nonatomic) IBOutlet UITableView *tableViewStore;
@property (strong, nonatomic) IBOutlet UIView *viewCitySelection;
@property (strong, nonatomic) IBOutlet UIButton *btnChangeCity;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCity;
@property (strong, nonatomic) BMKLocationService *locService;
@property (strong, nonatomic) BMKPointAnnotation *selfAnnotation;
@property (strong, nonatomic) BMKGeoCodeSearch *geoSearch;
@property (strong, nonatomic) NSArray *dataList;
@property (copy, nonatomic) NSString *currentCity;
@property (assign, nonatomic) BOOL isLocSuccess;
- (IBAction)naviLeftClick:(id)sender;
- (IBAction)naviRightClick:(id)sender;
- (IBAction)changeCityClick:(id)sender;

@end

@implementation NaviStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"门店导航";
    [_tableViewStore registerNib:[UINib nibWithNibName:@"NaviStoreCell" bundle:nil] forCellReuseIdentifier:@"NaviStoreCell"];
    _textFieldCity.inputView = _viewCitySelection;
    _btnChangeCity.hidden = YES;
    _geoSearch = [[BMKGeoCodeSearch alloc]init];
    _geoSearch.delegate = (id)self;
    //_mapView.showsUserLocation = YES;//显示定位图层
    _locService = [[BMKLocationService alloc]init];
    [BMKLocationService setLocationDistanceFilter:100.f];
    _locService.delegate = (id)self;
    [self showHUD];
    _currentCity = @"北京市";
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    NSDictionary *param = @{@"cityName": _currentCity};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_NAVI_STORE_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ((NSNull *)data != [NSNull null]) {
                _dataList = [JRStore buildUpWithValueForList:[data objectForKey:@"shopAddDtoList"]];
                [_locService startUserLocationService];
            }
            else {
                _dataList = nil;
                [_locService startUserLocationService];
            }
        }
    }];
}



- (void)reloadView {
    _mapView.zoomLevel = 11;
    
    for (BMKPointAnnotation* ann in _mapView.annotations) {
        if (ann && ann!=_selfAnnotation) {
            [_mapView removeAnnotation:ann];
        }
    }
    for (JRStore *store in _dataList) {
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(store.latitude, store.longitude);
        annotation.title = store.storeShortName;
        [_mapView addAnnotation:annotation];
    }
    [_tableViewStore reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [_mapView viewWillAppear];
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = (id)self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self hideHUD];
    [_locService stopUserLocationService];
        _isLocSuccess = true;
    //[_mapView updateLocationData:userLocation];
    _selfAnnotation = [[BMKPointAnnotation alloc]init];
    _selfAnnotation.coordinate = userLocation.location.coordinate;
    _selfAnnotation.title = @"你的位置";
    _mapView.centerCoordinate = _selfAnnotation.coordinate;
    [_mapView addAnnotation:_selfAnnotation];
    BMKReverseGeoCodeOption *geo = [[BMKReverseGeoCodeOption alloc]init];
    geo.reverseGeoPoint = userLocation.location.coordinate;
    [_geoSearch reverseGeoCode:geo];
}

- (void) didFailToLocateUserWithError:(NSError *)error {
    [self hideHUD];
    [_locService stopUserLocationService];
    _isLocSuccess = NO;
    _btnChangeCity.hidden = NO;
    [self reloadView];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (!error) {
        _labelCity.text = [NSString stringWithFormat:@"当前城市：%@",result.addressDetail.city];
    }
    [self reloadView];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = annotation==_selfAnnotation?BMKPinAnnotationColorRed:BMKPinAnnotationColorGreen;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
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
    cell.labelName.text = store.storeShortName;
    BMKMapPoint pointStore = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(store.latitude, store.longitude));
    BMKMapPoint pointSelf = BMKMapPointForCoordinate(_selfAnnotation.coordinate);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(pointStore,pointSelf);
    if (_isLocSuccess) {
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
    NSLog(@"RightClick");
}

- (IBAction)changeCityClick:(id)sender {
//    if ([_textFieldCity isFirstResponder]) {
//        [_textFieldCity resignFirstResponder];
//    }else {
//        [_textFieldCity becomeFirstResponder];
//    }
    NaviStoreSelCityViewController *vc = [[NaviStoreSelCityViewController alloc] init];
    [vc setFinishBlock:^(JRAreaInfo *areaInfo) {
        _currentCity = areaInfo.cityName;
        [self loadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
