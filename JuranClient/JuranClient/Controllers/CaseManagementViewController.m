//
//  CaseManagementViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/2.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CaseManagementViewController.h"
#import "CaseManagementCell.h"
#import "CaseImageManagemanetViewController.h"
#import "JRCase.h"
#import "CaseIntroduceViewController.h"

@interface CaseManagementViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;


@end

@implementation CaseManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"案例管理";
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
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
    
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"nav-icon-share"] rightBarButtonItemAction:@selector(onAdd)];
}

- (void)onAdd{
    CaseIntroduceViewController *cv = [[CaseIntroduceViewController alloc] init];
    [self.navigationController pushViewController:cv animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": kOnePageCount};
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_DEPROJECTLISTREQ  parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(YES)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *projectList = [data objectForKey:@"projectList"];
            NSMutableArray *rows = [JRCase buildUpWithValueForManagement:projectList];
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

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseManagementCell";
    CaseManagementCell *cell = (CaseManagementCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CaseManagementCell *)[nibs firstObject];
    }
    
    [cell fillCellWithValue:_datas[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CaseImageManagemanetViewController *vc = [[CaseImageManagemanetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
