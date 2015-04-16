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

@interface NaviStoreListViewController ()
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *labelCity;
@property (strong, nonatomic) IBOutlet UITableView *tableViewStore;
@property (strong, nonatomic) IBOutlet UIView *viewCitySelection;
@property (strong, nonatomic) IBOutlet UIButton *btnChangeCity;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCity;
@property (strong, nonatomic) BMKLocationService *locService;
@property (strong, nonatomic) BMKPointAnnotation* selfAnnotation;
@property (strong, nonatomic) NSMutableArray* dataList;
- (IBAction)naviLeftClick:(id)sender;
- (IBAction)naviRightClick:(id)sender;
- (IBAction)changeCityClick:(id)sender;

@end

@implementation NaviStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"门店导航";
    self.navigationController.navigationBarHidden = YES;
    [_tableViewStore registerNib:[UINib nibWithNibName:@"NaviStoreCell" bundle:nil] forCellReuseIdentifier:@"NaviStoreCell"];
    _textFieldCity.inputView = _viewCitySelection;
    _locService = [[BMKLocationService alloc]init];
    [BMKLocationService setLocationDistanceFilter:100.f];
    _locService.delegate = (id)self;
    _mapView.showsUserLocation = YES;//显示定位图层
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    NSDictionary *param = @{@"cityName": @"北京市"};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_NAVI_STORE_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _dataList = [JRStore buildUpWithValueForList:[data objectForKey:@"shopAddDtoList"]];
        }
    }];
}

- (void)reloadUI {
    _mapView.zoomLevel = 12;
    if (_selfAnnotation != nil) {
        [_mapView removeAnnotation:_selfAnnotation];
    }
    [_locService startUserLocationService];
    [_tableViewStore reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = (id)self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    _selfAnnotation.coordinate = userLocation.location.coordinate;
    _selfAnnotation.title = @"你在这里";
    _mapView.centerCoordinate = _selfAnnotation.coordinate;
    [_mapView addAnnotation:_selfAnnotation];
    [_locService stopUserLocationService];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
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
    cell.labelName.text = store.storeShortName;
    BMKMapPoint pointStore = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915,116.404));
    BMKMapPoint pointSelf = BMKMapPointForCoordinate(_selfAnnotation.coordinate);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(pointStore,pointSelf);
    cell.labelDistance.text = [NSString stringWithFormat:@"%.2f",distance];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableViewStore deselectRowAtIndexPath:indexPath animated:YES];
    NaviStoreInfoViewController *info = [[NaviStoreInfoViewController alloc]init];
    [self.navigationController pushViewController:info animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"XX市";
}

- (IBAction)naviLeftClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)naviRightClick:(id)sender {
    NSLog(@"RightClick");
}

- (IBAction)changeCityClick:(id)sender {
    if ([_textFieldCity isFirstResponder]) {
        [_textFieldCity resignFirstResponder];
    }else {
        [_textFieldCity becomeFirstResponder];
    }
}
@end
