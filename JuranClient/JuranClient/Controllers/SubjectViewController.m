//
//  TopicViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SubjectViewController.h"
#import "SubjectCell.h"
#import "JRSubject.h"
#import "SubjectDetailViewController.h"

@interface SubjectViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-search"] rightBarButtonItemAction:@selector(onSearch)];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(236, 236, 236);
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf loadData];
    }];
    
    [_tableView headerBeginRefreshing];
}

- (void)onSearch{
}

- (void)loadData{
    NSDictionary *param = @{@"subjectScope": @"2"};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SUBJECT_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *projectList = [data objectForKey:@"infoSubjectRespList"];
            self.datas = [JRSubject buildUpWithValue:projectList];
            
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [_datas count] - 1) {
        return 175;
    }
    
    return 170;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SubjectCell";
    SubjectCell *cell = (SubjectCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (SubjectCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRSubject *c = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithSubject:c];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SubjectDetailViewController *detail = [[SubjectDetailViewController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    JRSubject *c = [_datas objectAtIndex:indexPath.row];
    detail.subject = c;
    [self.navigationController pushViewController:detail animated:YES];
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
