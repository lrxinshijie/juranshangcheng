//
//  TopicDetailViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/4/26.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "OldTopicViewController.h"
#import "CommentCell.h"
#import "JRTopic.h"
#import "JRComment.h"
#import "ALWebView.h"
#import "ALGetPhoto.h"
#import "CanRemoveImageView.h"
#import "ShareView.h"
#import "IQKeyboardManager.h"
#import "UIViewController+Menu.h"


@interface TopicDetailViewController ()<UITableViewDataSource, UITableViewDelegate, CommentCellDelegate, UITextFieldDelegate, ALWebViewDelegate, CanRemoveImageViewDelegate, UIScrollViewDelegate>
{
    BOOL firstLoadHtml;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *viewCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentCountLabel;
@property (nonatomic, strong) IBOutlet UIButton *viewCountButton;
@property (nonatomic, strong) IBOutlet UIButton *commentCountButton;

@property (nonatomic, strong) IBOutlet UIView *commentView;
@property (nonatomic, strong) IBOutlet UITextField *commentTextField;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet ALWebView *contentWebView;
@property (nonatomic, strong) UIButton *hiddenButton;

@property (nonatomic, strong) IBOutlet UIView *commentImageView;
@property (nonatomic, strong) IBOutlet UIView *chooseImageButtonView;

@property (nonatomic, strong) JRComment *selectComment;
@property (nonatomic, strong) NSMutableArray *fileImages;
@property (nonatomic, strong) NSMutableArray *fileNames;

@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) IBOutlet UILabel *fileImageCountLabel;

@property (nonatomic, strong) IBOutlet UIView *emptyView;
@property (nonatomic, strong) NSMutableDictionary *openStatusDic;

@property (nonatomic, strong) UIButton *scrollToTopButton;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation TopicDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.openStatusDic = [NSMutableDictionary dictionary];
    self.navigationItem.title = @"话题详情";
    [self configureRightBarButtonItemImage:[[ALTheme sharedTheme] imageNamed:@"nav-icon-share"] rightBarButtonItemAction:@selector(onShare)];
//    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-dot"] rightBarButtonItemAction:@selector(onMenu)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    self.fileImages = [NSMutableArray array];
    self.fileNames = [NSMutableArray array];
    
    self.contentWebView.delegate = self;
    
    [self setupUI];
    [self setupCommentView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _emptyView.hidden = YES;
    _emptyView.center = _tableView.center;
    [self.view addSubview:_emptyView];
    
    _contentWebView.backgroundColor = [UIColor clearColor];
    _contentWebView.scrollView.backgroundColor = [UIColor clearColor];
    _contentWebView.scalesPageToFit = YES;
    _contentWebView.userInteractionEnabled = NO;
    
    self.hiddenButton = [_tableHeaderView buttonWithFrame:_tableHeaderView.bounds target:self action:@selector(onHiddenCommentImageView) image:nil];
    [_tableHeaderView insertSubview:_hiddenButton atIndex:0];
    
    self.scrollToTopButton = [self.view buttonWithFrame:CGRectMake(kWindowWidth - 40 - 15, CGRectGetMaxY(_tableView.frame) - 40 - 30, 40, 40) target:self action:@selector(onScrollToTop) image:[UIImage imageNamed:@"btn-scroll-top.png"]];
    _scrollToTopButton.hidden = YES;
    [self.view addSubview:_scrollToTopButton];
}

- (void)setupCommentView{
    CGRect frame = _commentView.frame;
    frame.origin.y = kWindowHeightWithoutNavigationBarAndTabbar;
    _commentView.frame = frame;
    _commentView.hidden = NO;
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
    _emptyView.hidden = YES;
    NSDictionary *param = @{@"topicId": _topic.topicId};
    
    [[ALEngine shareEngine] pathURL:JR_GET_TOPICDETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            if (_topic) {
                [_topic buildUpDetialValueWithDictionary:data];
            }else{
                _topic = [[JRTopic alloc] initWithDictionaryForDetail:data];
            }
            
            if (!data) {
                _emptyView.hidden = NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
            
        }else{
            [self hideHUD];
            _emptyView.hidden = NO;
        }
    }];
}

