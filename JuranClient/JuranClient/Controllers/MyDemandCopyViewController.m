//
//  MyDemandCopyViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/4/17.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "MyDemandCopyViewController.h"
#import "DemandCell.h"
#import "ConstructCell.h"
#import "JRDemand.h"
#import "DemandDetailViewController.h"
#import "PublishDesignViewController.h"
#import "JRSegmentControl.h"
#import "ConstructDetailViewController.h"

@interface MyDemandCopyViewController ()<UITableViewDelegate, UITableViewDataSource,JRSegmentControlDelegate>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) IBOutlet UIView *emptyDataView;
@property (nonatomic, strong) JRSegmentControl *segment;


@end

@implementation MyDemandCopyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReloadDataNotification:) name:kNotificationNameMyDemandReloadData object:nil];
    
    self.navigationItem.title = @"我的需求";
    
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 80, 30) target:self action:@selector(onPublishDemand) title:@"发布新需求" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self setupUI];
    
    [_tableView headerBeginRefreshing];
    
}

- (void)setupUI{
    self.segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40)];
    _segment.delegate = self;
    _segment.showUnderLine = YES;
    _segment.showVerticalSeparator = YES;
    [_segment setTitleList:@[@"设计需求", @"装修需求"]];
    [self.view addSubview:_segment];
    
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, 40, kWindowWidth, kWindowHeightWithoutNavigationBar - 40) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _emptyDataView.hidden = YES;
    _emptyDataView.center = _tableView.center;
    [self.view addSubview:_emptyDataView];
    
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

- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": kOnePageCount};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:_segment.selectedIndex?JR_NEEDS_LIST:JR_GET_MYREQUESTLIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *designReqList = [data objectForKey:_segment.selectedIndex==0?@"needsList":@"designReqList"];
            NSMutableArray *rows = [JRDemand buildUpWithValue:designReqList];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = rows;
            }
            [self reloadData];
        }
        _emptyDataView.hidden = _datas.count != 0;
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
}

- (void)reloadData{
    [_tableView reloadData];
}

- (void)receiveReloadDataNotification:(NSNotification*)notification{
    [_tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JRSegmentControlDelegate

- (void)segmentControl:(JRSegmentControl *)segment changedSelectedIndex:(NSInteger)index{
    if (_datas) {
        [_datas removeAllObjects];
        [_tableView reloadData];
    }
    [_tableView headerBeginRefreshing];
}

#pragma mark - Target Action

- (void)onPublishDemand{
    PublishDesignViewController *vc = [[PublishDesignViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedIndex == 0) {
        static NSString *CellIdentifier = @"DemandCell";
        DemandCell *cell = (DemandCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (DemandCell *)[nibs firstObject];
        }
        
        //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        JRDemand *d = [_datas objectAtIndex:indexPath.row];
        [cell fillCellWithDemand:d];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"ConstructCell";
        ConstructCell *cell = (ConstructCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (ConstructCell *)[nibs firstObject];
        }
        
        //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        JRDemand *d = [_datas objectAtIndex:indexPath.row];
        [cell fillCellWithValue:nil];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedIndex == 0) {
        return 175 + (indexPath.row == (_datas.count - 1)?5:0);
    }else{
        return 220 + (indexPath.row == (_datas.count - 1)?5:0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_segment.selectedIndex == 0) {
        JRDemand *demand = _datas[indexPath.row];
        demand.newBidNums = 0;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        DemandDetailViewController *vc = [[DemandDetailViewController alloc] init];
        vc.demand = demand;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ConstructDetailViewController *vc = [[ConstructDetailViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
