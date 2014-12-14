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

@interface AskDetailViewController ()<UITableViewDataSource, UITableViewDelegate, AnswerDetailCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *answerView;
@property (nonatomic, strong) IBOutlet UITextField *answerTextField;

@property (nonatomic, strong) AnswerDetailCell *answerDetailCell;

@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIView *timeAndTypeBgView;
@property (nonatomic, strong) IBOutlet UILabel *typeLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@end

@implementation AskDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"我的提问";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView = [self.view tableViewWithFrame:_isMyQuestion? kContentFrameWithoutNavigationBar:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    
    if (!_isMyQuestion) {
        [self setupAnswerView];
        
        CGRect frame = _answerView.frame;
        frame.origin.y = CGRectGetMaxY(_tableView.frame);
        _answerView.frame = frame;
        [self.view addSubview:_answerView];
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

- (void)setupAnswerView{
    UIView *view = [_answerView viewWithTag:2200];
    view.layer.cornerRadius = view.frame.size.height/2;
    view.layer.borderWidth = 1;
    view.layer.borderColor = RGBColor(151, 161, 166).CGColor;
    
    view = [_answerView viewWithTag:2201];
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 1;
    view.layer.borderColor = RGBColor(151, 161, 166).CGColor;
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

- (IBAction)onSend:(id)sender{
    if (!(_answerTextField.text && _answerTextField.text.length > 0))
    {
        [self showTip:@"回答内容不能为空"];
        return;
    }
    [_answerTextField resignFirstResponder];
    NSDictionary *param = @{@"questionId": [NSString stringWithFormat:@"%d", _question.questionId],
                            @"content": _answerTextField.text
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_ANSWER_QUESTION parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            JRUser *user = [JRUser currentUser];
            JRAnswer *answer = [[JRAnswer alloc] init];
            answer.userId = user.userId;
            answer.userType = user.userType.integerValue;
            answer.account = user.account;
            answer.nickName = user.nickName;
            answer.imageUrl = @"";
            answer.headUrl = user.headUrl;
            answer.content = _answerTextField.text;
            answer.commitTime = [[NSDate date] timestamp];
            [_question.otherAnswers insertObject:answer atIndex:0];
            _answerTextField.text = @"";
            [self reloadData];
        }
        
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self onSend:nil];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //    if (_selectComment && textField.text.length == 0) {
    //        self.selectComment = nil;
    //    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGRect frame = _answerView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame) - keyboardSize.height;
    _answerView.frame = frame;
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    
    CGRect frame = _answerView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _answerView.frame = frame;
}


@end
