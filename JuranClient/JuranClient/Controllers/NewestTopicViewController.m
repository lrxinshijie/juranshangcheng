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

@interface NewestTopicViewController ()<UITableViewDataSource, UITableViewDelegate, CommentCellDelegate, UITextFieldDelegate>

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

@property (nonatomic, strong) JRComment *selectComment;

@end

@implementation NewestTopicViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"最新话题";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(oldTopic:) title:@"往期话题" backgroundImage:nil];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    CGRect frame = _bottomView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _bottomView.frame = frame;
    [self.view addSubview:_bottomView];
    
    frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
    _commentView.hidden = YES;
    [self.view addSubview:_commentView];
    
    [self loadData];
}

- (void)loadData{
    [self showHUD];
    NSDictionary *param = nil;
    if (_topic) {
        param = @{@"topicId": _topic.topicId};
    }
    
    [[ALEngine shareEngine] pathURL:JR_GET_TOPICDETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _topic = [[JRTopic alloc] initWithDictionaryForDetail:data];
            [self reloadData];
        }
    }];
}

- (void)reloadData{
    [self setupTableHeaderView];
    _tableView.tableHeaderView = _tableHeaderView;
    [_tableView reloadData];
}

- (void)setupTableHeaderView{
    
}


- (IBAction)onSend:(id)sender{
    [_commentTextField resignFirstResponder];
    
    if (![self checkLogin:nil]) {
        return;
    }
    
    NSString *comment = _commentTextField.text;
    if (comment.length == 0) {
        [self showTip:@"评论内容不能为空"];
        return;
    }
    
    NSDictionary *param = @{@"topicId": _topic.topicId,
                            @"commentContent": comment};
    if (_selectComment) {
        param = @{@"projectId": _topic.topicId,
                  @"commentContent": comment,
                  @"commentId": [NSString stringWithFormat:@"%d", _selectComment.commentId]
                  };
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

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
    
    if (comment.replyList.count > 0) {
        CGFloat replyHeight = 25;
        if (comment.unfold) {
            replyHeight = 35;
            for (JRComment *reply in comment.replyList) {
                NSString *name = [NSString stringWithFormat:@"%@：", reply.nickName];
                NSString *content = [NSString stringWithFormat:@"%@%@", name, reply.replyContent];
                replyHeight += [content heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:290];
                replyHeight += 30;
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
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    JRComment *commnet = [_topic.commitList objectAtIndex:indexPath.row];
    [cell fillCellWithComment:commnet];
    
    return cell;
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
    [textField resignFirstResponder];
    [self onSend:nil];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_selectComment && textField.text.length == 0) {
        self.selectComment = nil;
    }
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
    _commentView.hidden = YES;
}

@end
