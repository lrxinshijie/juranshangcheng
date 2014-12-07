//
//  CaseViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "CaseViewController.h"
#import "JRCase.h"
#import "CaseCell.h"
#import "CaseDetailViewController.h"
#import "JRAdInfo.h"
#import "EScrollerView.h"
#import "JRPhotoScrollViewController.h"
#import "FilterView.h"

@interface CaseViewController () <UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate, FilterViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *adInfos;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) EScrollerView *bannerView;
@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableDictionary *filterData;

@end

@implementation CaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"案例";
    
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-search"] rightBarButtonItemAction:@selector(onSearch)];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(236, 236, 236);
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadAd];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    [_tableView headerBeginRefreshing];
    
}

- (void)onSearch{
    [self checkLogin:^{
        [_tableView headerBeginRefreshing];
    }];
}

- (void)loadAd{
    NSDictionary *param = @{@"adCode": @"app_consumer_index_roll",
                            @"areaCode": @""};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_GET_BANNER_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *bannerList = [data objectForKey:@"bannerList"];
            self.adInfos = [JRAdInfo buildUpWithValue:bannerList];
            [_adInfos addObjectsFromArray:_adInfos];
            
            if (!_headerView) {
                UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 165+44)];
                
                self.filterView = [[FilterView alloc] initWithType:FilterViewTypeCase defaultData:_filterData];
                _filterView.delegate = self;
                [headerView addSubview:_filterView];
                
                self.bannerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 44, kWindowWidth, 165) ImageArray:_adInfos];
                _bannerView.delegate = self;
                [headerView addSubview:_bannerView];
                self.headerView = headerView;
                
                self.tableView.tableHeaderView = _headerView;
            }
            
        }
        [self loadData];
    }];
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": @"20"}];
    [param addEntriesFromDictionary:self.filterData];
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_PROLIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *projectList = [data objectForKey:@"projectList"];
            NSMutableArray *rows = [JRCase buildUpWithValue:projectList];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = [JRCase buildUpWithValue:projectList];
            }
            
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        if (_currentPage == 1) {
            _tableView.contentOffset = CGPointMake(0, CGRectGetHeight(_filterView.frame));
        }
        
    }];
}

- (NSMutableDictionary *)filterData{
    if (!_filterData) {
        _filterData = [NSMutableDictionary dictionaryWithDictionary:@{@"projectStyle": @"",
                        @"roomType": @"",
                        @"houseArea" : @"",
                        @"order": @""}];
    }
    return _filterData;
}

- (void)clickFilterView:(FilterView *)view actionType:(FilterViewAction)action returnData:(NSDictionary *)data{
    [data.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [_filterData setObject:data[key] forKey:key];
    }];
    
    [_tableView headerBeginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [_datas count] - 1) {
        return 275;
    }
    
    return 270;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseCell";
    CaseCell *cell = (CaseCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CaseCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRCase *c = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithCase:c];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    JRCase *cs = [_datas objectAtIndex:indexPath.row];
    
    [cs loadDetail:^(BOOL result) {
        if (result) {
            JRPhotoScrollViewController *vc = [[JRPhotoScrollViewController alloc] initWithJRCase:cs andStartWithPhotoAtIndex:0];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)EScrollerViewDidClicked:(NSUInteger)index{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
