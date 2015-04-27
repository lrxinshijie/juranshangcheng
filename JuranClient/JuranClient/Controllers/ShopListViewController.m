//
//  ShopListViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopListCell.h"
#import "ShopHomeViewController.h"
#import "JRShop.h"

@interface ShopListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation ShopListViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _cityName = @"北京市";
        _keyword = @"";
        _sort = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView registerNib:[UINib nibWithNibName:@"ShopListCell" bundle:nil] forCellReuseIdentifier:@"ShopListCell"];
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    [_tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    NSDictionary *param = @{@"cityName": _cityName,
                            @"keyword": _keyword,
                            @"sort": @(_sort),
                            @"pageNo": @(_currentPage),
                            @"onePageCount": @(10)
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SEARCH_SHOP parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"No"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSMutableArray *rows =[JRShop buildUpWithValueForShopList:[data objectForKey:@"appShopInfoList"]];
            
            if (_currentPage > 1) {
                [_dataList addObjectsFromArray:rows];
            }else{
                _dataList = rows;
            }
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopListCell *cell = (ShopListCell *)[tableView dequeueReusableCellWithIdentifier:@"ShopListCell"];
    
    NSInteger row = [indexPath row];
    JRShop *shop = [_dataList objectAtIndex:row];
    [cell fillCellWithJRShop:shop];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopHomeViewController *vc = [[ShopHomeViewController alloc]init];
    JRShop *shop = [_dataList objectAtIndex:[indexPath row]];
    vc.shop.shopId = shop.shopId;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
