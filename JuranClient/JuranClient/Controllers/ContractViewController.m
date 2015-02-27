//
//  ContractViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/2/26.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ContractViewController.h"
#import "JROrder.h"
#import "TextFieldCell.h"

@interface ContractViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSMutableDictionary *hiddenSectionDic;

@property (nonatomic, strong) IBOutlet UIView *waitFirstPayView;
@property (nonatomic, strong) IBOutlet UIView *designContentView;
@property (nonatomic, strong) IBOutlet UIView *tableFooterView;
@property (nonatomic, strong) UITextField *selectedTextField;

@end

@implementation ContractViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"创建设计合同";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    self.keys = @[@[@"量房合同编号", @"合同金额（元）", @"量房日期", @"待支付首款", @"尾款", @"设计工作内容"]
                  , @[@"真实姓名", @"用户名", @"手机号", @"微信号", @"会员卡号", @"电子邮箱", @"户型", @"面积", @"装修地址", @"小区名称"]
                  , @[@"真实姓名", @"用户名", @"手机号", @"微信号", @"电子邮箱"]];
    self.values = @[];
    self.tags = @[@[@"", @"1200", @"", @"", @"", @""]
                  , @[@"1201", @"1202", @"1203", @"1204", @"1205", @"1206", @"", @"1207", @"", @"1208"]
                  , @[@"1209", @"1210", @"1211", @"1212", @"1213"]];
    self.hiddenSectionDic = [NSMutableDictionary dictionary];
    
    [self setupUI];
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = _tableFooterView;
    [self.view addSubview:_tableView];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIView *view = [_waitFirstPayView viewWithTag:1100 + i];
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = RGBColor(241, 241, 241).CGColor;
    }
    
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [_designContentView viewWithTag:1100 + i];
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = RGBColor(241, 241, 241).CGColor;
    }
    
    UIView *view = [_tableFooterView viewWithTag:1100];
    view.layer.borderWidth = .5f;
    view.layer.borderColor = [UIColor darkGrayColor].CGColor;
    view.layer.cornerRadius = 2.f;
    
    view = [_tableFooterView viewWithTag:1101];
    view.layer.borderWidth = .5f;
    view.layer.borderColor = RGBColor(0, 54, 114).CGColor;
    view.layer.cornerRadius = 2.f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target Action

- (void)onHiddenSection:(id)sender{
    UIButton *btn = (UIButton*)sender;
    if (_hiddenSectionDic[[NSString stringWithFormat:@"%d", btn.tag]]) {
        [_hiddenSectionDic removeObjectForKey:[NSString stringWithFormat:@"%d", btn.tag]];
    }else{
        [_hiddenSectionDic addEntriesFromDictionary:@{[NSString stringWithFormat:@"%d", btn.tag]:@""}];
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = _keys[section];
    if (_hiddenSectionDic[[NSString stringWithFormat:@"%d", section]]) {
        return 0;
    }
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 3) {
        return 140;
    }else if (indexPath.section == 0 && indexPath.row == 5){
        return 285;
    }
    return 36;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 35)];
    view.backgroundColor = RGBColor(226, 226, 226);
    
    UIButton *btn = [view buttonWithFrame:view.bounds target:self action:@selector(onHiddenSection:) image:nil];
    btn.tag = section;
    [view addSubview:btn];
    
    UILabel *label = [view labelWithFrame:CGRectMake(10, 5, 100, 15) text:@"" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    [view addSubview:label];
    
    if (section == 0) {
        label.text = @"合同信息";
    }else if (section == 1){
        label.text = @"消费者（甲方）";
    }else if (section == 2){
        label.text = @"设计师（乙方）";
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_hiddenSectionDic[[NSString stringWithFormat:@"%d", section]]?@"arrow_up.png":@"arrow_down.png"]];
    imageView.center = CGPointMake(kWindowWidth - 10 - CGRectGetWidth(imageView.frame), CGRectGetHeight(view.frame)/2.f);
    [view addSubview:imageView];
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && (indexPath.row == 1)) || (indexPath.section == 1 && indexPath.row != 6 && indexPath.row != 8) || (indexPath.section == 2)) {
        static NSString *CellIdentifier = @"TextFieldCell";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (TextFieldCell *)[nibs firstObject];
        }
        
        cell.titleLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.titleLabel.textColor = [UIColor darkGrayColor];
        
        CGPoint center = cell.titleLabel.center;
        center.y = 18;
        cell.titleLabel.center = center;
        center = cell.textField.center;
        center.y = 18;
        center.x -= 5;
        cell.textField.center = center;
        
        cell.textField.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textField.enabled = YES;
        cell.textField.delegate = self;
//        cell.textField.tag = [_tags[indexPath.section][indexPath.row] integerValue];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text =  _keys[indexPath.section][indexPath.row];
        cell.textField.placeholder = @"请输入";
//        cell.textField.text = _values[indexPath.section][indexPath.row];
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        
        if (indexPath.section == 2 && (indexPath.row == 0 || indexPath.row == 2)) {
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"ContractCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        }
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        UIView *view = [cell.contentView viewWithTag:5555];
        if (view) {
            [view removeFromSuperview];
        }
        
        cell.accessoryView = nil;
        if (indexPath.section == 0 && indexPath.row == 3) {
            [cell.contentView addSubview:_waitFirstPayView];
        }else if (indexPath.section == 0 && indexPath.row == 5) {
            [cell.contentView addSubview:_designContentView];
        } else{
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellIndicator.png"]];
            cell.textLabel.text = _keys[indexPath.section][indexPath.row];
            NSString *value = @"";//_values[indexPath.section][indexPath.row];
            if (value.length == 0) {
                cell.detailTextLabel.text = @"请选择";
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            }else{
                cell.detailTextLabel.text = _values[indexPath.section][indexPath.row];
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedTextField) {
        [_selectedTextField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.selectedTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.tag == 1100) {
//        self.oldAccount = _user.account;
//        accountChangeTip = NO;
//        _user.account = textField.text;
//    }else if (textField.tag == 1101){
//        _user.nickName = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    }else if (textField.tag == 1102){
//        _user.homeTel = textField.text;
//    }else if (textField.tag == 1103){
//        _user.qq = textField.text;
//    }else if (textField.tag == 1104){
//        _user.weixin = textField.text;
//    }
//    [self reSetData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSTimeInterval animation = animationDuration;
    
    //视图移动的动画开始
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animation];
    CGRect frame = _tableView.frame;
    frame.size.height = kWindowHeightWithoutNavigationBar - keyboardSize.height;
    _tableView.frame = frame;
    
    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    _tableView.frame = kContentFrameWithoutNavigationBar;
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
