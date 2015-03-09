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
#import "ALGetPhoto.h"
#import "CanRemoveImageView.h"
#import "ZoomInImageView.h"

@interface QuestionDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CanRemoveImageViewDelegate>
{
    UIImage *fileImage;
}
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
@property (nonatomic, strong) IBOutlet ZoomInImageView *resolvedHeaderImageView;
@property (nonatomic, strong) IBOutlet UIView *resolvedHeaderImageContentView;

//unResolvedView
@property (nonatomic, strong) IBOutlet UIView *unResolvedTableHeaderView;
@property (nonatomic, strong) IBOutlet UILabel *unResolvedTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *unResolvedContentLabel;
@property (nonatomic, strong) IBOutlet ZoomInImageView *unResolvedHeaderImageView;
@property (nonatomic, strong) IBOutlet UIView *unResolvedHeaderImageContentView;

//AnswerView
@property (nonatomic, strong) IBOutlet UIView *answerView;
@property (nonatomic, strong) IBOutlet UITextField *answerTextField;
@property (nonatomic, strong) IBOutlet UIView *answerImageView;
@property (nonatomic, strong) IBOutlet UIView *chooseImageView;

@property (nonatomic, strong) IBOutlet UIView *emptyView;

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
        
        frame = _answerImageView.frame;
        frame.origin.y = kWindowHeightWithoutNavigationBar - CGRectGetHeight(_answerImageView.frame);
        _answerImageView.frame = frame;
        [self.view addSubview:_answerImageView];
        _answerImageView.hidden = YES;
        
        UIButton *btn = [_answerImageView buttonWithFrame:_answerImageView.bounds target:self action:@selector(onHiddenAnswerImageView) image:nil];
        [_answerImageView insertSubview:btn atIndex:0];
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
    self.navigationItem.title = [NSString stringWithFormat:@"%@的提问", [Public formatString:_question.nickName.length?_question.nickName:_question.account maxLength:12]];
    if (_isResolved) {
        [self setupResolvedTableHeaderView];
        _tableView.tableHeaderView = _resolvedTableHeaderView;
    }else{
        [self setupUnResolvedTableHeaderView];
        _tableView.tableHeaderView = _unResolvedTableHeaderView;
        if (_question.otherAnswers.count == 0) {
            CGRect frame = _emptyView.frame;
            frame.size.height = kWindowHeightWithoutNavigationBar - CGRectGetHeight(_unResolvedTableHeaderView.frame);
            if (frame.size.height < 140) {
                frame.size.height = 140;
            }
            _emptyView.frame = frame;
            _tableView.tableFooterView = _emptyView;
        }else{
            _tableView.tableFooterView = [[UIView alloc] init];
        }
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
        _unResolvedHeaderImageContentView.hidden = NO;
        frame = _unResolvedHeaderImageContentView.frame;
        frame.origin.y = CGRectGetMaxY(_unResolvedContentLabel.frame) + 5;
        _unResolvedHeaderImageContentView.frame = frame;
        
        frame = _unResolvedTableHeaderView.frame;
        frame.size.height = CGRectGetMaxY(_unResolvedHeaderImageContentView.frame) + 10;
        _unResolvedTableHeaderView.frame = frame;
        
    }else{
        _unResolvedHeaderImageContentView.hidden = YES;
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
        _resolvedHeaderImageContentView.hidden = NO;
        frame = _resolvedHeaderImageContentView.frame;
        frame.origin.y = CGRectGetMaxY(_resolvedContentLabel.frame) + 5;
        _resolvedHeaderImageContentView.frame = frame;
        
        frame = _resolvedTableHeaderView.frame;
        frame.size.height = CGRectGetMaxY(_resolvedHeaderImageContentView.frame) + 10;
        _resolvedTableHeaderView.frame = frame;
    }else{
        _resolvedHeaderImageContentView.hidden = YES;
        frame = _resolvedTableHeaderView.frame;
        frame.size.height = CGRectGetMaxY(_resolvedContentLabel.frame) + 10;
        _resolvedTableHeaderView.frame = frame;
    }
}

