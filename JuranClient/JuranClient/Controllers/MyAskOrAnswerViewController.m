//
//  MyAskOrAnswerViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-1.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "MyAskOrAnswerViewController.h"
#import "AskOrAnswerCell.h"
#import "JRQuestion.h"
#import "JRAnswer.h"

@interface MyAskOrAnswerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *answerDatas;
@property (nonatomic, strong) NSMutableArray *questionDatas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;

@end

@implementation MyAskOrAnswerViewController

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
    
    self.navigationItem.title = @"我的提问";
    
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
                            @"onePageCount": @"20"};
    [self showHUD];
    NSString *url = _segment.selectedSegmentIndex == 0?JR_MYQUESTION:JR_MYANSWER;
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if (_segment.selectedSegmentIndex == 0) {
                NSArray *datas = [data objectForKey:@"questionList"];
                NSMutableArray *rows = [JRQuestion buildUpWithValue:datas];
                if (_currentPage > 1) {
                    [_questionDatas addObjectsFromArray:rows];
                }else{
                    self.questionDatas = [JRQuestion buildUpWithValue:datas];
                }
            }else{
                NSArray *datas = [data objectForKey:@"myAnswerList"];
                NSMutableArray *rows = [JRAnswer buildUpWithValue:datas];
                if (_currentPage > 1) {
                    [_answerDatas addObjectsFromArray:rows];
                }else{
                    self.answerDatas = [JRAnswer buildUpWithValue:datas];
                }
            }
            
           [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
}

- (IBAction)segmentValueChange:(id)sender{
    _currentPage = 1;
    [_tableView headerBeginRefreshing];
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
    return _segment.selectedSegmentIndex == 0?_questionDatas.count:_answerDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *content = @"厨房装修布局应该怎么样才好？厨房装修布局应该怎么样才好？";
    return 53 + [content heightWithFont:[UIFont systemFontOfSize:kSystemFontSize] constrainedToWidth:290];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AskOrAnswerCell";
    AskOrAnswerCell *cell = (AskOrAnswerCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (AskOrAnswerCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_segment.selectedSegmentIndex == 0) {
        JRQuestion *q = _questionDatas[indexPath.row];
        [cell fillCellWithQuestion:q];
    }else{
        JRAnswer *r = _answerDatas[indexPath.row];
        [cell fillCellWithAnswer:r];
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
