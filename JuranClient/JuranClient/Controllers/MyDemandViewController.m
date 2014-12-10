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

@interface MyDemandViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;


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
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
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
    
    [_tableView headerBeginRefreshing];
    
}

- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": @"10"};
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
            
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
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
    return 175;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
//    detailVC.designer = _datas[indexPath.row];
//    detailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
