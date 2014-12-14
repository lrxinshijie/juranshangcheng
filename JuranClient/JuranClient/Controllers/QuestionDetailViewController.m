//
//  QuestionDetailViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-11.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "AnswerCell.h"
#import "JRQuestion.h"
#import "AnswerDetailCell.h"
#import "JRAnswer.h"

@interface QuestionDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AnswerCell *answerCell;
@property (nonatomic, strong) AnswerDetailCell *answerDetailCell;

//ResolvedView
@property (nonatomic, strong) IBOutlet UIView *resolvedTableHeaderView;
@property (nonatomic, strong) IBOutlet UIView *resolvedAdoptedHeaderView;
@property (nonatomic, strong) IBOutlet UIView *resolvedUnAdoptedHeaderView;
@property (nonatomic, strong) IBOutlet UILabel *resolvedTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *resolvedStyleLabel;
@property (nonatomic, strong) IBOutlet UILabel *resolvedContentLabel;
@property (nonatomic, strong) IBOutlet UIImageView *resolvedIconImageView;
@property (nonatomic, strong) IBOutlet UIImageView *resolvedHeaderImageView;

//unResolvedView
@property (nonatomic, strong) IBOutlet UIView *unResolvedTableHeaderView;
@property (nonatomic, strong) IBOutlet UILabel *unResolvedTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *unResolvedContentLabel;
@property (nonatomic, strong) IBOutlet UIImageView *unResolvedHeaderImageView;

//AnswerView
@property (nonatomic, strong) IBOutlet UIView *answerView;
@property (nonatomic, strong) IBOutlet UITextField *answerTextField;

@end

