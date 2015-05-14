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
#import "IQKeyboardManager.h"
#import "QRBaseViewController.h"

@interface CustomSearchBar ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL couldClick;
}

@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UIImageView *magnifyingGlass;
@property (strong, nonatomic) IBOutlet UIButton *cleanButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;


@property (strong, nonatomic) NSMutableArray * dataArray_History;
@property (strong, nonatomic) NSMutableArray * dataArray_SearchRange;
@property (assign, nonatomic) BOOL isHistory;
@property (assign, nonatomic) BOOL isReloadHistory;


@property (assign, nonatomic) NSInteger currentPageNo;
@property (strong, nonatomic) NSString * requestKeyWord;

@property (strong, nonatomic) UIView * footerView;

@property (assign, nonatomic) RightBtnStyle rightBtnStyle;

@property (assign, nonatomic) NSInteger searchType;

//用于判断是否需要展示搜索范围列表的属性
@property (assign, nonatomic) BOOL enabledShow;

@end

@implementation CustomSearchBar

- (void)awakeFromNib
{
    [self initUI];
}


- (void)initUI
{
    self.enabledShow = YES;
    couldClick = YES;
    self.listTableView.frame = CGRectMake(0, 64, 320, 0);
    self.frame = CGRectMake(0, 0, 320, 64);
    
    self.currentPageNo = 1;
    
    [self cleanBtnHide];
    
    self.dataArray_History = [NSMutableArray arrayWithCapacity:0];
    self.dataArray_SearchRange = [NSMutableArray arrayWithCapacity:0];

    NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:@"在作品案例中搜索",@"searchRange",@"",@"count",nil];
    NSDictionary * dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"在商品中搜索",@"searchRange",@"",@"count",nil];
    NSDictionary * dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"在店铺中搜索",@"searchRange",@"",@"count",nil];
    NSDictionary * dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"在设计师中搜索",@"searchRange",@"",@"count",nil];
    NSDictionary * dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"在答疑解惑中搜索",@"searchRange",@"",@"count",nil];
    
    self.dataArray_SearchRange = [NSMutableArray arrayWithArray:@[dict,dict1,dict2,dict3,dict4]];
    
    self.isReloadHistory = NO;
    self.isHistory = YES;
    [self initHistoryData];
//    NSLog(@"%@",self.dataArray_History);
    
    
    //输入偏左问题
    CGRect frame = _inputTextField.frame;
    frame.size.width  = 15;
    UIView *leftView = [[UIView alloc]initWithFrame:frame];
    _inputTextField.leftViewMode = UITextFieldViewModeAlways;
    _inputTextField.leftView = leftView;
}

- (void)initHistoryData
{
    __weak CustomSearchBar * wSelf = self;
    [[SearchHistoryManager sharedDataBase] localSearchHistoryList:^(NSArray *list) {
        
        [wSelf.dataArray_History removeAllObjects];
        [wSelf.dataArray_History addObjectsFromArray:list];
        
        //对于清除历史后重载历史列表不及时的暂时处理方法，添加属性isReloadHistory判断是不是重载历史列表，如果是则刷新列表并调整列表高度
        if (wSelf.isReloadHistory) {
            [wSelf.listTableView reloadData];
            [wSelf showAnimation];
            wSelf.isReloadHistory = NO;
        }
        
    }];
}

- (IBAction)gobackButtonDidClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goBackButtonDidSelect)]) {
        [self.delegate goBackButtonDidSelect];
    }
    
}

- (IBAction)cleanButtonDidClick:(id)sender {
    
    self.inputTextField.text = nil;
    [_inputTextField becomeFirstResponder];
//    if (!self.isHistory) {
//        [self changeListStyleAnimation];
//    }
    
}

