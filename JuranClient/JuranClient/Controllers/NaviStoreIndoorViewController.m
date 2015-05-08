//
//  NaviStoreIndoorViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/4/24.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "NaviStoreIndoorViewController.h"
#import "JRStore.h"

@interface NaviStoreIndoorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (assign, nonatomic) BOOL openState;
@property (strong, nonatomic) IBOutlet UILabel *labelHeader;

@end

@implementation NaviStoreIndoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imageView.backgroundColor = [UIColor greenColor];
    _tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewClick:)];
    [_headerView addGestureRecognizer:gesture];
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
            JRStoreHall *hall = [JRStoreHall buildUpWithValueForList:data];
            
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CGRect frame = CGRectZero;
    frame = _tableView.frame;
    if (_openState) {
        frame.size.height = self.view.frame.size.height;
        _tableView.frame = frame;
        return 6;
    }else {
        frame.size.height = 44;
        _tableView.frame = frame;
        return 0;
    }
    
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
    cell.textLabel.text = [NSString stringWithFormat:@"1号厅%ldF",(long)[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _labelHeader.text = [NSString stringWithFormat:@"1号厅%ldF ▼",(long)[indexPath row]];
    [self headerViewClick:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {
    return _headerView;
}

- (void)headerViewClick:(id)sender {
    _openState = !_openState;
    //[_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView reloadData];
}
@end
