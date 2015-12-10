//
//  AddReplyViewController.m
//  JuranClient
//
//  Created by 123 on 15/11/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//
//回复列表页面以及添加回复页面
#import "AddReplyViewController.h"
#import "ReplyListCell.h"
#import "CommentListCell.h"
#import "DeviceHardware.h"
#import <AGCommon/UIDevice+Common.h>

@interface AddReplyViewController ()<ReplyListCellDelegate,UITextFieldDelegate>
{
    NSMutableArray *array;
    UIView *noResultView;
    int index;
}
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation AddReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"回复";
    
    _txtReply.delegate=self;
    array=[[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initUI];

    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [_tableView headerBeginRefreshing];
    
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillShowNotification object:nil ];
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillHideNotification object:nil ];
}


-(void)initUI
{
    //self.tableView.frame=CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBarAndTabbar);
    
    self.tableView.frame=CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBar);
    
    _bottomView.frame=CGRectMake(0, kWindowHeightWithoutNavigationBarAndTabbar, kWindowWidth, kWindowHeightWithoutNavigationBar-kWindowHeightWithoutNavigationBarAndTabbar);
    //    self.tableView.tableFooterView=_bottomView;
    
    [self.view addSubview:_bottomView];
    
    //    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancel)];
    
    
    //    [self.navigationItemsetHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(10, 23, 13, 24);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_backbtn.png"] forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    //    nav_backbtn.png
    self.navigationItem.leftBarButtonItem=back;
    [self noResultView];
    
    
}

-(void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)noResultView
{
    UIView *view=[[UIView alloc] initWithFrame:_tableView.frame];
    
    CGRect rect=CGRectMake(0, 0, 100, 91);
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:rect];
    imageView.image=[UIImage imageNamed:@"noResultImage.png"];
    imageView.center=CGPointMake(kWindowWidth/2, kWindowHeight/2-180);
    
    
    UILabel *tip=[[UILabel alloc] init];
    tip.frame=CGRectMake(rect.origin.x, CGRectGetMaxY(rect), 100, 30);
    tip.center=CGPointMake(kWindowWidth/2, kWindowHeight/2-120);
    tip.text=@"还没有人回复他 ~ ";
    tip.font=[UIFont systemFontOfSize:12];
    tip.textColor=RGBColor(195, 195, 195);
    [view addSubview:imageView];
    [view addSubview:tip];
    noResultView=view;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    //    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [noResultView addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_txtReply becomeFirstResponder];
}







- (void)loadData{
    
    [self showHUD];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:@(self.id) forKey:@"replyId"];
    [param setObject:@(_currentPage) forKey:@"currentPage"];
    [param setObject:kOnePageCount forKey:@"pageSize"];
    
    
    
    [[ALEngine shareEngine] pathURL:JR_SelectReply parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        
        if (!error) {
            [array removeAllObjects];
            
            
            
            
            NSArray *commentList = [data objectForKey:@"reviewReplyDtoList"];
            
            NSMutableArray *rows = [JRReplyModel buildUpWithValue:commentList];
            
            if (_currentPage == 1) {
                array=rows;
                
            }
            else
            {
                [array addObjectsFromArray:rows];
            }
            
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        
        if(array.count==0)
        {
            
            [UIView animateWithDuration:1.0f animations:^{
                [self.view addSubview:noResultView];
                _tableView.hidden=YES;
                [self.view bringSubviewToFront:_bottomView];
                [_txtReply  becomeFirstResponder];
                
            }];
            
            
        }
        else
        {
            _tableView.hidden=NO;
            [noResultView removeFromSuperview];
            //                self.tableView.tableHeaderView=[self getHeaderView];
            
        }
        
        
    }];
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReplyListCell";
    ReplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if (!cell) {
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (ReplyListCell *)[nibs firstObject];
    }
    
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:[array objectAtIndex:indexPath.section]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JRReplyModel *model=(JRReplyModel *)[array objectAtIndex:indexPath.section];
    
    
    NSString *content = model.content;
    CGFloat height = [content heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:288];
    
    
    return height+72+40;//67+
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}


-(void)reply:(JRReplyModel *)model
{
    
    if (![JRUser isLogin]) {
        [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillShowNotification object:nil ];
        [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillHideNotification object:nil ];
        
    }
    
    
    if (![self checkLogin:^{
    }]) {
        return;
    }
    
    
    
    [_txtReply becomeFirstResponder];
    
    _model=model;
    self.txtReply.text=@"";
    self.txtReply.placeholder=[NSString stringWithFormat:@"写评论/回复:%@",model.userNickname];
    
    for (int i=0; i<array.count; i++) {
        if([array[i] isKindOfClass:[JRReplyModel class]])
        {
            JRReplyModel *temp=array[i];
            if(temp.rid==_model.rid)
            {
                index=i;
                NSString *content = _model.content;
                CGFloat height = [content heightWithFont:[UIFont systemFontOfSize:11] constrainedToWidth:293];
                
                
                [_tableView setContentOffset:CGPointMake(0.0, (height+72+30)*index) animated:NO];
                break;
            }
            
        }
    }
    
}



