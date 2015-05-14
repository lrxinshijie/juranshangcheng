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
#import "CustomSearchBar.h"
#import "AppDelegate.h"
#import "UserLocation.h"
#import "UIViewController+Menu.h"
#import "DesignerViewController.h"
#import "CaseViewController.h"
#import "QuestionViewController.h"
#import "ProductListViewController.h"
#import "ProductFilterData.h"
#import "ProductSeletedFilter.h"


@interface ShopListViewController ()<CustomSearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *emptyView;

@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) CustomSearchBar *searchBar;

@end

@implementation ShopListViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
#ifndef kJuranDesigner
        _cityName = ApplicationDelegate.gLocation.cityName;
#endif
        _keyword = @"";
        _sort = 9;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchBar = [[[NSBundle mainBundle] loadNibNamed:@"CustomSearchBar" owner:self options:nil] lastObject];
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    [self.searchBar setTextFieldText:_keyword];
    [self.searchBar rightButtonChangeStyleWithKey:RightBtnStyle_More];
    self.searchBar.delegate = self;
    self.searchBar.parentVC = self;
    [self.searchBar setSearchButtonType:SearchButtonType_Shop];
    [self.searchBar setEnabled:NO];
    [self.view addSubview:self.searchBar];
    
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

- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar addSubview:self.searchBar];
//    self.navigationController.navigationBar.clipsToBounds = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.searchBar removeFromSuperview];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)showMenuList
{
     [self showAppMenu:nil];
}

- (void)goBackButtonDidSelect
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startSearchWithKeyWord:(NSString *)keyWord index:(int)index {
    if (index == 0){
        CaseViewController *vc = [[CaseViewController alloc] init];
        vc.searchKey = keyWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1){
        ProductListViewController *vc = [[ProductListViewController alloc]init];
        vc.selectedFilter.keyword = _keyword;
        vc.selectedFilter.isInShop = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 2){
        _keyword = keyWord;
        [_tableView headerBeginRefreshing];
    }else if (index == 3) {
        DesignerViewController *vc = [[DesignerViewController alloc] init];
        vc.searchKeyWord = keyWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 4){
        QuestionViewController *vc = [[QuestionViewController alloc] init];
        vc.searchKeyWord = keyWord;
        vc.isSearchResult = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
                            @"onePageCount": kOnePageCount
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
            [_emptyView removeFromSuperview];
            if(_dataList.count == 0) {
                _emptyView.center = CGPointMake(_tableView.center.x, 200);
                [_tableView addSubview:_emptyView];
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
    vc.shop = shop;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
