//
//  OrderListViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/2/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderListViewController.h"
#import "JROrder.h"
#import "OrderCell.h"
#import "MJRefresh.h"
#import "OrderDetailViewController.h"
#import "OrderFilterViewController.h"
#import "ContractViewController.h"

@interface OrderListViewController () <UITableViewDataSource, UITableViewDelegate, OrderFilterViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) IBOutlet UIView *emptyView;

//Designer
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UIButton *leftButton;
@property (nonatomic, strong) IBOutlet UIButton *rightButton;
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) NSMutableArray *filterSelecteds;
@property (nonatomic, strong) NSMutableArray *designerFilterSelecteds;

@end

@implementation OrderListViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的订单";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:kNotificationNameOrderReloadData object:nil];
    
    CGRect frame = kContentFrameWithoutNavigationBar;
    
#ifdef kJuranDesigner
    [self.view addSubview:_headerView];
    frame.size.height = CGRectGetHeight(frame) - CGRectGetHeight(_headerView.frame);
    frame.origin.y = CGRectGetHeight(_headerView.frame);
    
    _footerView.hidden = YES;
    _footerView.frame = CGRectMake(0, kWindowHeightWithoutNavigationBar - 40, kWindowWidth, 40);
    [self.view addSubview:_footerView];
    
    self.filterButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onFilter) title:@"筛选" image:nil];
    [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_filterButton];
#endif
    
    self.tableView = [self.view tableViewWithFrame:frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(237, 237, 237);
    [self.view addSubview:_tableView];
    
    _emptyView.center = self.view.center;
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
    
#ifdef kJuranDesigner
    self.isLeft = YES;
#else
    [_tableView headerBeginRefreshing];
#endif
}

#ifdef kJuranDesigner
- (void)setIsLeft:(BOOL)isLeft{
    _isLeft = isLeft;
    
    [_leftButton setTitleColor:_isLeft ? kBlueColor : RGBColor(64, 65, 64) forState:UIControlStateNormal];
    [_rightButton setTitleColor:_isLeft ? RGBColor(64, 65, 64) : kBlueColor forState:UIControlStateNormal];
    
    CGRect frame = kContentFrameWithoutNavigationBar;
    frame.size.height = CGRectGetHeight(frame) - CGRectGetHeight(_headerView.frame) - (_isLeft?0:(CGRectGetHeight(_footerView.frame)));
    frame.origin.y = CGRectGetHeight(_headerView.frame);
    _tableView.frame = frame;
    _footerView.hidden = _isLeft;
    
    [_tableView headerBeginRefreshing];
}

- (IBAction)onSwitch:(UIButton *)btn{
    if ((_isLeft && [btn isEqual:_leftButton]) || (!_isLeft && [btn isEqual:_rightButton]) ) {
        return;
    }
    
    self.isLeft = !_isLeft;
}

- (void)onFilter{
    OrderFilterViewController *ov = [[OrderFilterViewController alloc] init];
    ov.selecteds = _isLeft ? self.filterSelecteds : self.designerFilterSelecteds;
    ov.isDesigner = !_isLeft;
    ov.delegate = self;
    [self.navigationController pushViewController:ov animated:YES];
}

#endif

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

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: @{@"pageNo": @(_currentPage),
                            @"onePageCount": kOnePageCount,
                            @"userType": [[ALTheme sharedTheme] userType]
                            }];
#ifdef kJuranDesigner
    [param setObject:[NSString stringWithFormat:@"%d", !_isLeft] forKey:@"type"];
//    [param addEntriesFromDictionary:_filterDict];
    
    NSMutableArray *selecteds = _isLeft ? _filterSelecteds : _designerFilterSelecteds;
    
    NSInteger status = [[selecteds firstObject] integerValue];
    if (status > 0) {
        NSArray *statuses = [[DefaultData sharedData] objectForKey:_isLeft ? @"orderStatus" : @"orderDesignerStatus"];
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
    JROrder *order = [_datas objectAtIndex:indexPath.row];
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.order = order;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