- (IBAction)rightButtonDidClick:(id)sender {
    
    if (self.rightBtnStyle == RightBtnStyle_Scan) {
        if (![QRBaseViewController isRuning]) {
            QRBaseViewController * vc = [[QRBaseViewController alloc] initWithNibName:@"QRBaseViewController" bundle:nil isPopNavHide:NO];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
    }else if (self.rightBtnStyle == RightBtnStyle_Search){
        //默认按照下拉列表中的第一个搜索
        [self hideAnimation];
        [self startSearchAtIndex:self.searchType];
        
    }else if (self.rightBtnStyle == RightBtnStyle_More){
        //添加弹出菜单
        if (self.delegate && [self.delegate respondsToSelector:@selector(showMenuList)]) {
            [self.delegate showMenuList];
        }
    }
    
}

#pragma mark - TableViewDelegate && TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isHistory) {
        return self.dataArray_History.count;
    }else{
        if (self.enabledShow) {
            return self.dataArray_SearchRange.count;
        }else{
            //当逻辑上应该展示搜索范围而设置不允许展示的时候，返回0个cell已达到不展示的效果。
            return 0;
        }
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
    self.isReloadHistory = YES;
    [self initHistoryData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell * cell = (SearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.isHistory) {
        
        self.inputTextField.text = [cell getSearchCellMessage];
        [self changeListStyleAnimation];
        
    }else{
        
        [self hideAnimation];
        [self startSearchAtIndex:indexPath.row];
        [self.inputTextField resignFirstResponder];
        
    }
}


#pragma mark - TextFieldDalegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //通知上层搜索的背景要展开，如果上层有已经展开的浮层可在此代理中酌情处理。
    if (self.delegate && [self.delegate respondsToSelector:@selector(customSearchStartWork)]) {
        [self.delegate customSearchStartWork];
    }
    
    if (textField.text.length == 0) {
        self.isHistory = NO;
    }else{
        self.isHistory = YES;
    }
    [self showAnimation];
    [self cleanBtnShow];
    [self magnifyingGlassHide];
    self.inputTextField.placeholder = nil;
    [self rightButtonChangeStyleWithKey:RightBtnStyle_Search];
    [self changeListStyleAnimation];
    
    //此处是为了解决BUG添加的代码，目的是吧奇葩的第三方键盘添加在串口上的手势关掉，否则，会出现响应手势收起键盘而不响应本类中的一些触发事件。
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = NO;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 0) {
        [self changeListStyleAnimation];
    }
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
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputTextField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

    [self rightButtonChangeStyleWithKey:RightBtnStyle_Scan];
    [self hideAnimation];
    if (textField.text.length == 0) {
        [self cleanBtnHide];
        [self magnifyingGlassShow];
        self.inputTextField.placeholder = @"      请输入搜索关键字";
    }
}


#pragma mark - 搜索的方法
- (void)startSearchAtIndex:(int)index
{
    [self.inputTextField resignFirstResponder];
    
    
    //入库去重
    NSString * str = self.inputTextField.text;
    
    BOOL isExist = NO;
    for (int i=0; i<self.dataArray_History.count; i++) {
        if ([str isEqualToString:self.dataArray_History[i]]) {
            isExist = YES;
            break;
        }
    }
    
    if (self.inputTextField.text == nil || self.inputTextField.text.length ==  0) {
        isExist = YES;
    }
    
    if (![self.requestKeyWord isEqualToString:str] && str.length!=0 && str != nil) {
        self.requestKeyWord = str;
    }
    
    //搜索历史入库
    if (!isExist) {
        [[SearchHistoryManager sharedDataBase] insertSearchItem:str];
    }
    //每次都更新一下历史记录的数据，以防同一次搜索多次点击
    [self initHistoryData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(startSearchWithKeyWord:index:)]) {
        [self.delegate startSearchWithKeyWord:_inputTextField.text index:index];
    }
    
}

- (void)setSearchButtonType:(SearchButtonType)type
{
    self.searchType = type;
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
    
    int tempCount = self.isHistory?self.dataArray_History.count:(self.enabledShow?self.dataArray_SearchRange.count:0);
    
    if (tempCount>0) {
        
        if (tempCount*36+50>200) {
            height = 200.0;
        }else{
            height = tempCount * 36 + 50;
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
    CGRect frame = self.inputTextField.frame;
    frame.size.width = 202;
    __weak CustomSearchBar * wSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        wSelf.inputTextField.frame = frame;
    }];
    self.cleanButton.hidden = NO;
}

- (void)cleanBtnHide
{
    CGRect frame = self.inputTextField.frame;
    frame.size.width = 232;
    __weak CustomSearchBar * wSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        wSelf.inputTextField.frame = frame;
    }];
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
        [self.rightButton setImage:[UIImage imageNamed:@"search_scancode"] forState:UIControlStateNormal];
        
    }else if (style == RightBtnStyle_Search){
        
        [self.rightButton setTitle:@"搜索" forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor colorWithRed:11.0/255.0 green:82.0/255.0 blue:168.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        
    }else if (style == RightBtnStyle_More){
        
        [self.rightButton setTitle:nil forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"search_more"] forState:UIControlStateNormal];
        
    }
}

- (void)requestForNewDataWithCurrentPageNo:(NSInteger)pageNo
{
    self.currentPageNo = pageNo;
    
}

- (void)setEnabled:(BOOL)enabledShow
{
    self.enabledShow = enabledShow;
}

- (void)setTextFieldText:(NSString *)text
{
    self.inputTextField.text = text;
    
    [self magnifyingGlassHide];
}

@end