@implementation QuestionDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView = [self.view tableViewWithFrame:_isResolved? kContentFrameWithoutNavigationBar:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    if (!_isResolved) {
        [self setupAnswerView];
        CGRect frame = _answerView.frame;
        frame.origin.y = CGRectGetMaxY(_tableView.frame);
        _answerView.frame = frame;
        [self.view addSubview:_answerView];
    }
    
    [self loadData];
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

-(void)loadData{
    NSDictionary *param = @{@"questionId": [NSString stringWithFormat:@"%d", _question.questionId]};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_QUESTIONDETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                [_question buildUpDetailWithValue:data];
            }
            
            [self reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
}

- (void)reloadData{
    self.navigationItem.title = [NSString stringWithFormat:@"%@的提问", _question.nickName.length?_question.nickName:_question.account];
    if (_isResolved) {
        [self setupResolvedTableHeaderView];
        _tableView.tableHeaderView = _resolvedTableHeaderView;
    }else{
        [self setupUnResolvedTableHeaderView];
        _tableView.tableHeaderView = _unResolvedTableHeaderView;
    }
    [_tableView reloadData];
}

- (void)setupUnResolvedTableHeaderView{
    _unResolvedTitleLabel.text = _question.title;
    _unResolvedContentLabel.text = _question.questionContent;
    [_unResolvedHeaderImageView setImageWithURLString:_question.imageUrl];
    
    CGRect frame = _unResolvedTitleLabel.frame;
    frame.size.height = [_unResolvedTitleLabel.text heightWithFont:_unResolvedTitleLabel.font constrainedToWidth:CGRectGetWidth(_unResolvedTitleLabel.frame)];
    _unResolvedTitleLabel.frame = frame;
    
    frame = _unResolvedContentLabel.frame;
    frame.origin.y = CGRectGetMaxY(_unResolvedTitleLabel.frame) + 5;
    frame.size.height = [_unResolvedContentLabel.text heightWithFont:_unResolvedContentLabel.font constrainedToWidth:CGRectGetWidth(_unResolvedContentLabel.frame)];
    _unResolvedContentLabel.frame = frame;
    
    frame = _unResolvedTableHeaderView.frame;
    if (_question.imageUrl.length) {
        _unResolvedHeaderImageView.hidden = NO;
        frame = _unResolvedHeaderImageView.frame;
        frame.origin.y = CGRectGetMaxY(_unResolvedContentLabel.frame) + 5;
        _unResolvedHeaderImageView.frame = frame;
        
        frame = _unResolvedTableHeaderView.frame;
        frame.size.height = CGRectGetMaxY(_unResolvedHeaderImageView.frame) + 10;
        _unResolvedTableHeaderView.frame = frame;
        
    }else{
        _unResolvedHeaderImageView.hidden = YES;
        frame = _unResolvedTableHeaderView.frame;
        frame.size.height = CGRectGetMaxY(_unResolvedContentLabel.frame) + 10;
        _unResolvedTableHeaderView.frame = frame;
    }
}

- (void)setupResolvedTableHeaderView{
    _resolvedTitleLabel.text = _question.title;
    _resolvedStyleLabel.text = [_question descriptionForCell];
    _resolvedContentLabel.text = _question.questionContent;
    [_resolvedHeaderImageView setImageWithURLString:_question.imageUrl];
    
    CGRect frame = _resolvedTitleLabel.frame;
    frame.size.height = [_resolvedTitleLabel.text heightWithFont:_resolvedTitleLabel.font constrainedToWidth:CGRectGetWidth(_resolvedTitleLabel.frame)];
    _resolvedTitleLabel.frame = frame;
    
    frame = _resolvedStyleLabel.frame;
    frame.origin.y = CGRectGetMaxY(_resolvedTitleLabel.frame) + 5;
    _resolvedStyleLabel.frame = frame;
    
    frame = _resolvedContentLabel.frame;
    frame.origin.y = CGRectGetMaxY(_resolvedStyleLabel.frame) + 5;
    frame.size.height = [_resolvedContentLabel.text heightWithFont:_resolvedContentLabel.font constrainedToWidth:CGRectGetWidth(_resolvedContentLabel.frame)];
    _resolvedContentLabel.frame = frame;
    
    if (_question.imageUrl.length) {
        _resolvedHeaderImageView.hidden = NO;
        frame = _resolvedHeaderImageView.frame;
        frame.origin.y = CGRectGetMaxY(_resolvedContentLabel.frame) + 5;
        _resolvedHeaderImageView.frame = frame;
        
        frame = _resolvedTableHeaderView.frame;
        frame.size.height = CGRectGetMaxY(_resolvedHeaderImageView.frame) + 10;
        _resolvedTableHeaderView.frame = frame;
    }else{
        _resolvedHeaderImageView.hidden = YES;
        frame = _resolvedTableHeaderView.frame;
        frame.size.height = CGRectGetMaxY(_resolvedContentLabel.frame) + 10;
        _resolvedTableHeaderView.frame = frame;
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _isResolved?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isResolved) {
        if (section == 0 && _question.adoptedAnswer == nil) {
            return 0;
        }
        return section == 0?1:_question.otherAnswers.count;
    }else{
        return _question.otherAnswers.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isResolved) {
        static NSString *CellIdentifier = @"AnswerCell";
        AnswerCell *cell = (AnswerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (AnswerCell *)[nibs firstObject];
        }
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell fillCellWithAnswer:indexPath.section?_question.otherAnswers[indexPath.row]:_question.adoptedAnswer anIsAdoptedAnswer:indexPath.section == 0?YES:NO];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"AnswerDetailCell";
        AnswerDetailCell *cell = (AnswerDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (AnswerDetailCell *)[nibs firstObject];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell fillCellWithAnswer:_question.otherAnswers[indexPath.row] type:2];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isResolved) {
        [self.answerCell fillCellWithAnswer:indexPath.section?_question.otherAnswers[indexPath.row]:_question.adoptedAnswer anIsAdoptedAnswer:indexPath.section == 0?YES:NO];
        return self.answerCell.contentView.frame.size.height;
    }else{
        [self.answerDetailCell fillCellWithAnswer:_question.otherAnswers[indexPath.row] type:2];
        return self.answerDetailCell.contentView.frame.size.height;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_isResolved) {
        if (section == 0 && _question.adoptedAnswer == nil) {
            return nil;
        }
        if (section == 1 && _question.otherAnswers == 0) {
            return nil;
        }
        return section == 0?_resolvedAdoptedHeaderView:_resolvedUnAdoptedHeaderView;
    }else{
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        line.backgroundColor = [UIColor clearColor];
        return line;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_isResolved) {
        return 44;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
    //    detailVC.designer = _datas[indexPath.row];
    //    detailVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detailVC animated:YES];
}


- (AnswerCell*)answerCell{
    if (!_answerCell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AnswerCell" owner:self options:nil];
        _answerCell = (AnswerCell *)[nibs firstObject];
    }
    return _answerCell;
}

- (AnswerDetailCell*)answerDetailCell{
    if (!_answerDetailCell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AnswerDetailCell" owner:self options:nil];
        _answerDetailCell = (AnswerDetailCell *)[nibs firstObject];
    }
    return _answerDetailCell;
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
