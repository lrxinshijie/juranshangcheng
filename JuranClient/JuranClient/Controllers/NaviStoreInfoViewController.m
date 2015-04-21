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

@interface NaviStoreInfoViewController ()
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *mapBottomView;
@property (strong, nonatomic) IBOutlet UIView *naviControlView;
@property (strong, nonatomic) IBOutlet UIView *addrView;
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UIView *busView;
@property (strong, nonatomic) IBOutlet UIView *telView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance;
@property (strong, nonatomic) IBOutlet UILabel *labelAddr;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UILabel *labelBus;
@property (strong, nonatomic) IBOutlet UILabel *labelTel;
@property (strong, nonatomic) IBOutlet UIButton *buttonLeft;
@property (strong, nonatomic) IBOutlet UIButton *buttonRight;
@property (strong, nonatomic) IBOutlet UIImageView *imageNode;
@property (strong, nonatomic) BMKLocationService *locService;
@property (strong, nonatomic) BMKPointAnnotation *selfAnnotation;
@property (strong, nonatomic) BMKPointAnnotation *storeAnnotation;
@property (assign, nonatomic) CLLocationDistance distance;
@property (assign, nonatomic) BOOL isLocSuccess;

- (IBAction)leftNaviClick:(id)sender;
- (IBAction)rightNaviClick:(id)sender;
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
    _mapView.showsUserLocation = YES;//显示定位图层
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
    
    _locService = [[BMKLocationService alloc]init];
    [BMKLocationService setLocationDistanceFilter:100.f];
    _locService.delegate = (id)self;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.y);
    CGRect mapFrame = _mapView.frame;
    mapFrame.origin.y = scrollView.contentOffset.y/2;
    _mapView.frame = mapFrame;
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

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_locService stopUserLocationService];
    _isLocSuccess = YES;
    //[_mapView updateLocationData:userLocation];
    _selfAnnotation = [[BMKPointAnnotation alloc]init];
    _selfAnnotation.coordinate = userLocation.location.coordinate;
    _selfAnnotation.title = @"你的位置";
    //_mapView.centerCoordinate = _selfAnnotation.coordinate;
    [_mapView addAnnotation:_selfAnnotation];
    [self reloadView];
}

- (void) didFailToLocateUserWithError:(NSError *)error {
    _isLocSuccess = NO;
    [_locService stopUserLocationService];
    //[self reloadView];
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

- (void)loadData{
    NSDictionary *param = @{@"storeCode": [NSString stringWithFormat:@"%@",_store.storeCode],
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_NAVI_STORE_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _store = [_store initWithDictionaryForInfo:data];
            [_locService startUserLocationService];
            [self reloadView];
        }
    }];
}

- (void)reloadView {
    if (_storeAnnotation) {
        [_mapView removeAnnotation:_storeAnnotation];
    }
    _storeAnnotation = [[BMKPointAnnotation alloc]init];
    _storeAnnotation.coordinate = CLLocationCoordinate2DMake(_store.latitude, _store.longitude);
    _storeAnnotation.title = _store.storeShortName;
    [_mapView addAnnotation:_storeAnnotation];
    BMKMapPoint pointStore = BMKMapPointForCoordinate(_storeAnnotation.coordinate);
    BMKMapPoint pointSelf = BMKMapPointForCoordinate(_selfAnnotation.coordinate);
    _distance = BMKMetersBetweenMapPoints(pointStore,pointSelf);
    _labelName.text = _store.storeShortName;
    if (_isLocSuccess) {
        _imageNode.image = [UIImage imageNamed:@"icon-map-node.png"];
        _labelDistance.text = [NSString stringWithFormat:@"%.2fkm",_distance/1000];
    }else {
        _imageNode.image = nil;
        _labelDistance.text = @"";
    }
    
    CGRect frame = CGRectZero;
    
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

- (IBAction)leftNaviClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightNaviClick:(id)sender {
}
@end
