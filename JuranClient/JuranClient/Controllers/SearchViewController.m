//
//  SearchViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-9.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SearchViewController.h"
#import "DesignerViewController.h"
#import "CaseViewController.h"
#import "QuestionViewController.h"
#import "IQKeyboardManager.h"
#import "ShopListViewController.h"
#import "ProductListViewController.h"
#import "CustomSearchBar.h"
#import "QRBaseViewController.h"
#import "UIViewController+Menu.h"
#import "ProductFilterData.h"

#define kKeywordsButtonTag 3330

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIScrollViewDelegate,CustomSearchBarDelegate>
{
    NSInteger step;
    NSArray *searchHistorys;
    NSArray *searchOptions;
    NSArray *hotWords;
    CGSize keyboardSize;
}
@property (nonatomic, strong) NSString *searchKeyWord;

@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *keywordsFooterView;
@property (nonatomic, strong) IBOutlet UIView *clearHistoryView;

@end

@implementation SearchViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    
    searchOptions = @[@"在作品案例中搜索", @"在设计师中搜索", @"在答疑解惑中搜索", @"在商品中搜索", @"在店铺中搜索"];
    
    self.navigationItem.title = @"搜索";
    step = 1;
    [self setupUI];
    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.headerView.hidden = YES;
    [self reloadData];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_HOTWORDS parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *hotWordStr = data[@"appKeyWords"];
                if (hotWordStr && hotWordStr.length > 0) {
                    hotWords = [hotWordStr componentsSeparatedByString:@","];
                }
                [self setupHotwordsView];
            }
            [self reloadData];
        }
    }];
}

- (void)setupUI{
    self.view.backgroundColor = RGBColor(241, 241, 241);
    
    UIButton *btn = [self.view buttonWithFrame:kContentFrameWithoutNavigationBar target:self action:@selector(handleTap:) image:nil];
    [self.view addSubview:btn];
    
    
    CustomSearchBar * customSB = [[[NSBundle mainBundle] loadNibNamed:@"CustomSearchBar" owner:self options:nil] lastObject];
    [customSB setSearchButtonType:SearchButtonType_Case];
    [customSB setEnabled:YES];
    customSB.delegate = self;
    [customSB rightButtonChangeStyleWithKey:RightBtnStyle_Scan];
    customSB.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    [self.view addSubview:customSB];
    
    
    //旧逻辑，为避免引起连锁问题暂时不删除
//    CGRect frame = _headerView.frame;
//    frame.origin = CGPointMake(0, 0);
//    _headerView.frame = frame;
//    [self.view addSubview:_headerView];
//    
//    frame = _keywordsFooterView.frame;
//    frame.origin.y = CGRectGetMaxY(_headerView.frame);
//    _keywordsFooterView.frame = frame;
//    [self.view addSubview:_keywordsFooterView];
//    
//    frame = kContentFrameWithoutNavigationBar;
//    frame.origin.y = CGRectGetMaxY(_headerView.frame);
//    frame.size.height = 0;
//    
//    self.tableView = [self.view tableViewWithFrame:frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
//    self.tableView.backgroundColor = RGBColor(241, 241, 241);
//    _tableView.tableFooterView = [[UIView alloc] init];
//    _tableView.tableHeaderView = [[UIView alloc] init];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:_tableView];
    
//    btn = (UIButton*)[_clearHistoryView viewWithTag:3320];
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = 2.f;
    
}