-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    
    
    return keyboardEndingFrame.size.height;
}

-(void)keyboardWillAppear:(NSNotification *)notification
{
    
   
    
    
    CGRect currentFrame = self.navigationController.view.frame;
    CGRect currentBottomFrame=self.bottomView.frame;
    
    NSDictionary *userInfo=notification.userInfo;
    
    
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    
    CGRect keyboardBeginingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    CGRect keyboardBeginingFrame = [self.view convertRect:keyboardBeginingUncorrectedFrame fromView:nil];
    
    CGFloat heightCha=keyboardEndingFrame.size.height-keyboardBeginingFrame.size.height;
    
    
    if(heightCha==0)
    {
        currentFrame.origin.y = currentFrame.origin.y +keyboardEndingFrame.size.height;
        currentBottomFrame.origin.y=currentBottomFrame.origin.y-keyboardEndingFrame.size.height;
    }
    else
    {
        currentFrame.origin.y = keyboardEndingFrame.size.height;
        //        NSLog(@"currentBottomFrame: %@",NSStringFromCGRect(currentBottomFrame));
        //        NSLog(@"heightCha: %d",heightCha);
        
        currentBottomFrame.origin.y=currentBottomFrame.origin.y-heightCha;
        
    }
    
    if(currentBottomFrame.origin.y==167) return; //方法很low，暂时用
    
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationController.view.frame=currentFrame;
        //        NSLog(@"currentFrame:%@",NSStringFromCGRect(currentFrame));
        _bottomView.frame=currentBottomFrame;
        //        NSLog(@"currentBottomFrame: %@",NSStringFromCGRect(currentBottomFrame));
        
        
        
    }];
    
    
    
    
    
    //return height+72+30;//67+
    
}


//最后，当键盘消失后，视图需要恢复原状。
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    
   
    
    
    CGRect currentFrame = self.navigationController.view.frame;
    CGRect currentBottomFrame=self.bottomView.frame;
    
    NSDictionary *userInfo=notification.userInfo;
    
    if(NULL==userInfo || userInfo==nil) return;
    
    
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    
    CGRect keyboardBeginingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    CGRect keyboardBeginingFrame = [self.view convertRect:keyboardBeginingUncorrectedFrame fromView:nil];
    
    
    
    CGFloat heightCha=keyboardEndingFrame.size.height-keyboardBeginingFrame.size.height;
    
    
    
    if(heightCha==0)
    {
        currentFrame.origin.y = currentFrame.origin.y -keyboardEndingFrame.size.height;
        //    self.navigationController.view.frame=currentFrame;
        currentBottomFrame.origin.y=currentBottomFrame.origin.y+keyboardEndingFrame.size.height;
    }
    else
    {
        currentFrame.origin.y = keyboardEndingFrame.size.height;
        //    self.navigationController.view.frame=currentFrame;
        currentBottomFrame.origin.y=currentBottomFrame.origin.y+heightCha;
    }
    
    
    
    
    //        currentFrame.origin.y = currentFrame.origin.y -change;
    //        currentBottomFrame.origin.y=currentBottomFrame.origin.y+change;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationController.view.frame=currentFrame;
        
        _bottomView.frame=currentBottomFrame;
        [_txtReply resignFirstResponder];
        //        [_tableView setContentOffset:CGPointMake(0.0, 0) animated:NO];
        
    }];
}


- (IBAction)btnSendClick:(id)sender {
    
    if (![self checkLogin:^{
        [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillShowNotification object:nil ];
        [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillHideNotification object:nil ];
    }]) {
        return;
    }

    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSInteger userId=[JRUser currentUser].userId;
    NSString *replyContent=_txtReply.text;
    if([replyContent isEqualToString:@""])
    {
        [self showTip:@"请填写回复"];
        return;
    }
    
    NSInteger replyId=_model.replyId;
    NSInteger replyUserId=_model.userId;
    
    if(NULL==_model)
    {
        replyId=_commentModel.id;
    }
    
    [param setValue:@(userId) forKey:@"userId"];
    [param setObject:@(replyId) forKey:@"replyId"];
    [param setObject:replyContent forKey:@"content"];
    [param setObject:@(replyUserId) forKey:@"replyUserId"];
    [self showHUDFromTitle:@"添加回复中"];
    
    
    [[ALEngine shareEngine] pathURL:JR_ADDREVIEW_REPLAY parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        
        if (!error) {
            
            _txtReply.text=@"";
            [_txtReply resignFirstResponder];
            [_tableView headerBeginRefreshing];
            _model=nil;
            
            
        }
        
    }];
    
    
    
    
    
}


#pragma  mark 添加回复

@end
