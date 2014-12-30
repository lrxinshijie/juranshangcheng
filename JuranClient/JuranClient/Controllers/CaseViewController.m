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
#import "JRWebViewController.h"
#import "DesignerDetailViewController.h"
#import "SubjectDetailViewController.h"
#import "DesignerViewController.h"
#import "JRDesigner.h"
#import "JRSubject.h"

@interface CaseViewController () <UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate, FilterViewDelegate, UIScrollViewDelegate>{
    CGFloat startOffsetY;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *adInfos;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) EScrollerView *bannerView;
@property (nonatomic, strong) FilterView *filterView;


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
    
    if (_isHome) {
        [self configureMenu];
        [self configureSearch];
        
    }else{
        if ( _searchKey.length == 0) {
            self.navigationItem.title = @"";
        }else{
            self.navigationItem.title = @"搜索结果";
        }
    }
    
    self.filterView = [[FilterView alloc] initWithType:FilterViewTypeCase defaultData:_filterData];
    _filterView.delegate = self;
    [self.view addSubview:_filterView];
    
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, 44, kWindowWidth, (!_isHome ? kWindowHeightWithoutNavigationBar : kWindowHeightWithoutNavigationBarAndTabbar) -44) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(236, 236, 236);
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        if (weakSelf.isHome) {
            [weakSelf loadAd];
        }else{
            [weakSelf loadData];
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
                
                self.bannerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 44, kWindowWidth, 165) ImageArray:_adInfos];
                _bannerView.delegate = self;
                
                self.tableView.tableHeaderView = _bannerView;
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
    [[ALEngine shareEngine] pathURL: !_isHome && _searchKey.length > 0 ? JR_SEARCH_CASE : JR_PROLIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
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
    
    JRAdInfo *ad = [_adInfos objectAtIndex:index];
    ASLog(@"index:%d,%@",index,ad.link);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSArray *links = [ad.link componentsSeparatedByString:@"&"];
    [links enumerateObjectsUsingBlock:^(NSString *link, NSUInteger idx, BOOL *stop) {
        NSArray *values = [link componentsSeparatedByString:@"="];
        if ([values count] == 2) {
            [param setObject:[values lastObject] forKey:[values firstObject]];
        }
    }];
    ASLog(@"param:%@",param);
    NSInteger type = [param getIntValueForKey:@"type" defaultValue:0];
    if (type == 1) {
        [_tableView headerBeginRefreshing];
    }else if (type == 2){
        if ([param.allKeys containsObject:@"id"]) {
            DesignerDetailViewController *dv = [[DesignerDetailViewController alloc] init];
            JRDesigner *designer = [[JRDesigner alloc] init];
            designer.userId = [param getIntValueForKey:@"id" defaultValue:0];
            dv.designer = designer;
            dv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dv animated:YES];
        }else{
            DesignerViewController *cv = [[DesignerViewController alloc] init];
            NSMutableDictionary *filterData = [NSMutableDictionary dictionaryWithDictionary:param];
            [filterData removeObjectForKey:@"type"];
            cv.filterData = filterData;
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
        }
    }else if (type == 7){
        JRWebViewController *wv = [[JRWebViewController alloc] init];
        wv.urlString = [param getStringValueForKey:@"url" defaultValue:@""];
        wv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wv animated:YES];
    }else if (type == 6){
        SubjectDetailViewController *sd = [[SubjectDetailViewController alloc] init];
        JRSubject *subject = [[JRSubject alloc] init];
        subject.key = [param getIntValueForKey:@"id" defaultValue:0];
        sd.subject = subject;
        sd.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sd animated:YES];
    }else if (type == 3){
        if ([param.allKeys containsObject:@"id"]) {
            JRCase *jrCase = [[JRCase alloc] init];
            jrCase.projectId = [param getStringValueForKey:@"id" defaultValue:@""];
            JRPhotoScrollViewController *dv = [[JRPhotoScrollViewController alloc] initWithJRCase:jrCase andStartWithPhotoAtIndex:0];
            dv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dv animated:YES];
        }else{
            CaseViewController *cv = [[CaseViewController alloc] init];
            NSMutableDictionary *filterData = [NSMutableDictionary dictionaryWithDictionary:param];
            [filterData removeObjectForKey:@"type"];
            cv.filterData = filterData;
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
        }
    }
//    NSArray *types = [[links firstObject] componentsSeparatedByString:@"="];
//    if ([types count] == 0) {
//        NSInteger type = [[types lastObject] integerValue];
//        if (type == 1) {
//            
//        }
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
