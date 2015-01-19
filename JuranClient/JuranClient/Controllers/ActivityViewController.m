//
//  ActivityViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityCell.h"
#import "JRActivity.h"
#import "ActivityDetailViewController.h"
#import "JRWebViewController.h"

@interface ActivityViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *emptyView;
@property (nonatomic, strong) ActivityCell *activityCell;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"精品活动";
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _emptyView.hidden = YES;
    _emptyView.center = _tableView.center;
    [self.view addSubview:_emptyView];
    
    [self loadData];
}

- (void)loadData{
    NSString *scope = @"2";
    NSDictionary *param = @{@"activityScope": scope};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_ACTIVITY_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            self.datas = [JRActivity buildUpWithValue:data[@"infoActivityRespList"]];
            [_tableView reloadData];
        }
        _emptyView.hidden = _datas.count != 0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ActivityCell";
    ActivityCell *cell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (ActivityCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRActivity *a = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithActivity:a];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JRActivity *a = [_datas objectAtIndex:indexPath.row];
    [self.activityCell fillCellWithActivity:a];
    return self.activityCell.contentView.frame.size.height + ((indexPath.row == _datas.count - 1)?10:0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JRActivity *a = [_datas objectAtIndex:indexPath.row];
    ActivityDetailViewController *vc = [[ActivityDetailViewController alloc] init];
    vc.title = @"精品活动";
    vc.urlString = [NSString stringWithFormat:@"http://apph5.juran.cn/events/%d%@", a.activityId, [Public shareEnv]];
    [vc setShareTitle:a.activityName Content:a.activityIntro ImagePath:a.activityListUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

- (ActivityCell*)activityCell{
    if (_activityCell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:self options:nil];
        _activityCell = (ActivityCell *)[nibs firstObject];
    }
    return _activityCell;
}

@end
