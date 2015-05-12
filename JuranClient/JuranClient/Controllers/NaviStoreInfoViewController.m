//
//  NaviStoreInfoViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/4/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "NaviStoreInfoViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "JRStore.h"
#import "AppDelegate.h"
#import "UserLocation.h"
#import "NaviStoreIndoorViewController.h"
#import "UIViewController+Menu.h"
#import "MapScrollView.h"

@interface NaviStoreInfoViewController ()<BMKMapViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *mapBottomView;
@property (strong, nonatomic) IBOutlet UIView *naviControlView;
@property (strong, nonatomic) IBOutlet UIView *addrView;
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UIView *busView;
@property (strong, nonatomic) IBOutlet UIView *telView;
@property (strong, nonatomic) IBOutlet MapScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance;
@property (strong, nonatomic) IBOutlet UILabel *labelAddrTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelAddr;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UILabel *labelBus;
@property (strong, nonatomic) IBOutlet UILabel *labelTel;
@property (strong, nonatomic) IBOutlet UIButton *buttonLeft;
@property (strong, nonatomic) IBOutlet UIButton *buttonRight;
@property (strong, nonatomic) IBOutlet UIImageView *imageNode;
@property (strong, nonatomic) BMKPointAnnotation *selfAnnotation;
@property (strong, nonatomic) BMKPointAnnotation *storeAnnotation;
@property (strong, nonatomic) NSMutableArray *availableMaps;

- (IBAction)leftNaviClick:(id)sender;
- (IBAction)rightNaviClick:(id)sender;
- (IBAction)SystemNaviClick:(id)sender;
- (IBAction)IndoorNaviClick:(id)sender;
@end

@implementation NaviStoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"门店详情";
    self.navigationController.navigationBarHidden = YES;
    _scrollView.contentSize = CGSizeMake(kWindowWidth, kWindowHeight+kWindowWidth/2);
    _scrollView.canCancelContentTouches = NO;//是否可以中断touches
    //_scrollView.delaysContentTouches = NO;//是否延迟touches事件
    _mapBottomView.frame = CGRectMake(0, kWindowWidth-29, kWindowWidth, 29);
    _mapBottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi-bottom-bg.png"]];
    [_scrollView addSubview:_mapBottomView];
    
    _naviControlView.frame = CGRectMake(0, kWindowWidth, kWindowWidth, 52);
    [_scrollView addSubview:_naviControlView];
    
    CGRect frame = CGRectZero;
    frame = _naviControlView.frame;
    frame.origin.y = _naviControlView.frame.origin.y+_naviControlView.frame.size.height;
    frame.size.height = _addrView.frame.size.height;
    _addrView.frame = frame;
    [_scrollView addSubview:_addrView];
    
    frame = _addrView.frame;
    frame.origin.y = _addrView.frame.origin.y+_addrView.frame.size.height;
    frame.size.height = _timeView.frame.size.height;
    _timeView.frame = frame;
    [_scrollView addSubview:_timeView];
    
    frame = _timeView.frame;
    frame.origin.y = _timeView.frame.origin.y+_timeView.frame.size.height;
    frame.size.height = _busView.frame.size.height;
    _busView.frame = frame;
    [_scrollView addSubview:_busView];
    
    frame = _busView.frame;
    frame.origin.y = _busView.frame.origin.y+_busView.frame.size.height;
    frame.size.height = _telView.frame.size.height;
    _telView.frame = frame;
    [_scrollView addSubview:_telView];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect mapFrame = _mapView.frame;
    mapFrame.origin.y = scrollView.contentOffset.y/2;
    ASLog(@"%f",scrollView.contentOffset.y);
    self.navigationController.navigationBar.backgroundColor = [self.navigationController.navigationBar.backgroundColor colorWithAlphaComponent:scrollView.contentOffset.y/140];
    _mapView.frame = mapFrame;
}

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated  {
    // 如果进入的是当前视图控制器
    if (viewController == self) {
        // 背景设置为黑色
        self.navigationController.navigationBar. tintColor  = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
        // 透明度设置为0.3
        self.navigationController.navigationBar. alpha  = 0.300;
        // 设置为半透明
        self.navigationController.navigationBar. translucent  =  YES ;
    } else {
        // 进入其他视图控制器
        self.navigationController.navigationBar.alpha = 1;
        // 背景颜色设置为系统 默认颜色
        self.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
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

- (void)loadData{
    NSDictionary *param = @{@"storeCode": [NSString stringWithFormat:@"%@",_store.storeCode],
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_NAVI_STORE_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _store = [_store initWithDictionaryForInfo:data];
            [self reloadView];
        }
    }];
}

