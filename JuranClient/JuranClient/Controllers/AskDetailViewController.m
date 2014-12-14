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
#import "JRAnswer.h"

@interface AskDetailViewController ()<UITableViewDataSource, UITableViewDelegate, AnswerDetailCellDelegate>

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *answerView;
@property (nonatomic, strong) AnswerDetailCell *answerDetailCell;

@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIView *timeAndTypeBgView;
@property (nonatomic, strong) IBOutlet UILabel *typeLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@end

@implementation AskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"我的提问";
    
    self.tableView = [self.view tableViewWithFrame:_isMyQuestion? kContentFrameWithoutNavigationBar:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    
    if (!_isMyQuestion) {
        [self.view addSubview:_answerView];
        CGRect frame = _answerView.frame;
        frame.origin.y = CGRectGetMaxY(_tableView.frame);
        _answerView.frame = frame;
    }
    [self loadData];
}

- (void)loadData{
    NSDictionary *param = @{@"questionId": [NSString stringWithFormat:@"%d", _question.questionId]};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_DEQUESTIONDETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if (_isMyQuestion) {
                [_question buildUpMyQuestionDetailWithValue:data];
            }else{
                _question = [[JRQuestion alloc] initWithDictionary:data];
                [_question buildUpMyQuestionDetailWithValue:data];
            }
            
        }
        [self reloadData];
    }];
}

- (void)setupHeaderView{
    _contentLabel.text = _question.questionContent;
    _typeLabel.text = [NSString stringWithFormat:@"分类：%@", [_question questionTypeString]];
    _timeLabel.text = _question.publishTime;
    
    CGRect frame = _contentLabel.frame;
    frame.size.height = [_contentLabel.text heightWithFont:_contentLabel.font constrainedToWidth:_contentLabel.frame.size.width];
    _contentLabel.frame = frame;
    
    frame = _timeAndTypeBgView.frame;
    frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
    _timeAndTypeBgView.frame = frame;
    
    frame = _headerView.frame;
    frame.size.height = CGRectGetMaxY(_timeAndTypeBgView.frame);
    _headerView.frame = frame;
    _tableView.tableHeaderView = _headerView;
}

- (void)reloadData{
    [self setupHeaderView];
    [_tableView reloadData];
}

- (void)setBestAnswer:(JRAnswer*) answer{
    NSDictionary *param = @{@"questionId": [NSString stringWithFormat:@"%d", _question.questionId],
                            @"answerId": [NSString stringWithFormat:@"%d", answer.answerId]};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SET_BESTANSWER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            answer.bestAnswerFlag = YES;
            _question.status = @"resolved";
        }
        [_tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _question.otherAnswers.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AnswerDetailCell";
    AnswerDetailCell *cell = (AnswerDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (AnswerDetailCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRAnswer *answer = [_question.otherAnswers objectAtIndex:indexPath.row];
    if (_isMyQuestion) {
        cell.delegate = nil;
        if (!_question.isResolved) {
            cell.delegate = self;
        }
        [cell fillCellWithAnswer:answer type:_question.isResolved?1:0];
    }else{
        [cell fillCellWithAnswer:answer type:1];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isMyQuestion) {
        JRAnswer *answer = [_question.otherAnswers objectAtIndex:indexPath.row];
        [self.answerDetailCell fillCellWithAnswer:answer type:_question.isResolved?1:0];
        return self.answerDetailCell.contentView.frame.size.height + ((indexPath.row == _question.otherAnswers.count - 1)?5:0);
    }else{
        JRAnswer *answer = [_question.otherAnswers objectAtIndex:indexPath.row];
        [self.answerDetailCell fillCellWithAnswer:answer type:1];
        return self.answerDetailCell.contentView.frame.size.height + ((indexPath.row == _question.otherAnswers.count - 1)?5:0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
    //    detailVC.designer = _datas[indexPath.row];
    //    detailVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detailVC animated:YES];
}

- (AnswerDetailCell*)answerDetailCell{
    if (!_answerDetailCell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AnswerDetailCell" owner:self options:nil];
        _answerDetailCell = (AnswerDetailCell *)[nibs firstObject];
    }
    return _answerDetailCell;
}

- (void)answerDetailCell:(AnswerDetailCell *)cell adoptAnswer:(JRAnswer *)answer{
    [self setBestAnswer:answer];
}

@end
