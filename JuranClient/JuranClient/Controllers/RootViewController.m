//
//  RootViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "RootViewController.h"
#import "JRCase.h"
#import "CaseCell.h"
#import "CaseDetailViewController.h"
#import "JRAdInfo.h"
#import "EScrollerView.h"
#import "JRPhotoScrollViewController.h"
#import "JRWebViewController.h"


@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *adInfos;
@property (nonatomic, strong) EScrollerView *bannerView;
@property (nonatomic, strong) IBOutlet UIView *menuView;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo"]];
    
    [self configureLeftBarButtonItemImage:[UIImage imageNamed:@"icon-scan"] leftBarButtonItemAction:@selector(onScan)];
    
    UIButton *searchButton = [self.view buttonWithFrame:CGRectMake(0, 0, 35, 35) target:self action:@selector(onSearch) image:[UIImage imageNamed:@"icon-search"]];
    UIButton *moreButton = [self.view buttonWithFrame:CGRectMake(35, 0, 35, 35) target:self action:@selector(onMore) image:[UIImage imageNamed:@"icon-dot"]];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [rightView addSubview:searchButton];
    [rightView addSubview:moreButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

- (void)onScan{
    //TODO: 扫一扫入口
}

- (void)onSearch{
    
}

- (void)onMore{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
