//
//  PrivateMessageDetailViewController.m
//  JuranClient
//
//  Created by Kowloon on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PrivateMessageDetailViewController.h"
#import "PrivateMessage.h"
#import "UIBubbleTableView.h"
#import "JRDesigner.h"
#import "DesignerDetailViewController.h"
#import "UIActionSheet+Blocks.h"

@interface PrivateMessageDetailViewController () <UIBubbleTableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIBubbleTableView *tableView;
@property (nonatomic, strong) IBOutlet UITextField *contentTextField;
@property (nonatomic, strong) IBOutlet UIView *commentView;
@property (nonatomic, strong) IBOutlet UIView *firstView;
@property (nonatomic, strong) IBOutlet UILabel *firstContentLabel;
@property (nonatomic, strong) IBOutlet UILabel *firstContactLabel;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UITapGestureRecognizer *tapHide;

- (IBAction)onSend:(id)sender;

@end

@implementation PrivateMessageDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [self configureLeftBarButtonUniformly];
    self.view.backgroundColor = kViewBackgroundColor;
    self.navigationItem.title = _message.receiverNickName;
    
    _firstView.backgroundColor = [UIColor clearColor];
    _firstContactLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@|%@平米", _message.senderName, _message.mobilePhone, _message.likeStyleString, _message.houseArea];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
#ifndef kJuranDesigner
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"private_message_more"] rightBarButtonItemAction:@selector(onDetail)];
#endif
    
    self.tapHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    [self.tableView addFooterWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    [_tableView setFooterPullToRefreshText:@"上拉可以刷新"];
    [_tableView setFooterRefreshingText:@"松开立即刷新"];
    [_tableView setFooterReleaseToRefreshText:@"正在刷新..."];
    [_tableView setHeaderPullToRefreshText:@"下拉可以加载更多数据"];
    [_tableView setHeaderRefreshingText:@"松开立即加载更多数据"];
    [_tableView setHeaderReleaseToRefreshText:@"正在加载..."];
    
    [self.tableView footerBeginRefreshing];
    
    
}

- (void)onDetail{
    [UIActionSheet showInView:[UIApplication sharedApplication].keyWindow withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"查看设计师详情"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == [actionSheet cancelButtonIndex]) {
            return;
        }
        
        JRDesigner *designer = [[JRDesigner alloc] init];
        designer.userId = _message.receiverId;
        DesignerDetailViewController *dv = [[DesignerDetailViewController alloc] init];
        dv.designer = designer;
        [self.navigationController pushViewController:dv animated:YES];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": kOnePageCount,
                            @"privateLetterId": [NSString stringWithFormat:@"%d", _message.letterId]};
    
    [[ALEngine shareEngine] pathURL:JR_PRIVATE_DETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *privateLetterList = [data objectForKey:@"privateLetterList"];
            NSMutableArray *rows = [PrivateMessageDetail buildUpWithValue:privateLetterList];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = rows;
//                NSArray *rows = @[detail.fromNickName, detail];
            }
            
            [self.tableView reloadData];
            
            if (_currentPage == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_tableView scrollToBottom];
                });
            }
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    }];
}

- (void)hideKeyboard{
    [_contentTextField resignFirstResponder];
}

- (IBAction)onSend:(id)sender{
    [self hideKeyboard];
    
    NSString *value = _contentTextField.text;
    if (value.length == 0) {
        return;
    }
    [self showHUD];
    NSDictionary *param = @{@"privateLetterId":[NSString stringWithFormat:@"%d",_message.letterId],
                            @"receiverId": [NSString stringWithFormat:@"%d", [JRUser currentUser].userId == _message.receiverId ? _message.senderId : _message.receiverId],
                            @"memo": value};
    [[ALEngine shareEngine] pathURL:JR_REPLY_LETTER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _contentTextField.text = @"";
            [_tableView footerBeginRefreshing];
        }
    }];
}

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView{
    return [_datas count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row{
    PrivateMessageDetail *detail = [_datas objectAtIndex:row];
    NSDate *date = [NSDate dateFromString:detail.publishTime dateFormat:kDateFormatHorizontalLineLong];
    
    NSBubbleData *bubble = nil;
    BOOL me = detail.fromUserId == [JRUser currentUser].userId;
#ifdef kJuranDesigner
    me = !me;
#endif
    NSBubbleType type = me ? BubbleTypeMine : BubbleTypeSomeoneElse;
    if (detail.isFirstFlag &&  _message.mobilePhone.length > 0) {
        _firstContentLabel.text = detail.content;
        
        UIImageView *line = (UIImageView *)[_firstView viewWithTag:2233];
        if (me) {
            _firstContactLabel.textColor = [UIColor whiteColor];
            _firstContentLabel.textColor = [UIColor whiteColor];
            
            line.image = [UIImage imageNamed:@"line_white"];
        }else{
            _firstContactLabel.textColor = [UIColor blackColor];
            _firstContentLabel.textColor = [UIColor blackColor];
            
            line.image = [UIImage imageNamed:@"line_gray"];
        }
        
        CGRect frame = _firstContentLabel.frame;
        frame.size.height = [_firstContentLabel.text heightWithFont:_firstContentLabel.font constrainedToWidth:CGRectGetWidth(_firstContentLabel.frame)];
        _firstContentLabel.frame = frame;
        
        frame = line.frame;
        frame.origin.y = CGRectGetMaxY(_firstContentLabel.frame) + 10;
        line.frame = frame;
        
        frame = _firstContactLabel.frame;
        frame.origin.y = CGRectGetMaxY(line.frame) + 6;
        _firstContactLabel.frame = frame;
        
        frame = _firstView.frame;
        frame.size.height = CGRectGetMaxY(_firstContactLabel.frame) + 9;
        _firstView.frame = frame;
        
        bubble = [NSBubbleData dataWithView:_firstView date:date type:type insets:UIEdgeInsetsZero];
        
    }else{
        bubble = [NSBubbleData dataWithText:detail.content date:date type:type];
    }
    
    return bubble;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self onSend:nil];
    
    return YES;
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
    
    CGRect frame = _tableView.frame;
    frame.size.height = kWindowHeightWithoutNavigationBar - CGRectGetHeight(_commentView.frame) - keyboardSize.height;
    _tableView.frame = frame;
    
    frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
    
//    [_tableView scrollToBottom];
    
    [_tableView addGestureRecognizer:_tapHide];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat y = _tableView.contentOffset.y + keyboardSize.height;
        if ((y+CGRectGetHeight(_tableView.frame)) > _tableView.contentSize.height) {
            y = _tableView.contentSize.height - CGRectGetHeight(_tableView.frame);
        }
        
        if (y < 0) {
            y = 0;
        }
        
        [_tableView setContentOffset:CGPointMake(0, y) animated:YES];
    });
    
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    
    CGRect frame = _tableView.frame;
    frame.size.height = kWindowHeightWithoutNavigationBar - CGRectGetHeight(_commentView.frame);
    _tableView.frame = frame;
    
     frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
    
//    [_tableView scrollToBottom];

    [_tableView removeGestureRecognizer:_tapHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
