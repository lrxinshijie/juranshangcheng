//
//  DesignerViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DesignerViewController.h"
#import "DesignerDetailViewController.h"
#import "DesignerCell.h"
#import "JRDesigner.h"
#import "JRPhotoScrollViewController.h"
#import "JRWebImageDataSource.h"
#import "FilterView.h"
#import "SearchViewController.h"

@interface DesignerViewController ()<UITableViewDataSource, UITableViewDelegate, FilterViewDelegate>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) NSMutableDictionary *filterData;


@end

@implementation DesignerViewController

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
    if (!_isSearchResult) {
        [self configureMenu];
        [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-search"] rightBarButtonItemAction:@selector(onSearch)];
    }else{
        self.navigationItem.title = _searchKeyWord;
    }
    
    self.tableView = [self.view tableViewWithFrame:_isSearchResult? kContentFrameWithoutNavigationBar:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    self.filterView = [[FilterView alloc] initWithType:FilterViewTypeDesigner defaultData:_filterData];
    _filterView.delegate = self;
    _tableView.tableHeaderView = _filterView;
    
    [_tableView headerBeginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_filterView isShow]) {
        [_filterView showSort];
    }
}

- (NSMutableDictionary *)filterData{
    if (!_filterData) {
        _filterData = [NSMutableDictionary dictionaryWithDictionary:@{@"experience": @"",
                                                                      @"isRealNameAuth": @"",
                                                                      @"style" : @"",
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

- (void)onSearch{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.type = SearchTypeDesigner;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": kOnePageCount}];
    [param addEntriesFromDictionary:self.filterData];
    if (_isSearchResult) {
        [param setObject:_searchKeyWord forKey:@"keyword"];
        [param removeObjectForKey:@"experience"];
        [param removeObjectForKey:@"isRealNameAuth"];
    }
    NSString *url = _isSearchResult?JR_SEARCH_DESIGNER:JR_DESIGNERLIST;
    [self showHUD];
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            
            NSMutableArray *rows = [JRDesigner buildUpWithValue:[data objectForKey:@"designerSearchResDtoList"]];
            
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DesignerCell";
    DesignerCell *cell = (DesignerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (DesignerCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRDesigner *d = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithDesigner:d];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135 + ((indexPath.row == _datas.count - 1)?5:0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
    detailVC.designer = _datas[indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
