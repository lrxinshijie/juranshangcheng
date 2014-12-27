//
//  NewestTopicViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "NewestTopicViewController.h"
#import "OldTopicViewController.h"
#import "CommentCell.h"
#import "JRTopic.h"
#import "JRComment.h"
#import "ALWebView.h"
#import "ALGetPhoto.h"
#import "CanRemoveImageView.h"


@interface NewestTopicViewController ()<UITableViewDataSource, UITableViewDelegate, CommentCellDelegate, UITextFieldDelegate, ALWebViewDelegate, CanRemoveImageViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *viewCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentCountLabel;

@property (nonatomic, strong) IBOutlet UIView *commentView;
@property (nonatomic, strong) IBOutlet UITextField *commentTextField;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet ALWebView *contentWebView;

@property (nonatomic, strong) IBOutlet UIView *commentImageView;
@property (nonatomic, strong) IBOutlet UIView *chooseImageButtonView;

@property (nonatomic, strong) JRComment *selectComment;
@property (nonatomic, strong) UIImage *fileImage;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) IBOutlet UILabel *fileImageCountLabel;

@end

@implementation NewestTopicViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    if (_isOld) {
        self.navigationItem.title = _topic.theme.length>0?_topic.theme:_topic.title;
    }else{
        self.navigationItem.title = @"最新话题";
        
        UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(oldTopic:) title:@"往期话题" backgroundImage:nil];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    self.contentWebView.delegate = self;
    
    self.tableView = [self.view tableViewWithFrame:_isOld?kContentFrameWithoutNavigationBar:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _contentWebView.backgroundColor = [UIColor clearColor];
    _contentWebView.scrollView.backgroundColor = [UIColor clearColor];
    
    if (!_isOld) {
        [self setupCommentView];
    }
    
    [self loadData];
}

- (void)setupCommentView{
    CGRect frame = _bottomView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _bottomView.frame = frame;
    [self.view addSubview:_bottomView];
    
    frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
    _commentView.hidden = YES;
    [self.view addSubview:_commentView];
    
    UIView *view = [_commentView viewWithTag:2200];
    view.layer.cornerRadius = view.frame.size.height/2;
    view.layer.borderWidth = 1;
    view.layer.borderColor = RGBColor(151, 161, 166).CGColor;
    
    view = [_commentView viewWithTag:2201];
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 1;
    view.layer.borderColor = RGBColor(151, 161, 166).CGColor;
    
    frame = _commentImageView.frame;
    frame.origin.y = kWindowHeightWithoutNavigationBar - CGRectGetHeight(_commentImageView.frame);
    _commentImageView.frame = frame;
    [self.view addSubview:_commentImageView];
    _commentImageView.hidden = YES;
    
    _fileImageCountLabel.layer.masksToBounds = YES;
    _fileImageCountLabel.layer.cornerRadius = CGRectGetWidth(_fileImageCountLabel.frame)/2.f;
    
    UIButton *btn = [_commentImageView buttonWithFrame:_commentImageView.bounds target:self action:@selector(onHiddenCommentImageView) image:nil];
    [_commentImageView insertSubview:btn atIndex:0];
}

- (void)loadData{
    [self showHUD];
    NSDictionary *param = nil;
    if (_isOld) {
        param = @{@"topicId": _topic.topicId};
    }else{
        param = @{};
    }
    
    [[ALEngine shareEngine] pathURL:JR_GET_TOPICDETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            if (_topic) {
                [_topic buildUpDetialValueWithDictionary:data];
            }else{
                _topic = [[JRTopic alloc] initWithDictionaryForDetail:data];
            }
            [self reloadData];
        }else{
            [self hideHUD];
        }
    }];
}

- (void)reloadData{
    _titleLabel.text = _topic.theme;
    _timeLabel.text = _topic.publishTime;
    _viewCountLabel.text = [NSString stringWithFormat:@"%d", _topic.viewCount];
    _commentCountLabel.text = [NSString stringWithFormat:@"%d", _topic.commentCount];
    
    [_contentWebView loadHTMLString:_topic.contentDescription baseURL:[NSURL URLWithString:@"http://10.199.5.57:8080/"]]; //[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]//[NSURL URLWithString:@"http://10.199.5.57:8080/img/"]
    [self setupTableHeaderView];
    [_tableView reloadData];
}

- (void)setupTableHeaderView{
    
    CGRect frame = _contentWebView.frame;
    frame.size.width = CGRectGetWidth(_contentWebView.frame);
    frame.size.height = 40;
    
//    _contentWebView.scrollView.scrollEnabled = NO;
    _contentWebView.frame = frame;
    
    frame.size.height = _contentWebView.scrollView.contentSize.height;
    
    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    _contentWebView.frame = frame;
    
    frame = _tableHeaderView.frame;
    frame.size.height = CGRectGetMaxY(_contentWebView.frame);
    _tableHeaderView.frame = frame;
    
//    NSString *htmlHeight = [_contentWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
//    _contentWebView.scrollView.contentSize = CGSizeMake(320, 240+[htmlHeight intValue]);
//    CGRect frame= _contentWebView.frame;
//    [_contentWebView setFrame:CGRectMake(frame.origin.x, frame.origin.y, 320, [htmlHeight intValue]+100)];
//    
    _tableView.tableHeaderView = _tableHeaderView;
}

- (void)uploadCommentImage{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":_fileImage} responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            [self submitComment:[data objectForKey:@"imgUrl"]];
            for (UIView *v in _commentImageView.subviews) {
                if ([v isKindOfClass:[CanRemoveImageView class]]) {
                    [v removeFromSuperview];
                }
            }
            _chooseImageButtonView.hidden = NO;
            self.fileImage = nil;
        }
    }];
}

