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

@interface PrivateMessageDetailViewController () <UIBubbleTableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIBubbleTableView *tableView;
@property (nonatomic, strong) IBOutlet UITextField *contentTextField;
@property (nonatomic, strong) IBOutlet UIView *commentView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

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
    self.navigationItem.title = @"我的私信";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [self.tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    [self.tableView headerBeginRefreshing];
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
            }
            
            [self.tableView reloadData];
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    }];
}

- (IBAction)onSend:(id)sender{
    [_contentTextField resignFirstResponder];
    NSString *value = _contentTextField.text;
    if (value.length == 0) {
        return;
    }
    
    NSDictionary *param = @{@"privateLetterId":[NSString stringWithFormat:@"%d",_message.letterId],
                            @"receiverId": [NSString stringWithFormat:@"%d", _message.receiverId],
                            @"memo": value};
    [[ALEngine shareEngine] pathURL:JR_REPLY_LETTER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            _contentTextField.text = @"";
            [_tableView headerBeginRefreshing];
        }
    }];
}

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView{
    return [_datas count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row{
    PrivateMessageDetail *detail = [_datas objectAtIndex:row];
    NSDate *date = [NSDate dateFromString:detail.publishTime dateFormat:kDateFormatHorizontalLineLong];
    
    NSBubbleData *bubble = [NSBubbleData dataWithText:detail.content date:date type:detail.fromUserId == [JRUser currentUser].userId ? BubbleTypeMine : BubbleTypeSomeoneElse];
    return bubble;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self onSend:nil];
    
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
