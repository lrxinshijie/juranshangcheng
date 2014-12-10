//
//  SearchViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-9.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SearchViewController.h"

#define kKeywordsButtonTag 3330

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSInteger step;
    NSArray *searchHistorys;
    NSArray *searchOptions;
}
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *keywordsFooterView;
@property (nonatomic, strong) IBOutlet UIView *clearHistoryView;

@end

@implementation SearchViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    searchOptions = @[@"在设计师中搜索", @"在作品案例中搜索", @"在答疑解惑中搜索"];
    self.navigationItem.title = @"系统消息";
    step = 1;
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)setupUI{
    
    CGRect frame = _headerView.frame;
    frame.origin = CGPointMake(0, 0);
    _headerView.frame = frame;
    [self.view addSubview:_headerView];
    
    frame = kContentFrameWithoutNavigationBar;
    frame.origin.y = CGRectGetMaxY(_headerView.frame);
    frame.size.height -= CGRectGetHeight(_headerView.frame);
    
    self.tableView = [self.view tableViewWithFrame:frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIButton *btn = (UIButton*)[_clearHistoryView viewWithTag:3320];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 2.f;
    
    for (NSInteger i = 0; i < 9; i++) {
        btn = (UIButton*)[_keywordsFooterView viewWithTag:kKeywordsButtonTag + i];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2.f;
    }
}

- (void)reloadData{
    if (step == 1) {
        _tableView.tableHeaderView = _keywordsFooterView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }else if (step == 2) {
        searchHistorys = [Public searchHistorys];
        _tableView.tableHeaderView = nil;
        _tableView.tableFooterView = [searchHistorys.count? _clearHistoryView:[UIView alloc]init];
    }else if (step == 3){
        _tableView.tableHeaderView = nil;
        _tableView.tableFooterView = _clearHistoryView;
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target Action

- (IBAction)clearSearchHistor:(id)sender{
    [Public removeAllSearchHistory];
    [self reloadData];
}

- (IBAction)onSearch:(id)sender{
    if (!(_textField.text && _textField.text.length > 0)) {
        [self showTip:@"请输入搜索关键字"];
        return;
    }
    [Public addSearchHistory:_textField.text];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!(_textField.text && _textField.text.length > 0)) {
        step = 2;
        [self reloadData];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (!(_textField.text && _textField.text.length > 0)) {
        step = 1;
        [self reloadData];
    }
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


@end
