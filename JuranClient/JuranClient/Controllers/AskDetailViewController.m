//
//  AskDetailViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AskDetailViewController.h"
#import "JRQuestion.h"
#import "AnswerDetailCell.h"

@interface AskDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *answerView;

@end

@implementation AskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"我的提问";
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    
    [self.view addSubview:_answerView];
    CGRect frame = _answerView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _answerView.frame = frame;
}

- (void)loadData{
    NSDictionary *param = @{//@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"rowsPerPage": @"20"};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GETFOLLOWLIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            //            NSArray *designerList = [data objectForKey:@"designerList"];
            //            NSMutableArray *rows = [JRDesignerFollowDto buildUpWithValue:designerList];
            //            if (_currentPage > 1) {
            //                [_datas addObjectsFromArray:rows];
            //            }else{
            //                self.datas = [JRDesignerFollowDto buildUpWithValue:designerList];
            //            }
            
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AnswerDetailCell";
    AnswerDetailCell *cell = (AnswerDetailCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (AnswerDetailCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    JRDesignerFollowDto *c = [_datas objectAtIndex:indexPath.row];
    //    [cell fillCellWithDesignerFollowDto:c];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
    //    detailVC.designer = _datas[indexPath.row];
    //    detailVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
