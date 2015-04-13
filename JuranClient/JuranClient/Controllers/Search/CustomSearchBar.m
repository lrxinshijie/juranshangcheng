//
//  CustomSearchBar.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CustomSearchBar.h"
#import "SearchTableViewCell.h"
#import "SearchHistoryManager.h"

@interface CustomSearchBar ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UIImageView *magnifyingGlass;
@property (strong, nonatomic) IBOutlet UIButton *cleanButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;


@property (strong, nonatomic) NSMutableArray * dataArray_History;
@property (strong, nonatomic) NSMutableArray * dataArray_SearchRange;
@property (assign, nonatomic) BOOL isHistory;

@property (strong, nonatomic) UIView * footerView;

@property (assign, nonatomic) RightBtnStyle rightBtnStyle;

@end

@implementation CustomSearchBar

- (void)awakeFromNib
{
    [self initUI];
}


- (void)initUI
{
    
    self.listTableView.frame = CGRectMake(0, 64, 320, 0);
    self.frame = CGRectMake(0, 0, 320, 64);
    
    [self cleanBtnHide];
    
    self.dataArray_History = [NSMutableArray arrayWithCapacity:0];
    self.dataArray_SearchRange = [NSMutableArray arrayWithCapacity:0];
    //TODO:测试数据，请删除
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"在XXX中搜索",@"searchRange",@"123",@"count",nil];
    self.dataArray_SearchRange = [NSMutableArray arrayWithArray:@[dict,dict,dict,dict,dict]];
    
    self.isHistory = YES;
    [self initHistoryData];
    NSLog(@"%@",self.dataArray_History);
}

- (void)initHistoryData
{
    __weak CustomSearchBar * wSelf = self;
    [[SearchHistoryManager sharedDataBase] localSearchHistoryList:^(NSArray *list) {
        
        [wSelf.dataArray_History removeAllObjects];
        [wSelf.dataArray_History addObjectsFromArray:list];
        
    }];
}

- (IBAction)gobackButtonDidClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goBackButtonDidSelect)]) {
        [self.delegate goBackButtonDidSelect];
    }
    
}

- (IBAction)cleanButtonDidClick:(id)sender {
    
    self.inputTextField.text = nil;
    if (!self.isHistory) {
        [self changeListStyleAnimation];
    }
   
    
}

- (IBAction)rightButtonDidClick:(id)sender {
    
    if (self.rightBtnStyle == RightBtnStyle_Scan) {
        
        if (self.delegate && [self.delegate respondsToSelector: @selector(pushToQRCodeVCDidTriggered)]) {
            [self.delegate pushToQRCodeVCDidTriggered];
        }
        
    }else if (self.rightBtnStyle == RightBtnStyle_Search){
        
        [self startSearch];
        
    }else if (self.rightBtnStyle == RightBtnStyle_More){
        //TODO:添加弹出菜单
    }
    
}

#pragma mark - TableViewDelegate && TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isHistory) {
        return self.dataArray_History.count;
    }else{
        return self.dataArray_SearchRange.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"SearchTableViewCell";
    SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] lastObject];
    }
    
    if (self.isHistory) {
        [cell setCellUIWithCellModel:SearchTableViewCellModel_History
                       leftLabelText:[self.dataArray_History objectAtIndex:indexPath.row]
                      rightLabelText:nil
         ];
    }else{
        [cell setCellUIWithCellModel:SearchTableViewCellModel_SearchRange
                       leftLabelText:[[self.dataArray_SearchRange objectAtIndex:indexPath.row] objectForKey:@"searchRange"]
                      rightLabelText:[[self.dataArray_SearchRange objectAtIndex:indexPath.row] objectForKey:@"count"]
         ];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.isHistory && self.dataArray_History.count>0) {
        return 50;
    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.isHistory && self.dataArray_History.count>0) {
        
        if (!self.footerView) {
            self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
            
            self.footerView.backgroundColor = [UIColor whiteColor];
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10, 3, 134, 30);
            button.layer.cornerRadius = 5.0;
            button.layer.masksToBounds = YES;
            button.center = self.footerView.center;
            button.backgroundColor = [UIColor redColor];
            [button setBackgroundImage:[UIImage imageNamed:@"search_clean_history"] forState:UIControlStateNormal];
            [button setTitle:@"清除搜索历史" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cleanHistory) forControlEvents:UIControlEventTouchUpInside];
            [self.footerView addSubview:button];
            
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            line.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
            [self.footerView addSubview:line];
        }
        return self.footerView;
        
    }
    return nil;
}

