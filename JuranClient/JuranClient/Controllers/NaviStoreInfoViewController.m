//
//  NaviStoreInfoViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/4/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "NaviStoreInfoViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface NaviStoreInfoViewController ()
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) BMKLocationService *locService;
@property (strong, nonatomic) IBOutlet UIView *mapBottomView;
@property (strong, nonatomic) IBOutlet UIView *storeInfoView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation NaviStoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"门店导航";
    self.navigationController.navigationBarHidden = YES;
    _scrollView.contentSize = CGSizeMake(kWindowWidth, kWindowHeight+kWindowWidth+20);
    _scrollView.canCancelContentTouches = NO;//是否可以中断touches
    //_scrollView.delaysContentTouches = NO;//是否延迟touches事件
    _mapView.showsUserLocation = YES;//显示定位图层
    //[_scrollView addSubview:_mapView];
    _mapBottomView.frame = CGRectMake(0, kWindowWidth-29, kWindowWidth, 29);
    _mapBottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi-bottom-bg.png"]];
    [_scrollView addSubview:_mapBottomView];

    _storeInfoView.frame = CGRectMake(0, kWindowWidth, kWindowWidth, 400);
    [_scrollView addSubview:_storeInfoView];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = (id)self;
    [_locService startUserLocationService];
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)loadData{
    NSDictionary *param = @{@"storeCode": [NSString stringWithFormat:@"%d",1001],
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:@"http://54.223.161.28:8080/shop/platformCustomerService.json" parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            
        }
    }];
}
@end
