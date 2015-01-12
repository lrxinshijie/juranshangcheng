//
//  PersonalDatasMoreViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-27.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PersonalDatasMoreViewController.h"
#import "DetailAddressViewController.h"
#import "TextFieldCell.h"
#import "JRDesigner.h"
#import "ActionSheetStringPicker.h"
#import "ModifyViewController.h"

@interface PersonalDatasMoreViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    
}

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) UITextField *selectedTextField;

@end

@implementation PersonalDatasMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationItem.title = @"更多资料";
    [self setupDatas];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_user) {
        [self reloadData];
    }
}

- (void)setupDatas{
    [self resetValues];
    self.keys = @[@"证件信息", @"QQ", @"微信", @"所学专业", @"专业类型", @"证书与奖项"];
    self.tags = @[@"", @"1101", @"1102", @"1103", @"", @""];
    self.placeholders = @[@"", @"请输入QQ", @"请输入微信", @"请输入所学专业", @"", @""];
}

- (void)reloadData{
    [self resetValues];
    [_tableView reloadData];
}

- (void)resetValues{
    self.values = @[[_user idCardInfomation], _user.qq, _user.weixin, _user.professional, [_user professionalTypeString], _user.personalHonor];
}

- (void)setupUI{
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.keys.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5) {
        static NSString *cellIdentifier = @"personalDataMore";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize+2];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        }
        cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 8, 15) image:[UIImage imageNamed:@"cellIndicator.png"]];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = @"";
        
        
        cell.textLabel.text = _keys[indexPath.row];
        NSString *value = _values[indexPath.row];
        cell.detailTextLabel.text = value;
        if ([value isEqualToString:@"未设置"]) {
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        return cell;
    }else{
        static NSString *CellIdentifier = @"TextFieldCell";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (TextFieldCell *)[nibs firstObject];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textField.enabled = YES;
        cell.textField.delegate = self;
        cell.textField.tag = [_tags[indexPath.row] integerValue];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.titleLabel.text =  _keys[indexPath.row];
        cell.textField.placeholder = _placeholders[indexPath.row];
        cell.textField.text = _values[indexPath.row];
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.selectedTextField resignFirstResponder];
    if (indexPath.row == 5){
        DetailAddressViewController *vc = [[DetailAddressViewController alloc] init];
        vc.user = _user;
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        NSMutableArray *rows = [NSMutableArray array];
        __block NSInteger ind = 0;
        NSArray *professionalType = [[DefaultData sharedData] professionalType];
        [professionalType enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [rows addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_user.professionalType]) {
                ind = idx;
            }
        }];
        [ActionSheetStringPicker showPickerWithTitle:nil rows:rows initialSelection:ind doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                NSArray *professionalType = [[DefaultData sharedData] professionalType];
                _user.professionalType = [[professionalType objectAtIndex:selectedIndex] objectForKey:@"v"];
            [self reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:[UIApplication sharedApplication].keyWindow];
    }else if (indexPath.row == 0){
        ModifyViewController *vc = [[ModifyViewController alloc] initWithMemberDetail:_user type:ModifyCVTypeIdType];
        vc.title = _keys[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isContainsEmoji]) {
        return NO;
    }
    
//    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
//    if (textField.tag == 1100) {
//        if(![self isPureNumandCharacters:string] && ![string isEqualToString:@"-"]){
//            [self showTip:@"请输入合法字符！！"];
//            return NO;
//        }
//    }
    
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.selectedTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
   if (textField.tag == 1101){
        _user.qq = textField.text;
    }else if (textField.tag == 1102){
        _user.weixin = textField.text;
    }else if(textField.tag == 1103){
        _user.professional = textField.text;
    }
    [self resetValues];
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

//判断是否为数字
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

@end
