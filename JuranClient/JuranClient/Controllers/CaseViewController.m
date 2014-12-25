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

@interface CaseViewController () <UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate, FilterViewDelegate, UIScrollViewDelegate>{
    CGFloat startOffsetY;
}

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

- (void)dealloc{

}

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
    
    if (_searchKey.length == 0) {
        [self configureMenu];
        [self configureSearch];
        
    }else{
        self.navigationItem.title = _searchKey;
    }
    
    
    self.tableView = [self.view tableViewWithFrame:_searchKey.length > 0 ? kContentFrameWithoutNavigationBar : kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(236, 236, 236);
    [self.view addSubview:_tableView];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    self.filterView = [[FilterView alloc] initWithType:FilterViewTypeCase defaultData:_filterData];
    _filterView.delegate = self;
    [_headerView addSubview:_filterView];
    _tableView.tableHeaderView = _headerView;
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        if (weakSelf.searchKey.length > 0) {
            [weakSelf loadData];
        }else{
            [weakSelf loadAd];
        }
        
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    [_tableView headerBeginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_filterView isShow]) {
        [_filterView showSort];
    }
}

- (void)loadAd{
    NSDictionary *param = @{@"adCode": @"app_consumer_index_roll",
                            @"areaCode": @"110000",
                            @"type": @(7)};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_GET_BANNER_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *bannerList = [data objectForKey:@"bannerList"];
            if (bannerList.count > 0) {
                self.adInfos = [JRAdInfo buildUpWithValue:bannerList];
//                [_adInfos addObjectsFromArray:_adInfos];
                
                CGRect frame = _headerView.frame;
                frame.size.height = 165 + 44;
                _headerView.frame = frame;
                
                self.bannerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 44, kWindowWidth, 165) ImageArray:_adInfos];
                _bannerView.delegate = self;
                [_headerView addSubview:_bannerView];
                
                self.tableView.tableHeaderView = _headerView;
            }
            
        }
        [self loadData];
    }];
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": kOnePageCount}];
    [param addEntriesFromDictionary:self.filterData];
    
    if (_searchKey.length > 0) {
        [param setObject:_searchKey forKey:@"keyword"];
    }
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:_searchKey.length > 0 ? JR_SEARCH_CASE : JR_PROLIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *projectList = [data objectForKey:@"projectGeneralDtoList"];
            NSMutableArray *rows = [JRCase buildUpWithValue:projectList];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = rows;
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
        NSDictionary *param = nil;
        if (_searchKey.length > 0) {
            param = [[DefaultData sharedData] objectForKey:@"caseSearchDefaultParam"];
        }else{
            param = [[DefaultData sharedData] objectForKey:@"caseDefaultParam"];
        }
        _filterData = [NSMutableDictionary dictionaryWithDictionary:param];
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
    CaseCell *cell = (CaseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CaseCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRCase *c = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithCase:c];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    startOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0 && y < 44) {
        [scrollView setContentOffset:CGPointMake(0, startOffsetY > y ? 0 : 44) animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0 && y < 44) {
        [scrollView setContentOffset:CGPointMake(0, startOffsetY > y ? 0 : 44) animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    JRCase *cs = [_datas objectAtIndex:indexPath.row];
    
    JRPhotoScrollViewController *vc = [[JRPhotoScrollViewController alloc] initWithJRCase:cs andStartWithPhotoAtIndex:0];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)EScrollerViewDidClicked:(NSUInteger)index{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