- (void)reloadData{
    
    _titleLabel.text = _topic.theme;
    _timeLabel.text = _topic.publishTime;
    [_viewCountButton setTitle:[NSString stringWithFormat:@"  %d", _topic.viewCount] forState:UIControlStateNormal];
    [_commentCountButton setTitle:[NSString stringWithFormat:@"  %d", _topic.commentCount] forState:UIControlStateNormal];
    
    ASLog(@"%@", _topic.contentDescription);
    if (!firstLoadHtml) {
        [_contentWebView reset];
        [_contentWebView loadHTMLString:_topic.contentDescription baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        [self setupTableHeaderView];
        firstLoadHtml = YES;
    }
    
    [_tableView reloadData];
}

- (void)setupTableHeaderView{
    
    CGRect frame = _contentWebView.frame;
    frame.size.width = CGRectGetWidth(_contentWebView.frame);
    frame.size.height = 40;
    _contentWebView.frame = frame;
    
    frame.size.height = _contentWebView.scrollView.contentSize.height;
    
    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    _contentWebView.frame = frame;
    
    frame = _tableHeaderView.frame;
    frame.size.height = CGRectGetMaxY(_contentWebView.frame);
    _tableHeaderView.frame = frame;
    
    _hiddenButton.frame = _tableHeaderView.bounds;
    
    _tableView.tableHeaderView = _tableHeaderView;
}

- (void)uploadCommentImageWithIndex:(NSInteger)index{
    [self showHUDFromTitle:@"发送中..."];
    [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":_fileImages[index]} responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            [_fileNames addObject:[data objectForKey:@"imgUrl"]];
            if (index == _fileImages.count - 1) {
                [self submitComment];
            }else{
                [self uploadCommentImageWithIndex:index+1];
            }
        }else{
            [self hideHUD];
        }
    }];
}

- (void)submitComment{
    NSString *imageUrl = @"";
    if (_fileNames.count > 0) {
        imageUrl = [_fileNames componentsJoinedByString:@"|"];
    }
    NSDictionary *param = @{@"topicId": _topic.topicId,
                            @"commentContent": _comment,
                            @"imgUrl":imageUrl};
    if (_selectComment) {
        param = @{@"topicId": _topic.topicId,
                  @"commentContent": _comment,
                  @"commentId": [NSString stringWithFormat:@"%d", _selectComment.commentId],
                  @"imgUrl":imageUrl};
    }
    [self showHUDFromTitle:@"发送中..."];
    [[ALEngine shareEngine] pathURL:JR_COMMIT_TOPIC parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self.fileImages removeAllObjects];
            [self.fileNames removeAllObjects];
            [self layoutInputImageView];
            _commentTextField.text = @"";
            if (self.selectComment) {
                if (![_openStatusDic objectForKey:[NSString stringWithFormat:@"%d", self.selectComment.commentId]]) {
                    [_openStatusDic addEntriesFromDictionary:@{[NSString stringWithFormat:@"%d", self.selectComment.commentId]:@""}];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_topic.commitList.count == 0) {
                    [_tableView scrollToBottom];
                }else{
                    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }
            });
            [self loadData];
            self.selectComment = nil;
        }
    }];
}

- (void)resetScrollToTopButton{
    _scrollToTopButton.hidden = (_tableView.contentOffset.y < CGRectGetHeight(_tableView.frame));
    CGRect frame = _scrollToTopButton.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame) - 40 - 30;
    _scrollToTopButton.frame = frame;
}

- (void)layoutInputImageView{
    _fileImageCountLabel.hidden = _fileImages.count == 0;
    _fileImageCountLabel.text = [NSString stringWithFormat:@"%d", _fileImages.count];
    self.chooseImageButtonView.hidden = NO;
    
    for (UIView *v in _commentImageView.subviews) {
        if ([v isKindOfClass:[CanRemoveImageView class]]) {
            [v removeFromSuperview];
        }
    }
    
    CGRect frame = CGRectMake(15, 20, 65, 65);
    NSInteger i = 0;
    for (UIImage *image in _fileImages) {
        
        CanRemoveImageView *imgView = [[CanRemoveImageView alloc] initWithFrame:frame];
        imgView.delegate = self;
        [imgView setImageViewBackgroundColor:[UIColor whiteColor]];
        [imgView setImageViewContentMode:UIViewContentModeScaleAspectFit];
        [imgView setImage:image];
        [_commentImageView addSubview:imgView];
        imgView.tag = 100+i;
        i++;
        frame.origin.x = 15 + (65 + 15)*i;
    }
    self.chooseImageButtonView.frame = frame;
    self.chooseImageButtonView.hidden = (i == 3);
}

#pragma mark - Target Action

- (void)onScrollToTop{
    [_tableView scrollToTop];
}

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
    
    [_commentTextField resignFirstResponder];
    [self hiddenCommentView];
    
    if (self.fileImages.count > 0) {
        [self uploadCommentImageWithIndex:0];
    }else{
        [self submitComment];
    }
}


