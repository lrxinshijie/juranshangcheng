//
//  BidManagementViewController.m
//  JuranClient
//
//  Created by HuangKai on 15-1-8.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "BidManagementViewController.h"
#import "DemandDetailViewController.h"
#import "JRDemand.h"
#import "DemandCell.h"
#import "InputView.h"

@interface BidManagementViewController ()<UITableViewDelegate, UITableViewDataSource, DemandCellDelegate>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *doingDatas;
@property (nonatomic, strong) NSMutableArray *doneDatas;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;

@property (nonatomic, strong) IBOutlet UIView *emptyView;

@property (nonatomic, strong) InputView *inputView;

@end

@implementation BidManagementViewController

- (void)dealloc{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReloadDataNotification:) name:kNotificationNameMyDemandReloadData object:nil];
    
    self.navigationItem.title = @"应标管理";
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    
    _emptyView.hidden = YES;
    _emptyView.center = _tableView.center;
    [self.view addSubview:_emptyView];
    
    _inputView =  [[InputView alloc] init];
    [self.view addSubview:_inputView];
    
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

- (void)receiveReloadDataNotification:(NSNotification*)notification{
    [_tableView headerBeginRefreshing];
}

- (void)loadData{
    NSString *status = _segment.selectedSegmentIndex == 0?@"goingon":@"finished";
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage]
                            ,@"onePageCount": kOnePageCount
                            ,@"status": status
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_DEDESIGNER_BIDLIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *designReqList = [data objectForKey:@"deDesignerBidReqList"];
            NSMutableArray *rows = [JRDemand buildUpWithValue:designReqList];
            if (_currentPage > 1) {
                
                [_segment.selectedSegmentIndex?_doneDatas:_doingDatas  addObjectsFromArray:rows];
            }else{
                if (_segment.selectedSegmentIndex == 1) {
                    self.doneDatas = rows;
                }else{
                    self.doingDatas = rows;
                }
            }
        }
         [self reloadData];
        _emptyView.hidden = (_segment.selectedSegmentIndex == 0 ? _doingDatas.count: _doneDatas.count) != 0;
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
}

- (void)reloadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

- (IBAction)segmentValueChange:(id)sender{
    _currentPage = 1;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _segment.selectedSegmentIndex == 0?_doingDatas.count:_doneDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 175;
    JRDemand *d = nil;
    if (_segment.selectedSegmentIndex == 1) {
        d = _doneDatas[indexPath.row];
        
        height += (indexPath.row == (_doneDatas.count - 1)?5:0);
    }else{
        d = _doingDatas[indexPath.row];
        height += (indexPath.row == (_doingDatas.count - 1)?5:0);
    }
    height += [[NSString stringWithFormat:@"备注：%@", d.memo] heightWithFont:[UIFont systemFontOfSize:12] constrainedToWidth:300] + 10;
    return height;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DemandCell";
    DemandCell *cell = (DemandCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (DemandCell *)[nibs firstObject];
    }
    cell.delegate = self;
    if (_segment.selectedSegmentIndex == 0) {
        JRDemand *d = [_doingDatas objectAtIndex:indexPath.row];
        [cell fillCellWithDemand:d];
    }else{
        JRDemand *d = [_doneDatas objectAtIndex:indexPath.row];
        [cell fillCellWithDemand:d];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JRDemand *demand = nil;
    if (_segment.selectedSegmentIndex == 1) {
        demand = _doneDatas[indexPath.row];
    }else{
        demand = _doingDatas[indexPath.row];
    }
    demand.newBidNums = 0;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    DemandDetailViewController *vc = [[DemandDetailViewController alloc] init];
    vc.demand = demand;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editRemark:(DemandCell *)cell AndDemand:(JRDemand *)demand{
    [_inputView showWithTitle:@"写备注" placeHolder:@"" content:demand.memo block:^(id result) {
        NSDictionary *param = @{@"bidReqId": demand.bidId
                                ,@"memo": result
                                };
        [self showHUD];
        [[ALEngine shareEngine] pathURL:JR_EDIT_BID_MEMO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
            [self hideHUD];
            if (!error) {
                demand.memo = result;
                [self reloadData];
            }
        }];
    }];
}


@end
