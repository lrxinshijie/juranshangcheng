//
//  InteractionViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "InteractionViewController.h"
#import "InteractionCell.h"

@interface InteractionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *caseDatas;
@property (nonatomic, strong) NSMutableArray *topicDatas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) IBOutlet UIView *noDatasView;

@end

@implementation InteractionViewController

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
    
    self.navigationItem.title = @"互动管理";
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame))];
    bgView.backgroundColor = RGBColor(241, 241, 241);
    CGPoint center = CGPointMake(bgView.center.x, 220);
    _noDatasView.center = center;
    _noDatasView.hidden = YES;
    [bgView addSubview:_noDatasView];
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
    NSString *url = _segment.selectedSegmentIndex == 0?JR_MYQUESTION:JR_MYANSWER;
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            //            if (_segment.selectedSegmentIndex == 0) {
            //                NSArray *datas = [data objectForKey:@"questionList"];
            //                NSMutableArray *rows = [JRQuestion buildUpWithValue:datas];
            //                if (_currentPage > 1) {
            //                    [_questionDatas addObjectsFromArray:rows];
            //                }else{
            //                    self.questionDatas = [JRQuestion buildUpWithValue:datas];
            //                }
            //            }else{
            //                NSArray *datas = [data objectForKey:@"myAnswerList"];
            //                NSMutableArray *rows = [JRAnswer buildUpWithValue:datas];
            //                if (_currentPage > 1) {
            //                    [_answerDatas addObjectsFromArray:rows];
            //                }else{
            //                    self.answerDatas = [JRAnswer buildUpWithValue:datas];
            //                }
            //            }
            
            [self reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
}

- (void)reloadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        if (_segment.selectedSegmentIndex == 0) {
            _noDatasView.hidden = YES;
            if (_caseDatas.count == 0) {
//                _noDatasView.hidden = NO;
            }
        }else{
            _noDatasView.hidden = YES;
            if (_topicDatas.count == 0) {
//                _noDatasView.hidden = NO;
            }
        }
    });
}

- (IBAction)segmentValueChange:(id)sender{
    self.navigationItem.title = _segment.selectedSegmentIndex == 0?@"互动管理":@"我的评论";
    _currentPage = 1;
    [self loadData];
}


- (void)didReceiveMemoryWarning
{
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
    return 5;
    return _segment.selectedSegmentIndex == 0?_caseDatas.count:_topicDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145 + (indexPath.row == 4?5:0);
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"InteractionCell";
    InteractionCell *cell = (InteractionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (InteractionCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_segment.selectedSegmentIndex == 0) {
//        JRQuestion *q = _questionDatas[indexPath.row];
//        [cell fillCellWithQuestion:q];
    }else{
//        JRAnswer *r = _answerDatas[indexPath.row];
//        [cell fillCellWithAnswer:r];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
    //    detailVC.designer = _datas[indexPath.row];
    //    detailVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
