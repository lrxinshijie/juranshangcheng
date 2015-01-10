//
//  CaseIntroduceViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/3.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CaseIntroduceViewController.h"
#import "TextFieldCell.h"
#import "JRCase.h"
#import "ActionSheetMultiPicker.h"
#import "BaseAddressViewController.h"
#import "ActionSheetStringPicker.h"
#import "CaseImageManagemanetViewController.h"

@interface CaseIntroduceViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSArray *values;

@end

@implementation CaseIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    _keys = @[@"方案名称", @"地区", @"楼盘", @"户型", @"风格", @"面积(㎡)", @"参考价格(万元)", @"描述"];
    self.placeholders = @[@"请输入方案名称",@"请选择",@"请输入文字", @"请选择",@"请选择",@"请输入数字",@"请输入数字",@"请输入文字"];
    
    if (_jrCase) {
        self.navigationItem.title = @"方案介绍";
    }else{
        self.navigationItem.title = @"新增方案";
        UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onNext) title:@"下一步" backgroundImage:nil];
        [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.jrCase = [[JRCase alloc] init];
    }
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    [self reloadData];
}

- (void)onNext{
    [self.view endEditing:YES];
    
    if (_jrCase.title.length == 0) {
        [self showTip:@"方案名称不能为空"];
        return;
    }
    
    if (_jrCase.areaInfo.title.length == 0) {
        [self showTip:@"地区不能为空"];
        return;
    }
    
    if (_jrCase.neighbourhoods.length == 0) {
        [self showTip:@"楼盘不能为空"];
        return;
    }
    
    if (_jrCase.roomNumString.length == 0) {
        [self showTip:@"户型不能为空"];
        return;
    }
    
    if (_jrCase.styleString.length == 0) {
        [self showTip:@"风格不能为空"];
        return;
    }
    
    if (_jrCase.houseArea.length == 0) {
        [self showTip:@"面积不能为空"];
        return;
    }
    
    if (_jrCase.projectPrice.length == 0) {
        [self showTip:@"参考价格不能为空"];
        return;
    }
    
    CaseImageManagemanetViewController *cv = [[CaseImageManagemanetViewController alloc] init];
    cv.jrCase = _jrCase;
    [self.navigationController pushViewController:cv animated:YES];
}

- (void)reloadData{
    self.values = @[_jrCase.title,_jrCase.areaInfo.title, _jrCase.neighbourhoods, _jrCase.roomNumString,_jrCase.styleString,[NSString stringWithFormat:@"%@",_jrCase.houseArea],[NSString stringWithFormat:@"%@",_jrCase.projectPrice],_jrCase.desc];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _keys.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"TextFieldCell";
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (TextFieldCell *)[nibs firstObject];
//        cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryView = UITableViewCellAccessoryNone;
    
    cell.titleLabel.text = _keys[indexPath.row];
    cell.textField.enabled = _jrCase.projectId.length == 0;
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    cell.textField.placeholder = [_placeholders objectAtIndex:indexPath.row];
    cell.textField.text = [_values objectAtIndex:indexPath.row];
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    
    if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textField.enabled = NO;
    }
    
    if (indexPath.row == 5 || indexPath.row == 6){
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    
    
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        _jrCase.title = textField.text;
    }else if (textField.tag == 2){
        _jrCase.neighbourhoods = textField.text;
    }else if (textField.tag == 5){
        _jrCase.houseArea = textField.text;
    }else if (textField.tag == 6){
        _jrCase.projectPrice = textField.text;
    }else if (textField.tag == 7){
        _jrCase.desc = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isContainsEmoji]) {
        return NO;
    }
    
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 5 || textField.tag == 6){
        double budget = [value doubleValue];
        if (budget < 0 || budget > 9999.99) {
            return NO;
        }
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
//    [_selectedTextField resignFirstResponder];
    
    if (_jrCase.projectId.length > 0) {
        return;
    }
    
    if (indexPath.row == 1) {
        BaseAddressViewController *vc = [[BaseAddressViewController alloc] init];
        [vc setFinishBlock:^(JRAreaInfo *areaInfo) {
            _jrCase.areaInfo = areaInfo;
            [self reloadData];
        }];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        NSMutableArray *rows = [NSMutableArray array];
        __block NSInteger ind = 0;
        
        NSArray *renovationStyle = [[DefaultData sharedData] renovationStyle];
        [renovationStyle enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [rows addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_jrCase.projectStyle]) {
                ind = idx;
            }
        }];
        
        [ActionSheetStringPicker showPickerWithTitle:nil rows:rows initialSelection:ind doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            NSArray *renovationStyle = [[DefaultData sharedData] renovationStyle];
            _jrCase.projectStyle = [[renovationStyle objectAtIndex:selectedIndex] objectForKey:@"v"];
            [self reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:[UIApplication sharedApplication].keyWindow];
    }else if (indexPath.row == 3){
        NSMutableArray *rows = [NSMutableArray array];
        NSMutableArray *selects = [NSMutableArray array];
        
        NSMutableArray *datas = [NSMutableArray array];
        __block NSInteger ind = 0;
        NSArray *roomNum = [[DefaultData sharedData] roomNum];
        [roomNum enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [datas addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_jrCase.roomNum]) {
                ind = idx;
            }
        }];
        [rows addObject:datas];
        [selects addObject:@(ind)];
        
        ind = 0;
        NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
        datas = [NSMutableArray array];
        [livingroomCount enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [datas addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_jrCase.livingroomCount]) {
                ind = idx;
            }
        }];
        [rows addObject:datas];
        [selects addObject:@(ind)];
        
        ind = 0;
        NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
        datas = [NSMutableArray array];
        [bathroomCount enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [datas addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_jrCase.bathroomCount]) {
                ind = idx;
            }
        }];
        [rows addObject:datas];
        [selects addObject:@(ind)];
        
        [ActionSheetMultiPicker showPickerWithTitle:nil rows:rows initialSelection:selects doneBlock:^(ActionSheetMultiPicker *picker, NSArray *selectedIndexs, NSArray *selectedValues) {
            NSArray *roomNum = [[DefaultData sharedData] roomNum];
            _jrCase.roomNum = [[roomNum objectAtIndex:[selectedIndexs[0] integerValue]] objectForKey:@"v"];
            
            NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
            _jrCase.livingroomCount = [[livingroomCount objectAtIndex:[selectedIndexs[1] integerValue]] objectForKey:@"v"];
            
            NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
            _jrCase.bathroomCount = [[bathroomCount objectAtIndex:[selectedIndexs[2] integerValue]] objectForKey:@"v"];
            
            [self reloadData];
        } cancelBlock:^(ActionSheetMultiPicker *picker) {
            
        } origin:[UIApplication sharedApplication].keyWindow];
    }
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

@end
