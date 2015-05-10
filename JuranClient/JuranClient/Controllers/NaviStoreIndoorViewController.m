//
//  NaviStoreIndoorViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/4/24.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "NaviStoreIndoorViewController.h"
#import "JRStore.h"
#import "UIImageView+Download.h"
#import "UIImageView+WebCache.h"
#import "VIPhotoView.h"

@interface NaviStoreIndoorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet VIPhotoView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *labelHeader;
@property (strong, nonatomic) NSArray *halls;
@property (copy, nonatomic) NSString *selectedUrl;
@property (assign, nonatomic) BOOL openState;
@end

@implementation NaviStoreIndoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //_imageView.backgroundColor = [UIColor greenColor];
    _tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewClick:)];
    [_headerView addGestureRecognizer:gesture];
    _tableView.tableHeaderView = _headerView;
    _openState = NO;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    NSDictionary *param = @{@"storeCode": _store.storeCode,
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SHOP_INDOOR parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _halls = [JRStoreHall buildUpWithValueForList:[data valueForKey:@"appHallDtoList"]];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    CGRect frame = CGRectZero;
//    frame = _tableView.frame;
//    if (_openState) {
//        frame.size.height = self.view.frame.size.height;
//        _tableView.frame = frame;
//        return [[_halls[section] floorList] count];
//    }else {
//        frame.size.height = 44;
//        _tableView.frame = frame;
//        return 0;
//    }
    return _openState ? [[_halls[section] floorList] count] : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _halls.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text =[NSString stringWithFormat:@"%@ %@",[_halls[indexPath.section] name],[[_halls[indexPath.section] floorList][indexPath.row] name]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JRStoreHall *hall = _halls[indexPath.section];
    _labelHeader.text = [NSString stringWithFormat:@"%@ %@ ▼",hall.name,[[hall floorList][indexPath.row] name]];
    //[_imageView setImageWithURLString:[[hall floorList][indexPath.row] floorPhoto]];
    //NSString *urlString =[Public imageURLString:[[hall floorList][indexPath.row] floorPhoto]];
    NSURL *url = [Public imageURL:[[hall floorList][indexPath.row] floorPhoto]];
    CGRect frame = _imgView.frame;
    _imgView = [_imgView initWithFrame:frame andImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
    //[_imgView.imageView setImageWithURLString:[[hall floorList][indexPath.row] floorPhoto]];
    [self headerViewClick:nil];
}

- (void)headerViewClick:(id)sender {
    _openState = !_openState;
    _tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:_openState ? 0.6 : 0];
    CGRect frame = _tableView.frame;
    frame.size.height = _openState ? self.view.frame.size.height : 44;
    _tableView.frame = frame;
    _labelHeader.text = _openState ? [_labelHeader.text stringByReplacingOccurrencesOfString:@"▼" withString:@"▲"] : [_labelHeader.text stringByReplacingOccurrencesOfString:@"▲" withString:@"▼"];
    [_tableView reloadData];
}

@end
