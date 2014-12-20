//
//  MyFollowViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "MyFollowViewController.h"
#import "JRUser.h"
#import "JRDesigner.h"
#import "DesignerCell.h"
#import "DesignerDetailViewController.h"

@interface MyFollowViewController ()<UITableViewDelegate, UITableViewDataSource, DesignerDetailViewControllerDelegate>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation MyFollowViewController

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
    
    self.navigationItem.title = @"我的关注";
    
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
                            @"onePageCount": kOnePageCount};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GETFOLLOWLIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSMutableArray *rows = [JRDesigner buildUpWithValue:[data objectForKey:@"designerSearchResDtoList"]];
                if (_currentPage > 1) {
                    [_datas addObjectsFromArray:rows];
                }else{
                    self.datas = rows;
                }
                
                [_tableView reloadData];
            }
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

#pragma mark - DesignerDetailViewControllerDelegate

- (void)changeFollowStatus:(DesignerDetailViewController *)vc withDesigner:(JRDesigner *)designer status:(BOOL)isFollow{
    if (!isFollow) {
        NSInteger row = [_datas indexOfObject:designer];
        [_datas removeObject:designer];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        NSInteger row = _datas.count;
        [_datas addObject:designer];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DesignerCell";
    DesignerCell *cell = (DesignerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (DesignerCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRDesigner *c = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithDesigner:c];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135 + ((indexPath.row == _datas.count - 1)?5:0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
    detailVC.delegate = self;
    detailVC.designer = _datas[indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
