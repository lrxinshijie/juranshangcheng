//
//  OrderListCopyViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/4/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderListCopyViewController.h"
#import "JROrder.h"
#import "OrderCell.h"
#import "MJRefresh.h"
#import "OrderDetailViewController.h"
#import "OrderFilterViewController.h"
#import "ContractViewController.h"
#import "JRSegmentControl.h"
#import "PreDisclosureInfoViewController.h"
#import "ConstructPriceListViewController.h"
#import "ConfirmItemViewController.h"

@interface OrderListCopyViewController () <UITableViewDataSource, UITableViewDelegate, OrderFilterViewControllerDelegate, JRSegmentControlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) IBOutlet UIView *emptyView;

//Designer
@property (nonatomic, strong) IBOutlet JRSegmentControl *segment;
@property (nonatomic, strong) IBOutlet UIView *footerView;

@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) NSMutableArray *filterSelecteds;
@property (nonatomic, strong) NSMutableArray *designerFilterSelecteds;

@end

@implementation OrderListCopyViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的订单";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:kNotificationNameOrderReloadData object:nil];
    
    [self setupUI];
    
    [_tableView headerBeginRefreshing];
}

- (void)setupUI{
    
    _segment.delegate = self;
    _segment.showUnderLine = YES;
    _segment.showVerticalSeparator = YES;
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(_segment.frame), kWindowWidth, kWindowHeightWithoutNavigationBar - CGRectGetMaxY(_segment.frame));
#ifdef kJuranDesigner
    _footerView.hidden = YES;
    _footerView.frame = CGRectMake(0, kWindowHeightWithoutNavigationBar - 40, kWindowWidth, 40);
    [self.view addSubview:_footerView];
    
    UIView *view = [_footerView viewWithTag:1200];
    view.layer.borderColor = kBlueColor.CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.cornerRadius = 2.f;
    
    self.filterButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onFilter) title:@"筛选" image:[UIImage imageNamed:@"order_filter"]];
    [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_filterButton];
    
    [_segment setTitleList:@[@"量房订单", @"设计订单", @"施工订单"]];
#else
    [_segment setTitleList:@[@"商城订单", @"家装订单"]];
#endif
    
    self.tableView = [self.view tableViewWithFrame:frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(237, 237, 237);
    [self.view addSubview:_tableView];
    
    _emptyView.center = _tableView.center;
    _emptyView.hidden = YES;
    [self.view addSubview:_emptyView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];

}

#ifdef kJuranDesigner
- (void)onFilter{
    OrderFilterViewController *ov = [[OrderFilterViewController alloc] init];
    if (_segment.selectedIndex == 0) {
        ov.selecteds = self.filterSelecteds;
    }else if (_segment.selectedIndex == 1){
        ov.selecteds = self.designerFilterSelecteds;
    }
    ov.isDesigner = _segment.selectedIndex == 1;
    ov.delegate = self;
    [self.navigationController pushViewController:ov animated:YES];
}

#endif

- (void)segmentControl:(JRSegmentControl *)segment changedSelectedIndex:(NSInteger)index{
    if (_datas) {
        [_datas removeAllObjects];
        [_tableView reloadData];
    }
    [_tableView headerBeginRefreshing];
}

- (IBAction)onContract:(id)sender{
    ContractViewController *vc =[[ContractViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)clickOrderFilterViewReturnData:(NSMutableArray *)selecteds{
    [_tableView headerBeginRefreshing];
}

- (void)reloadData:(NSNotification *)noti{
    if (noti.object) {
        [_tableView headerBeginRefreshing];
    }else{
        [_tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JROrder *order = [_datas objectAtIndex:indexPath.row];
    CGFloat height = [OrderCell cellHeight:order];
    return indexPath.row == _datas.count-1 ? height : height-10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"OrderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (OrderCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JROrder *order = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithOrder:order];
    
    return cell;
}

- (NSString *)urlForLoadData{
#ifdef kJuranDesigner
    if (_segment.selectedIndex == 0) {
        return JR_ORDER_LIST;
    }else if(_segment.selectedIndex == 1){
        return JR_ORDER_LIST;
    }else{
        return JR_ORDER_LIST;
    }
#else
    if (_segment.selectedIndex == 0) {
        return JR_ORDER_LIST;
    }else{
        return JR_ORDER_LIST;
    }
#endif
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: @{@"pageNo": @(_currentPage),
                                                                                  @"onePageCount": kOnePageCount,
                                                                                  @"userType": [[ALTheme sharedTheme] userType]
                                                                                  }];
#ifdef kJuranDesigner
    if (_segment.selectedIndex != 2) {
        [param setObject:[NSString stringWithFormat:@"%d", _segment.selectedIndex] forKey:@"type"];
        //    [param addEntriesFromDictionary:_filterDict];
        
        NSMutableArray *selecteds = _segment.selectedIndex == 0 ? _filterSelecteds : _designerFilterSelecteds;
        
        NSInteger status = [[selecteds firstObject] integerValue];
        if (status > 0) {
            NSArray *statuses = [[DefaultData sharedData] objectForKey:_segment.selectedIndex == 0 ? @"orderStatus" : @"orderDesignerStatus"];
            [param setObject:statuses[status][@"v"] forKey:@"status"];
        }
        
        NSInteger time = [[selecteds lastObject] integerValue];
        if (time > 0) {
            NSDate *today = [NSDate date];
            NSString *createDateTo = [today stringWithFormat:kDateFormatHorizontalLineLong];
            NSString *createDateFrom = [[today dateAfterDay:-7] stringWithFormat:kDateFormatHorizontalLineLong];
            if (time == 2){
                createDateFrom = [[today dateAfterMonth:-1]  stringWithFormat:kDateFormatHorizontalLineLong];
            }else if (time == 3){
                createDateFrom = [[today dateAfterMonth:-3]  stringWithFormat:kDateFormatHorizontalLineLong];
            }
            
            [param setObject:createDateTo forKey:@"createDateTo"];
            [param setObject:createDateFrom forKey:@"createDateFrom"];
        }
    }
#endif
    
    [[ALEngine shareEngine]  pathURL:JR_ORDER_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            NSMutableArray *rows = [JROrder buildUpWithValue:[data objectForKey:[Public isDesignerApp] ? @"designerTradeList" : @"memberTradeList"]];
            if (_currentPage == 1) {
                self.datas = rows;
            }else{
                [_datas addObjectsFromArray:rows];
            }
        }
        
        _emptyView.hidden = _datas.count != 0;
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    }];
}

- (NSMutableArray *)filterSelecteds{
    if (!_filterSelecteds) {
        _filterSelecteds = [NSMutableArray arrayWithArray:@[@(0), @(0)]];
    }
    
    return _filterSelecteds;
}

- (NSMutableArray *)designerFilterSelecteds{
    if (!_designerFilterSelecteds) {
        _designerFilterSelecteds = [NSMutableArray arrayWithArray:@[@(0), @(0)]];
    }
    
    return _designerFilterSelecteds;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
#ifndef kJuranDesigner
    ConstructPriceListViewController *cplvc = [[ConstructPriceListViewController alloc] init];
    [self.navigationController pushViewController:cplvc animated:YES];
    ConfirmItemViewController *cv = [[ConfirmItemViewController alloc] init];
    [self.navigationController pushViewController:cv animated:YES];
#endif
    return;
    
    JROrder *order = [_datas objectAtIndex:indexPath.row];
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.order = order;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