- (void)reloadView {
    if (_selfAnnotation) {
        [_mapView removeAnnotation:_selfAnnotation];
    }
    _selfAnnotation = [[BMKPointAnnotation alloc]init];
    _selfAnnotation.coordinate = ApplicationDelegate.gLocation.location.coordinate;
    _selfAnnotation.title = @"你的位置";
    //_mapView.centerCoordinate = _selfAnnotation.coordinate;
    [_mapView addAnnotation:_selfAnnotation];
    
    if (_storeAnnotation) {
        [_mapView removeAnnotation:_storeAnnotation];
    }
    _storeAnnotation = [[BMKPointAnnotation alloc]init];
    _storeAnnotation.coordinate = CLLocationCoordinate2DMake(_store.latitude, _store.longitude);
    _storeAnnotation.title = _store.storeName;
    [_mapView addAnnotation:_storeAnnotation];
    if (_naviType == NaviTypeStore) {
        _labelName.text = _store.storeName;
    }else {
        _labelName.text = _store.stallName;
    }
    
    if (ApplicationDelegate.gLocation.isSuccessLocation) {
        _imageNode.image = [UIImage imageNamed:@"icon-map-node.png"];
        BMKMapPoint pointStore = BMKMapPointForCoordinate(_storeAnnotation.coordinate);
        BMKMapPoint pointSelf = BMKMapPointForCoordinate(_selfAnnotation.coordinate);
        _labelDistance.text = [NSString stringWithFormat:@"%.2fkm",BMKMetersBetweenMapPoints(pointStore,pointSelf)/1000];
    }else {
        _imageNode.image = nil;
        _labelDistance.text = @"";
    }
    
    CGRect frame = CGRectZero;
    if (_naviType == NaviTypeStore) {
        _labelAddrTitle.text = @"门店地址";
    }else {
        _labelAddrTitle.text = @"摊位地址";
    }
    _labelAddr.text = _store.storeAdd;
    [_labelAddr sizeToFit];
    frame = _naviControlView.frame;
    frame.origin.y = _naviControlView.frame.origin.y+_naviControlView.frame.size.height;
    frame.size.height =_labelAddr.frame.size.height>13?(_addrView.frame.size.height + _labelAddr.frame.size.height - 13):_labelAddr.frame.size.height;
    _addrView.frame = frame;
    
    _labelTime.text =  [self formatString:_store.saleTime];
    [_labelTime sizeToFit];
    frame = _addrView.frame;
    frame.origin.y = _addrView.frame.origin.y+_addrView.frame.size.height;
    frame.size.height =_labelTime.frame.size.height>13?(_timeView.frame.size.height + _labelTime.frame.size.height - 13):_telView.frame.size.height;
    _timeView.frame = frame;
    
    _labelBus.text = [self formatString:_store.busRoute];
    [_labelBus sizeToFit];
    frame = _timeView.frame;
    frame.origin.y = _timeView.frame.origin.y+_timeView.frame.size.height;
    frame.size.height =_labelBus.frame.size.height>13?(_busView.frame.size.height + _labelBus.frame.size.height - 13):_busView.frame.size.height;
    _busView.frame = frame;
    
    _labelTel.text = [self formatString:_store.contactTelephone];
    [_labelTel sizeToFit];
    frame = _busView.frame;
    frame.origin.y = _busView.frame.origin.y+_busView.frame.size.height;
    frame.size.height =_labelTel.frame.size.height>13?(_telView.frame.size.height + _labelTel.frame.size.height - 13):_telView.frame.size.height;
    _telView.frame = frame;
}

- (NSString *)formatString:(NSString *)string {
    string =  [string stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    string =  [string stringByReplacingOccurrencesOfString:@"；" withString:@"\n"];
    string =  [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

- (void)availableMapsApps {
    [self.availableMaps removeAllObjects];
    
    CLLocationCoordinate2D startCoor = _selfAnnotation.coordinate;
    CLLocationCoordinate2D endCoor = _storeAnnotation.coordinate;
    NSString *toName = _store.storeName;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",
                               startCoor.latitude, startCoor.longitude, endCoor.latitude, endCoor.longitude, toName];
        
        NSDictionary *dic = @{@"name": @"百度地图",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",
                               @"云华时代", endCoor.latitude, endCoor.longitude];
        
        NSDictionary *dic = @{@"name": @"高德地图",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f¢er=%f,%f&directionsmode=transit", endCoor.latitude, endCoor.longitude, startCoor.latitude, startCoor.longitude];
        
        NSDictionary *dic = @{@"name": @"Google Maps",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //CLLocationCoordinate2D startCoor = _selfAnnotation.coordinate;
        CLLocationCoordinate2D endCoor = _storeAnnotation.coordinate;
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
        toLocation.name = _store.storeName;
        
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        
        
    }else if (buttonIndex < self.availableMaps.count+1) {
        NSDictionary *mapDic = self.availableMaps[buttonIndex-1];
        NSString *urlString = mapDic[@"url"];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }
}



- (IBAction)leftNaviClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightNaviClick:(id)sender {
    [self showAppMenu:nil];
}

- (IBAction)SystemNaviClick:(id)sender {
//    [self availableMapsApps];
//    UIActionSheet *action = [[UIActionSheet alloc] init];
//    
//    [action addButtonWithTitle:@"使用系统自带地图导航"];
//    for (NSDictionary *dic in self.availableMaps) {
//        [action addButtonWithTitle:[NSString stringWithFormat:@"使用%@导航", dic[@"name"]]];
//    }
//    [action addButtonWithTitle:@"取消"];
//    action.cancelButtonIndex = self.availableMaps.count + 1;
//    action.delegate = self;
//    [action showInView:self.view];
    if (!ApplicationDelegate.gLocation.isSuccessLocation) {
        [self showTip:@"定位失败"];
        return;
    }
    CLLocationCoordinate2D endCoor = _storeAnnotation.coordinate;
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
    toLocation.name = _store.storeName;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

- (IBAction)IndoorNaviClick:(id)sender {
    NaviStoreIndoorViewController *vc = [[NaviStoreIndoorViewController alloc]init];
    vc.store = _store;
    vc.navigationItem.title = [NSString stringWithFormat:@"%@室内地图",_store.storeName];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
