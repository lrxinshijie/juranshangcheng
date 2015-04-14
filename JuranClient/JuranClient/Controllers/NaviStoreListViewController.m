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

@interface NaviStoreListViewController ()
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *labelCity;
@property (strong, nonatomic) IBOutlet UITableView *tableViewStore;
@property (strong, nonatomic) BMKLocationService *locService;
@property (strong, nonatomic) BMKPointAnnotation* selfAnnotation;
- (IBAction)naviLeftClick:(id)sender;
- (IBAction)naviRightClick:(id)sender;

@end

@implementation NaviStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"门店导航";
    self.navigationController.navigationBarHidden = YES;
    [_tableViewStore registerNib:[UINib nibWithNibName:@"NaviStoreCell" bundle:nil] forCellReuseIdentifier:@"NaviStoreCell"];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = (id)self;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = YES;//显示定位图层
    _selfAnnotation = [[BMKPointAnnotation alloc]init];
    [_mapView addAnnotation:_selfAnnotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //_mapView.showsUserLocation = YES;
    //[_mapView updateLocationData:userLocation];
    CLLocationCoordinate2D coor = userLocation.location.coordinate;
    _selfAnnotation.coordinate = coor;
    _selfAnnotation.title = @"你在这里";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NaviStoreCell *cell = (NaviStoreCell *)[tableView dequeueReusableCellWithIdentifier:@"NaviStoreCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableViewStore deselectRowAtIndexPath:indexPath animated:YES];
    NaviStoreInfoViewController *info = [[NaviStoreInfoViewController alloc]init];
    [self.navigationController pushViewController:info animated:YES];
}

- (IBAction)naviLeftClick:(id)sender {
    NSLog(@"LeftClick");
}

- (IBAction)naviRightClick:(id)sender {
    NSLog(@"RightClick");
}
@end