- (IBAction)onChooseImage:(id)sender{
    [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:3-_fileImages.count Handler:^(NSArray *images) {
        [self.fileImages addObjectsFromArray:images];
        [self layoutInputImageView];
    }];
}


- (IBAction)onShowCommentImageView:(id)sender{
    [_commentTextField resignFirstResponder];
    _commentImageView.hidden = NO;
    
    CGRect frame = self.tableView.frame;
    frame.size.height = kWindowHeightWithoutNavigationBarAndTabbar - CGRectGetHeight(_commentImageView.frame);
    self.tableView.frame = frame;
    
    frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
    [self resetScrollToTopButton];
}

- (void)onHiddenCommentImageView{
    /*
     _commentImageView.hidden = YES;
     _commentView.hidden = YES;
     
     CGRect frame = self.tableView.frame;
     frame.size.height = kWindowHeightWithoutNavigationBarAndTabbar;
     self.tableView.frame = frame;
     
     frame = _commentView.frame;
     frame.origin.y = CGRectGetMaxY(_tableView.frame);
     _commentView.frame = frame;
     */
    [self hiddenCommentView];
    self.selectComment = nil;
    
}

- (void)hiddenCommentView{
    [_commentTextField resignFirstResponder];
    
    _commentImageView.hidden = YES;
    
    CGRect frame = self.tableView.frame;
    frame.size.height = kWindowHeightWithoutNavigationBarAndTabbar;
    self.tableView.frame = frame;
    
    frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
    [self resetScrollToTopButton];
}

- (void)oldTopic:(id)sender{
    OldTopicViewController *vc = [[OldTopicViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onMenu{
    [self showAppMenu:^{
        [[ShareView sharedView] showWithContent:_topic.theme image:nil title:_topic.theme url:[NSString stringWithFormat:@"http://apph5.juran.cn/topics/%@%@", _topic.topicId, [Public shareEnv]]];
    }];
}

- (void)onShare{
    [[ShareView sharedView] showWithContent:_topic.theme image:nil title:_topic.theme url:[NSString stringWithFormat:@"http://apph5.juran.cn/topics/%@%@", _topic.topicId, [Public shareEnv]]];
}

- (void)onComment:(id)sender{
    self.selectComment = nil;
    _commentView.hidden = NO;
    [_commentTextField becomeFirstResponder];
}

#pragma mark - CanRemoveImageViewDelegate

- (void)deleteCanRemoveImageView:(CanRemoveImageView *)view{
    [self.fileImages removeObjectAtIndex:view.tag - 100];
    [self layoutInputImageView];
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
    if (_topic) {
        UILabel *label = (UILabel*)[_headerView viewWithTag:100];
        label.text = @"全部评论";
        if (_topic.commitList.count == 0) {
            label.text = @"暂无评论";
        }
        return _headerView;
    }
    return nil;
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
    commnet.unfold = [_openStatusDic objectForKey:[NSString stringWithFormat:@"%d", commnet.commentId]]?YES:NO;
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
    JRComment *c = cell.comment;
    if (!c.unfold) {
        [_openStatusDic removeObjectForKey:[NSString stringWithFormat:@"%d", c.commentId]];
    }else{
        [_openStatusDic addEntriesFromDictionary:@{[NSString stringWithFormat:@"%d", c.commentId]:@""}];
    }
    //    [_tableView reloadData];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (c.unfold) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self resetScrollToTopButton];
        });
    }
}

- (void)setSelectComment:(JRComment *)selectComment{
    _selectComment = selectComment;
    if (_selectComment) {
        _commentTextField.placeholder = [NSString stringWithFormat:@"回复%@:", _selectComment.nickName];
        [_sendButton setTitle:@"回复" forState:UIControlStateNormal];
    }else{
        _commentTextField.placeholder = @"写评论";
        [_sendButton setTitle:@"评论" forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _scrollToTopButton.hidden = (scrollView.contentOffset.y < CGRectGetHeight(_tableView.frame));
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    /*[_commentTextField resignFirstResponder];
     
     _commentView.hidden = YES;
     self.selectComment = nil;
     [self onHiddenCommentImageView];*/
    [self hiddenCommentView];
    self.selectComment = nil;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
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
    
    CGRect frame = self.tableView.frame;
    frame.size.height = kWindowHeightWithoutNavigationBarAndTabbar - keyboardSize.height;
    self.tableView.frame = frame;
    
    frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
    [self resetScrollToTopButton];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    
    CGRect frame = self.tableView.frame;
    frame.size.height = kWindowHeightWithoutNavigationBarAndTabbar;
    self.tableView.frame = frame;
    
    frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
    [self resetScrollToTopButton];
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