#pragma mark - CustomSearchBarDelegate
- (void)goBackButtonDidSelect
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushToQRCodeVCDidTriggered
{
    QRBaseViewController * qrVC = [[QRBaseViewController alloc] initWithNibName:@"QRBaseViewController" bundle:nil isPopNavHide:YES];
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (void)startSearchWithKeyWord:(NSString *)keyWord index:(int)index
{
    _textField.text = keyWord;
    switch (index) {
        case 0:
            _type = SearchTypeCase;
            break;
        case 1:
            _type = SearchTypeGoods;
            break;
        case 2:
            _type = SearchTypeShop;
            break;
        case 3:
            _type = SearchTypeDesigner;
            break;
        case 4:
            _type = SearchTypeQuestion;
            break;
        default:
            break;
    }
    [self doSearch];
}

- (void)showMenuList
{
    [self showAppMenu:nil];
}



- (void)setupHotwordsView{
    for (UIView *v in _keywordsFooterView.subviews) {
        [v removeFromSuperview];
    }
    NSInteger i = 0;
    for (NSString *hotword in hotWords) {
        CGRect frame = CGRectMake(5 + (i%3)*105, 5 + (i/3)*40, 100, 35);
        UIButton *btn = [_keywordsFooterView buttonWithFrame:frame target:self action:@selector(onHotWordSearch:) title:hotword backgroundImage:nil];
        btn.backgroundColor = RGBColor(209, 209, 209);
        [btn setTitleColor:RGBColor(101, 101, 101) forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2.f;
        [_keywordsFooterView addSubview:btn];
        i++;
    }
}

- (void)reloadData{
    if (step == 1) {
        CGRect frame = _tableView.frame;
        frame.size.height = 0;
        _tableView.frame = frame;
        _keywordsFooterView.hidden = NO;
    }else if (step == 2) {
        _keywordsFooterView.hidden = YES;
        searchHistorys = [Public searchHistorys];
        //判断历史记录是否为0
        if (searchHistorys.count > 0) {
            _tableView.tableFooterView = _clearHistoryView;
            CGRect frame = _tableView.frame;
            frame.size.height = CGRectGetHeight(_clearHistoryView.frame) + 35 * searchHistorys.count;
            if (frame.size.height > kWindowHeightWithoutNavigationBar - CGRectGetHeight(_headerView.frame) - keyboardSize.height) {
                frame.size.height = kWindowHeightWithoutNavigationBar - CGRectGetHeight(_headerView.frame)- keyboardSize.height;
            }
            _tableView.frame = frame;
        }else{
            _tableView.tableFooterView = [[UIView alloc] init];
            CGRect frame = _tableView.frame;
            frame.size.height = 0;
            _tableView.frame = frame;
        }
    }else if (step == 3){
        _keywordsFooterView.hidden = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
        CGRect frame = _tableView.frame;
        frame.size.height = 35 * searchOptions.count;
        _tableView.frame = frame;
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doSearch{
    _searchKeyWord = _textField.text;
    //旧逻辑，暂不删除
//    [_textField resignFirstResponder];
//    [self hideTableList];
//    [Public addSearchHistory:_textField.text];
    if (_type == SearchTypeDesigner) {
        DesignerViewController *vc = [[DesignerViewController alloc] init];
        vc.searchKeyWord = _searchKeyWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_type == SearchTypeCase){
        CaseViewController *vc = [[CaseViewController alloc] init];
        vc.searchKey = _searchKeyWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_type == SearchTypeQuestion){
        QuestionViewController *vc = [[QuestionViewController alloc] init];
        vc.searchKeyWord = _searchKeyWord;
        vc.isSearchResult = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (_type == SearchTypeGoods){
        ProductListViewController *vc = [[ProductListViewController alloc]init];
        vc.selectedFilter.keyword = _searchKeyWord;
        vc.selectedFilter.isInShop = NO;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (_type == SearchTypeShop){
        
        ShopListViewController * vc = [[ShopListViewController alloc] init];
        vc.keyword = _searchKeyWord;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - Target Action

- (void)onHotWordSearch:(id)sender{
    UIButton *btn = (UIButton*)sender;
    _searchKeyWord = btn.titleLabel.text;
    _textField.text = _searchKeyWord;
    [_textField becomeFirstResponder];
}

- (IBAction)clearSearchHistor:(id)sender{
    [Public removeAllSearchHistory];
    [self reloadData];
}

- (IBAction)onSearch:(id)sender{
    if (!(_textField.text && _textField.text.length > 0)) {
        [self showTip:@"请输入搜索关键字"];
        return;
    }
    _type = SearchTypeCase;
    [self doSearch];
}

- (void)handleTap:(id)sender{
    [_textField resignFirstResponder];
    //下边这个方法是刷新TableView并设置行数为0以达到收起的效果，此收起逻辑为原有逻辑，此处沿用。
    //此逻辑之所以不放在textField结束编辑的代理中是因为当键盘遮挡住搜索历史的时候需要收起键盘但不能收起列表。
    [self hideTableList];
}

#pragma mark - UITableViewDataSource/Delegate

//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (step == 1) {
//        return _keywordsFooterView;
//    }else{
//        return nil;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (step == 1) {
//        return CGRectGetHeight(_tableView.frame) - 50;
//    }
//    return 0;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (step == 1) {
        return 0;
    }else if (step == 2){
        return searchHistorys.count;
    }else if (step == 3){
        return searchOptions.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 1, 310, 34)];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgView];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
     }
    if (step == 2 || step == 3) {
        cell.textLabel.text = step == 2?searchHistorys[indexPath.row]:searchOptions[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (step == 2) {
        _textField.text = searchHistorys[indexPath.row];
        [self textFieldTextDidChangeNotification:nil];
    }else if (step == 3){
        _type = (SearchType)indexPath.row;
        [self doSearch];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self onSearch:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isContainsEmoji]) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!(_textField.text && _textField.text.length > 0)) {
        step = 2;
        [self reloadData];
    }else{
        step = 3;
        [self reloadData];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void)textFieldTextDidChangeNotification:(NSNotification*)notification{
    if (!(_textField.text && _textField.text.length > 0)) {
        step = 2;
        [self reloadData];
    }else{
        step = 3;
        [self reloadData];
    }
}

- (void)hideTableList
{
    step = 1;
    [self reloadData];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    keyboardSize = [value CGRectValue].size;
    
    CGRect frame = _tableView.frame;
    if (frame.size.height > kWindowHeightWithoutNavigationBar - CGRectGetHeight(_headerView.frame) - keyboardSize.height) {
        frame.size.height = kWindowHeightWithoutNavigationBar - CGRectGetHeight(_headerView.frame)- keyboardSize.height;
         _tableView.frame = frame;
    }
}

@end