- (void)submitComment:(NSString*)imageUrl{
    NSDictionary *param = @{@"topicId": _topic.topicId,
                            @"commentContent": _comment,
                            @"imgUrl":imageUrl};
    if (_selectComment) {
        param = @{@"topicId": _topic.topicId,
                  @"commentContent": _comment,
                  @"commentId": [NSString stringWithFormat:@"%d", _selectComment.commentId],
                  @"imgUrl":imageUrl};
    }
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_COMMIT_TOPIC parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _commentTextField.text = @"";
            [self loadData];
            self.selectComment = nil;
        }
        
    }];
}

- (void)setFileImage:(UIImage *)fileImage{
    _fileImage = fileImage;
    _fileImageCountLabel.hidden = fileImage == nil;
}

#pragma mark - Target Action

- (IBAction)onSend:(id)sender{
    if (![self checkLogin:^{
    }]) {
        return;
    }
    
    _comment = _commentTextField.text;
    if (_comment.length == 0) {
        [self showTip:@"评论内容不能为空"];
        return;
    }
    [self textFieldShouldReturn:nil];
    
    if (self.fileImage) {
        [self uploadCommentImage];
    }else{
        [self submitComment:@""];
    }
    
}


- (IBAction)onChooseImageWithCamera:(id)sender{
    [[ALGetPhoto sharedPhoto] showInViewController:self sourceType:UIImagePickerControllerSourceTypeCamera allowsEditing:YES MaxNumber:1 Handler:^(NSArray *images) {
        _chooseImageButtonView.hidden = YES;
        self.fileImage = images.firstObject;
        
        CanRemoveImageView *imageView = [[CanRemoveImageView alloc] initWithFrame:CGRectMake(25, 15, 80, 120)];
        imageView.delegate = self;
        [imageView setImage:images[0]];
        [_commentImageView addSubview:imageView];
    }];
}

- (IBAction)onChooseImageWithPhoto:(id)sender{
    [[ALGetPhoto sharedPhoto] showInViewController:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:YES MaxNumber:1 Handler:^(NSArray *images) {
        _chooseImageButtonView.hidden = YES;
        self.fileImage = images.firstObject;
        
        CanRemoveImageView *imageView = [[CanRemoveImageView alloc] initWithFrame:CGRectMake(25, 15, 80, 120)];
        imageView.delegate = self;
        [imageView setImage:images[0]];
        [_commentImageView addSubview:imageView];
    }];
}

- (IBAction)onShowCommentImageView:(id)sender{
    [_commentTextField resignFirstResponder];
    _commentImageView.hidden = NO;
    
    CGRect frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame) - CGRectGetHeight(_commentImageView.frame);
    _commentView.frame = frame;
    
    
}

- (void)onHiddenCommentImageView{
    _commentImageView.hidden = YES;
    _commentView.hidden = YES;
    
    CGRect frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
}

- (void)oldTopic:(id)sender{
    OldTopicViewController *vc = [[OldTopicViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onShare:(id)sender{
    
}

- (IBAction)onComment:(id)sender{
    _commentView.hidden = NO;
    [_commentTextField becomeFirstResponder];
}

#pragma mark - CanRemoveImageViewDelegate

- (void)deleteCanRemoveImageView:(CanRemoveImageView *)view{
    self.fileImage = nil;
    _chooseImageButtonView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _topic.commitList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JRComment *comment = [_topic.commitList objectAtIndex:indexPath.row];
    NSString *content = comment.commentContent;
    CGFloat height = [content heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:290];
    if (comment.imageUrlList.count > 0) {
        height += 50;
    }
    if (comment.replyList.count > 0) {
        CGFloat replyHeight = 25;
        if (comment.unfold) {
            replyHeight = 35;
            for (JRComment *reply in comment.replyList) {
                NSString *name = [NSString stringWithFormat:@"%@：", reply.nickName];
                NSString *content = [NSString stringWithFormat:@"%@%@", name, reply.replyContent];
                replyHeight += [content heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:290];
                replyHeight += 30;
                if (reply.imageUrlList.count > 0) {
                    replyHeight += 50;
                }
            }
        }
        height += replyHeight;
    }
    
    
    return 73+height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nibs firstObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    JRComment *commnet = [_topic.commitList objectAtIndex:indexPath.row];
    [cell fillCellWithComment:commnet];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self textFieldShouldReturn:nil];
}

#pragma mark - CommentCellDelegate

- (void)clickCellComment:(CommentCell *)cell{
    self.selectComment = cell.comment;
    _commentView.hidden = NO;
    [_commentTextField becomeFirstResponder];
}

- (void)clickCellUnfold:(CommentCell *)cell{
    [_tableView reloadData];
}

- (void)setSelectComment:(JRComment *)selectComment{
    _selectComment = selectComment;
    if (_selectComment) {
        _commentTextField.placeholder = [NSString stringWithFormat:@"回复%@:", _selectComment.nickName];
    }else{
        _commentTextField.placeholder = @"写评论";
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_commentTextField resignFirstResponder];
    
    _commentView.hidden = YES;
    _commentImageView.hidden = YES;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_selectComment && textField.text.length == 0) {
        self.selectComment = nil;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isContainsEmoji]) {
        return NO;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGRect frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame) - keyboardSize.height;
    _commentView.frame = frame;
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    
    CGRect frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
}

#pragma mark - ALWebViewDelegate

- (void)webViewDidFinishLoad:(ALWebView *)aWebView{
    [self hideHUD];
    [self setupTableHeaderView];
    [_tableView reloadData];

}

- (void)webView:(ALWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [self hideHUD];
    [self showTip:@"加载失败"];
}

@end
