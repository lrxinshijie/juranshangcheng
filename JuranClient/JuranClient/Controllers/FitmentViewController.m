//
//  FitmentViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "FitmentViewController.h"
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
#import "CaseCollectionCell.h"
#import "YIFullScreenScroll.h"
#import "JRSegmentControl.h"
#import "DesignerCell.h"

@interface FitmentViewController () <UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate, FilterViewDelegate, UIScrollViewDelegate, YIFullScreenScrollDelegate, JRSegmentControlDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) JRSegmentControl *segment;
@property (nonatomic, strong) IBOutlet UIView *emptyView;

@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) FilterView *designerFilterView;

@end

@implementation FitmentViewController

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"家装";
    
    
    [self configureScan];
    [self setupUI];
    
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureSearchAndMore];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_filterView isShow]) {
        [_filterView showSort];
    }
    if ([_designerFilterView isShow]) {
        [_designerFilterView showSort];
    }
}

- (void)setupUI{
    self.segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40)];
    _segment.delegate = self;
    _segment.showUnderLine = YES;
    _segment.selectedBackgroundViewXMargin = 8;
    [_segment setTitleList:@[@"案例", @"设计师"]];
    [self.view addSubview:_segment];
    
    self.filterView = [[FilterView alloc] initWithType:FilterViewTypeCaseWithoutGrid defaultData:self.filterData];
    _filterView.xMargin = CGRectGetHeight(_segment.frame);
    _filterView.frame = CGRectMake(0, CGRectGetMaxY(_segment.frame), kWindowWidth, 44);
    _filterView.delegate = self;
    [self.view addSubview:_filterView];
    
    self.designerFilterView = [[FilterView alloc] initWithType:FilterViewTypeDesigner defaultData:self.designerFilterData];
    _designerFilterView.xMargin = CGRectGetHeight(_segment.frame);
    _designerFilterView.frame = _filterView.frame;
    _designerFilterView.delegate = self;
    _designerFilterView.hidden = YES;
    [self.view addSubview:_designerFilterView];
    
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, CGRectGetMaxY(_filterView.frame), kWindowWidth, kWindowHeightWithoutNavigationBarAndTabbar - CGRectGetMaxY(_filterView.frame)) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(236, 236, 236);
    [self.view addSubview:_tableView];
    
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": kOnePageCount}];
    NSString *url = nil;
    if (_segment.selectedIndex == 0) {
        url = JR_PROLIST;
        [param addEntriesFromDictionary:self.filterData];
    }else{
        url = JR_DESIGNERLIST;
        [param addEntriesFromDictionary:self.designerFilterData];
    }
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSMutableArray *rows = nil;
            if (_segment.selectedIndex == 0) {
                rows = [JRCase buildUpWithValue:[data objectForKey:@"projectGeneralDtoList"]];
            }else{
                rows = [JRDesigner buildUpWithValue:[data objectForKey:@"designerSearchResDtoList"]];
            }
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = rows;
            }
        }
        [self reloadData];
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
    }];
}

- (void)reloadData{
    [_emptyView removeFromSuperview];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    if ([_datas count] > 5) {
        self.fullScreenScroll.scrollView = _tableView;
    }else{
        self.fullScreenScroll.scrollView = nil;
    }
    
    if (_datas.count == 0) {
        CGRect frame = CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBarAndTabbar - 44);
        frame.size.height -= CGRectGetHeight(_tableView.tableHeaderView.frame);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        _emptyView.center = view.center;
        [view addSubview:_emptyView];
        _tableView.tableFooterView = view;
        
    }
    
    [_tableView reloadData];
}

- (void)showCase{
    if (_segment) {
        _segment.selectedIndex = 0;
    }
}

#pragma mark - CaseFilter

- (NSMutableDictionary *)filterData{
    if (!_filterData) {
        NSDictionary *param = [[DefaultData sharedData] objectForKey:@"caseDefaultParam"];
        _filterData = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    return _filterData;
}

- (NSMutableDictionary*)designerFilterData{
    if (!_designerFilterData) {
        NSDictionary *param = [[DefaultData sharedData] objectForKey:@"designerDefaultParam"];
        _designerFilterData = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    return _designerFilterData;
}

- (void)clickFilterView:(FilterView *)view actionType:(FilterViewAction)action returnData:(NSDictionary *)data{
    if (view == _filterView) {
        if (action != FilterViewActionGrid) {
            [data.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                [_filterData setObject:data[key] forKey:key];
            }];
        }
    }else{
        [data.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            [_designerFilterData setObject:data[key] forKey:key];
        }];
    }
     [_tableView headerBeginRefreshing];
    
}

#pragma mark - JRSegmentControlDelegate

- (void)segmentControl:(JRSegmentControl *)segment changedSelectedIndex:(NSInteger)index{
    if (_datas) {
        [_datas removeAllObjects];
        [_tableView reloadData];
    }
    _designerFilterView.hidden = index == 0;
    _filterView.hidden = index != 0;
    [_tableView headerBeginRefreshing];
    if ([_filterView isShow]) {
        [_filterView showSort];
    }
    if ([_designerFilterView isShow]) {
        [_designerFilterView showSort];
    }
}

#pragma mark - UITableViewDelegateDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedIndex == 0) {
        return 270 + ((indexPath.row == [_datas count] - 1)?5:0);
    }else{
        return 135 + ((indexPath.row == _datas.count - 1)?5:0);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedIndex == 0) {
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
    }else{
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedIndex == 0) {
        JRCase *cs = [_datas objectAtIndex:indexPath.row];
        if ([cs isKindOfClass:[JRCase class]]) {
            JRPhotoScrollViewController *vc = [[JRPhotoScrollViewController alloc] initWithJRCase:cs andStartWithPhotoAtIndex:0];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        JRDesigner *designer = [_datas objectAtIndex:indexPath.row];
        if ([designer isKindOfClass:[JRDesigner class]]) {
            DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
            detailVC.designer = _datas[indexPath.row];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    [self.fullScreenScroll showUIBarsAnimated:YES];
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