- (void)cleanHistory
{
    [[SearchHistoryManager sharedDataBase] deleteAllLocalHistory];
    [self initHistoryData];
    [self showAnimation];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell * cell = (SearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.inputTextField resignFirstResponder];
    if (self.isHistory) {
        
        self.inputTextField.text = [cell getSearchCellMessage];
        [self changeListStyleAnimation];
        
    }else{
        
        [self hideAnimation];
        [self startSearch];
        
    }
}


#pragma mark - TextFieldDalegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.inputTextField.text == nil || self.inputTextField.text.length == 0) {
        self.isHistory = YES;
    }
    [self showAnimation];
    [self cleanBtnShow];
    [self magnifyingGlassHide];
    self.inputTextField.placeholder = nil;
    [self rightButtonChangeStyleWithKey:RightBtnStyle_Search];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self changeListStyleAnimation];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self changeListStyleAnimation];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputTextField resignFirstResponder];
    [self cleanBtnHide];
    return YES;
}


#pragma mark - 搜索的方法
- (void)startSearch
{
    [self.inputTextField resignFirstResponder];
    
    
    //TODO:入库去重
    NSString * str = @"商品名称";
    BOOL isExist = NO;
    for (int i=0; i<self.dataArray_History.count; i++) {
        if ([str isEqualToString:self.dataArray_History[i]]) {
            isExist = YES;
            break;
        }
    }
    //搜索历史入库
    if (!isExist) {
        [[SearchHistoryManager sharedDataBase] insertSearchItem:@"商品名称"];
    }
    
    //TODO:等待接口，实现代码
}

#pragma mark - 动画方法

//展开View的动画方法
- (void)showAnimation
{
    __weak CustomSearchBar * wSelf = self;
    
    float height = 0.0;
    
    if (self.dataArray_History.count>0) {
        
        if (self.dataArray_History.count*36+50>200) {
            height = 200.0;
        }else{
            height = self.dataArray_History.count * 36 + 50;
        }
        
    }
    
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        wSelf.frame = CGRectMake(0, 0, 320, screenHeight);
        wSelf.listTableView.frame = CGRectMake(0, 64, 320, height);
        [wSelf.listTableView reloadData];
        
    }];
}

//收起View的动画方法
- (void)hideAnimation
{
    __weak CustomSearchBar * wSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        wSelf.frame = CGRectMake(0, 0, 320, 64);
        wSelf.listTableView.frame = CGRectMake(0, 64, 320, 0);
    }];
        
}

//搜索历史和搜索范围切换动画
- (void)changeListStyleAnimation
{
    __weak CustomSearchBar * wSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^{
       
        wSelf.listTableView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        wSelf.isHistory = !wSelf.isHistory;
        [wSelf changeListStyleChildAnimation];
        
    }];
}

- (void)changeListStyleChildAnimation
{
    __weak CustomSearchBar * wSelf = self;
    
    float height = 0.0;
    
    if (self.dataArray_History.count>0) {
        
        if (self.dataArray_History.count*36+50>200) {
            height = 200.0;
        }else{
            height = self.dataArray_History.count * 36 + 50;
        }
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        wSelf.listTableView.frame = CGRectMake(0, 64, 320, height);
        wSelf.listTableView.alpha = 1.0;
        [wSelf.listTableView reloadData];
        
    }];
    
}


- (void)cleanBtnShow
{
    self.cleanButton.hidden = NO;
}

- (void)cleanBtnHide
{
    self.cleanButton.hidden = YES;
}

- (void)magnifyingGlassHide
{
    self.magnifyingGlass.hidden = YES;
}

- (void)magnifyingGlassShow
{
    self.magnifyingGlass.hidden = NO;
}

- (void)rightButtonChangeStyleWithKey:(RightBtnStyle)style
{
    
    self.rightBtnStyle = style;
    
    if (style == RightBtnStyle_Scan) {
        
        [self.rightButton setTitle:nil forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"search_scancode@2x"] forState:UIControlStateNormal];
        
    }else if (style == RightBtnStyle_Search){
        
        [self.rightButton setTitle:@"搜索" forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor colorWithRed:11.0/255.0 green:82.0/255.0 blue:168.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        
    }else if (style == RightBtnStyle_More){
        
        [self.rightButton setTitle:nil forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"search_scancode@2x"] forState:UIControlStateNormal];
        
    }
}

























@end
