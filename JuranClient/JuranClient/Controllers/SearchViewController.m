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

#define kKeywordsButtonTag 3330

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    
    searchOptions = @[@"在设计师中搜索", @"在作品案例中搜索", @"在答疑解惑中搜索"];
    self.navigationItem.title = @"搜索";
    step = 1;
    [self setupUI];
//    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_HOTWORDS parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *hotWordStr = data[@"hotWords"];
                if (hotWordStr && hotWordStr.length > 0) {
                    hotWords = [hotWordStr componentsSeparatedByString:@","];
                }
            }
            [self reloadData];
        }
    }];
}

- (void)setupUI{
    self.view.backgroundColor = RGBColor(241, 241, 241);
    
    UIButton *btn = [self.view buttonWithFrame:kContentFrameWithoutNavigationBar target:self action:@selector(handleTap:) image:nil];
    [self.view addSubview:btn];
    
    CGRect frame = _headerView.frame;
    frame.origin = CGPointMake(0, 0);
    _headerView.frame = frame;
    [self.view addSubview:_headerView];
    
    frame = _keywordsFooterView.frame;
    frame.origin.y = CGRectGetMaxY(_headerView.frame);
    _keywordsFooterView.frame = frame;
    [self.view addSubview:_keywordsFooterView];
    
    frame = kContentFrameWithoutNavigationBar;
    frame.origin.y = CGRectGetMaxY(_headerView.frame);
    frame.size.height = 0;
    
    self.tableView = [self.view tableViewWithFrame:frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    btn = (UIButton*)[_clearHistoryView viewWithTag:3320];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 2.f;
    
    for (NSInteger i = 0; i < 9; i++) {
        btn = (UIButton*)[_keywordsFooterView viewWithTag:kKeywordsButtonTag + i];
        [btn addTarget:self action:@selector(onHotWordSearch:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2.f;
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
    if (_type == SearchTypeDesigner) {
        DesignerViewController *vc = [[DesignerViewController alloc] init];
        vc.searchKeyWord = _searchKeyWord;
        vc.isSearchResult = YES;
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
    _searchKeyWord = _textField.text;
    [_textField resignFirstResponder];
    [Public addSearchHistory:_textField.text];
    [self doSearch];
}

- (void)handleTap:(id)sender{
    [_textField resignFirstResponder];
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
        [self onSearch:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self onSearch:nil];
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
    step = 1;
    [self reloadData];
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
