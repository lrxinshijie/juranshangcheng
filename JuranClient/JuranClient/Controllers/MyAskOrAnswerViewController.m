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
#import "AskDetailViewController.h"

@interface MyAskOrAnswerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *answerDatas;
@property (nonatomic, strong) NSMutableArray *questionDatas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) IBOutlet UIView *noDatasView;

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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame))];
    bgView.backgroundColor = RGBColor(241, 241, 241);
    CGPoint center = CGPointMake(bgView.center.x, 220);
    _noDatasView.center = center;
    _noDatasView.hidden = YES;
    [bgView addSubview:_noDatasView];
    _tableView.backgroundView = bgView;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": @"10"};
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
            if (_questionDatas.count == 0) {
                _noDatasView.hidden = NO;
            }
        }else{
            _noDatasView.hidden = YES;
            if (_answerDatas.count == 0) {
                _noDatasView.hidden = NO;
            }
        }
    });
}

- (IBAction)segmentValueChange:(id)sender{
    self.navigationItem.title = _segment.selectedSegmentIndex == 0?@"我的提问":@"我的回答";
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
    return _segment.selectedSegmentIndex == 0?_questionDatas.count:_answerDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *content = nil;
    CGFloat height = 53;
    if (_segment.selectedSegmentIndex == 0) {
        JRQuestion *q = _questionDatas[indexPath.row];
        content = q.title;
        height += (indexPath.row == (_questionDatas.count - 1))?5:0;
    }else{
        JRAnswer *a = _answerDatas[indexPath.row];
        content = a.content;
        height += (indexPath.row == (_answerDatas.count - 1))?5:0;
    }
    return height + [content heightWithFont:[UIFont systemFontOfSize:kSystemFontSize] constrainedToWidth:290];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AskOrAnswerCell";
    AskOrAnswerCell *cell = (AskOrAnswerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    if (_segment.selectedSegmentIndex == 0) {
        AskDetailViewController *vc = [[AskDetailViewController alloc] init];
        vc.isMyQuestion = YES;
        JRQuestion *q = _questionDatas[indexPath.row];
        vc.question = q;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        AskDetailViewController *vc = [[AskDetailViewController alloc] init];
        vc.isMyQuestion = NO;
        JRQuestion *q = [[JRQuestion alloc] init];
        q.questionId = 1275;
        vc.question = q;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
