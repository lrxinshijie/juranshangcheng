//
//  MyDemandViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-1.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "MyDemandViewController.h"
#import "DemandCell.h"
#import "JRDemand.h"
#import "DemandDetailViewController.h"
#import "PublishDesignViewController.h"

@interface MyDemandViewController ()<UITableViewDelegate, UITableViewDataSource, DemandDetailViewControllerDelegate>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) IBOutlet UIView *emptyDataView;


@end

@implementation MyDemandViewController

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
    
    self.navigationItem.title = @"我的需求";
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 80, 30) target:self action:@selector(onPublishDemand) title:@"发布新需求" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame))];
    _emptyDataView.backgroundColor = RGBColor(241, 241, 241);
    CGPoint center = CGPointMake(bgView.center.x, 220);
    _emptyDataView.center = center;
    _emptyDataView.hidden = NO;
    [bgView addSubview:_emptyDataView];
    _tableView.backgroundView = bgView;
    
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

- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": kOnePageCount};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_MYREQUESTLIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *designReqList = [data objectForKey:@"designReqList"];
            NSMutableArray *rows = [JRDemand buildUpWithValue:designReqList];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = [JRDemand buildUpWithValue:designReqList];
            }
            [self reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
}

- (void)reloadData{
    _emptyDataView.hidden = (_datas.count != 0);
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"DemandCell";
    DemandCell *cell = (DemandCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (DemandCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRDemand *d = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithDemand:d];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175 + (indexPath.row == (_datas.count - 1)?5:0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DemandDetailViewController *vc = [[DemandDetailViewController alloc] init];
    vc.delegate = self;
    vc.demand = _datas[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DemandDetailViewControllerDelegate

- (void)valueChangedWithDemandDetailVC:(DemandDetailViewController *)vc{
    [_tableView headerBeginRefreshing];
}

@end