- (void)uploadAnswerImage{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":fileImage} responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            [self submitAnswer:[data objectForKey:@"imgUrl"]];
            for (UIView *v in _answerImageView.subviews) {
                if ([v isKindOfClass:[CanRemoveImageView class]]) {
                    [v removeFromSuperview];
                }
            }
            _chooseImageView.hidden = NO;
            fileImage = nil;
        }
    }];
}

- (void)submitAnswer:(NSString*)imageUrl{
    NSDictionary *param = @{@"questionId": [NSString stringWithFormat:@"%d", _question.questionId],
                            @"content": _answerTextField.text,
                            @"imgUrl":imageUrl
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
            answer.imageUrl = imageUrl;
            answer.commitTime = [[NSDate date] timestamp];
            [_question.otherAnswers insertObject:answer atIndex:0];
            _question.answerCount += 1;
            _answerTextField.text = @"";
            if (_delegate && [_delegate respondsToSelector:@selector(valueChangedWithQuestionDetailViewController:)]) {
                [_delegate valueChangedWithQuestionDetailViewController:self];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
                [self reloadData];
            });
        }
        
    }];
}

#pragma mark - Target Action

- (void)onHiddenAnswerImageView{
    _answerImageView.hidden = YES;
    
    CGRect frame = _answerView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _answerView.frame = frame;
}

- (IBAction)onShowAnswerImageView:(id)sender{
    [_answerTextField resignFirstResponder];
    CGRect frame = _answerView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame) - CGRectGetHeight(_answerImageView.frame);
    _answerView.frame = frame;
    
    _answerImageView.hidden = NO;
}

- (IBAction)onSend:(id)sender{
    if (![self checkLogin:^{
    }]) {
        return;
    }
    
    if (!(_answerTextField.text && _answerTextField.text.length > 0))
    {
        [self showTip:@"回答内容不能为空"];
        return;
    }
    [_answerTextField resignFirstResponder];
    [self onHiddenAnswerImageView];
    if (fileImage) {
        [self uploadAnswerImage];
    }else{
        [self submitAnswer:@""];
    }
}

- (IBAction)onChooseImageWithPhoto:(id)sender{
    [[ALGetPhoto sharedPhoto] showInViewController:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:YES MaxNumber:1 Handler:^(NSArray *images) {
        _chooseImageView.hidden = YES;
        fileImage = images.firstObject;
        
        CanRemoveImageView *imageView = [[CanRemoveImageView alloc] initWithFrame:CGRectMake(25, 15, 80, 120)];
        imageView.delegate = self;
        [imageView setImage:images[0]];
        [_answerImageView addSubview:imageView];
    }];
}


- (IBAction)onChooseImageWithCamera:(id)sender{
    [[ALGetPhoto sharedPhoto] showInViewController:self sourceType:UIImagePickerControllerSourceTypeCamera allowsEditing:YES MaxNumber:1 Handler:^(NSArray *images) {
        _chooseImageView.hidden = YES;
        fileImage = images.firstObject;
        
        CanRemoveImageView *imageView = [[CanRemoveImageView alloc] initWithFrame:CGRectMake(25, 15, 80, 120)];
        imageView.delegate = self;
        [imageView setImage:images[0]];
        [_answerImageView addSubview:imageView];
    }];
}

#pragma mark - CanRemoveImageViewDelegate

- (void)deleteCanRemoveImageView:(CanRemoveImageView *)view{
    fileImage = nil;
    _chooseImageView.hidden = NO;
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 1)];
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
    [_answerTextField resignFirstResponder];
    [self onHiddenAnswerImageView];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isContainsEmoji]) {
        return NO;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([Public convertToInt:toBeString] > 400) {
        [self showTip:@"回答长度不能超过400!"];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (_selectComment && textField.text.length == 0) {
//        self.selectComment = nil;
//    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    _answerImageView.hidden = YES;
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
