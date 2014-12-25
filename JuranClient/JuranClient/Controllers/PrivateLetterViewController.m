//
//  PrivateLetterViewController.m
//  JuranClient
//
//  Created by Kowloon on 14/12/17.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PrivateLetterViewController.h"
#import "TextFieldCell.h"
#import "ActionSheetStringPicker.h"
#import "JRDesigner.h"

@interface PrivateLetterViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIButton *checkButton;
@property (nonatomic, strong) IBOutlet UIButton *arrowButton;
@property (nonatomic, strong) IBOutlet ASPlaceholderTextView *contentTextView;
@property (nonatomic, strong) UITextField *selectedTextField;
@property (nonatomic, strong) UITapGestureRecognizer *tapHide;
@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, assign) BOOL isPopview;

@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *mobilePhone;
@property (nonatomic, copy) NSString *likeStyle;
@property (nonatomic, copy) NSString *likeStyleKey;
@property (nonatomic, copy) NSString *houseArea;

- (IBAction)onCheck:(id)sender;
- (IBAction)onArrow:(id)sender;

@end

@implementation PrivateLetterViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"私信";
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 40, 30) target:self action:@selector(onSubmit) title:@"发布" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.senderName = @"";
    self.mobilePhone = @"";
    self.likeStyle = @"";
    self.houseArea = @"";
    self.likeStyleKey = @"";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    _contentTextView.backgroundColor = [UIColor whiteColor];
    _contentTextView.placeholder = @"请输入私信内容";
    _contentTextView.delegate = self;
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(237, 237, 237);
    [self.view addSubview:_tableView];
    self.tapHide = [_tableView addTapGestureRecognizerWithTarget:self action:@selector(hideKeyboard)];
    _tableView.tableHeaderView = _headerView;
    
    self.isCheck = YES;
    self.isPopview = YES;
}

- (IBAction)onCheck:(id)sender{
    self.isCheck = !_isCheck;
}

- (IBAction)onArrow:(id)sender{
    self.isPopview = !_isPopview;
}

- (void)setIsCheck:(BOOL)isCheck{
    _isCheck = isCheck;
    
    [_checkButton setImage:[UIImage imageNamed:_isCheck ? @"checkbox_checked_okk" : @"checkbox_checked"] forState:UIControlStateNormal];
}

- (void)setIsPopview:(BOOL)isPopview{
    _isPopview = isPopview;
    
    [_arrowButton setImage:[UIImage imageNamed:_isPopview ? @"arrow_up" : @"arrow_down"] forState:UIControlStateNormal];
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _isPopview ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TextFieldCell";
    TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (TextFieldCell *)[nibs firstObject];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *placeholder = @"";
    NSString *title = @"";
    if (indexPath.row == 0) {
        placeholder = @"您的姓名";
        title = @"姓名";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.text = _senderName;
    }else if (indexPath.row == 1) {
        placeholder = @"您的电话";
        title = @"电话";
        cell.textField.text = _mobilePhone;
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }else if (indexPath.row == 2){
        placeholder = @"喜欢的风格";
        title = @"风格";
        cell.textField.text = _likeStyleKey;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 3){
        cell.textField.text = _houseArea;
        title = @"房屋面积";
        placeholder = @"房屋面积(平方米)";
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    cell.titleLabel.text = title;
    cell.textField.placeholder = placeholder;
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 2) {
        [self hideKeyboard];
        NSMutableArray *rows = [NSMutableArray array];
        NSString *key = textField.text;
        
        __block NSInteger ind = 0;
        
        NSArray *renovationStyle = [[DefaultData sharedData] renovationStyle];
        [renovationStyle enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [rows addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"k"] isEqualToString:key]) {
                ind = idx;
            }
        }];
        
        [ActionSheetStringPicker showPickerWithTitle:nil rows:rows initialSelection:ind doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            NSArray *renovationStyle = [[DefaultData sharedData] renovationStyle];
            textField.text = [[renovationStyle objectAtIndex:selectedIndex] objectForKey:@"k"];
            self.likeStyle = [[renovationStyle objectAtIndex:selectedIndex] objectForKey:@"v"];
            self.likeStyleKey = textField.text;
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    self.selectedTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        self.senderName = textField.text;
    }else if (textField.tag == 1){
        self.mobilePhone = textField.text;
    }else if (textField.tag == 3){
        self.houseArea = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isContainsEmoji]) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isContainsEmoji]) {
        return NO;
    }
    
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 1 && value.length > kPhoneMaxNumber) {
        return NO;
    }
    
    return YES;
}

- (void)onSubmit{
    [self hideKeyboard];
    if (![self checkLogin]) {
        return;
    }
    
    if (_senderName.length == 0) {
        [self showTip:@"姓名不能为空"];
        return;
    }
    
    if (_mobilePhone.length == 0) {
        [self showTip:@"手机号码不能为空"];
        return;
    }
    
    if (![Public validateMobile:_mobilePhone]) {
        [self showTip:@"手机号码不合法"];
        return;
    }
    
    if (_likeStyle.length == 0) {
        [self showTip:@"喜欢的风格不能为空"];
        return;
    }
    
    if (_houseArea.length == 0) {
        [self showTip:@"房屋面积不能为空"];
        return;
    }
    
    NSString *memo = _contentTextView.text;
    if (memo.length == 0) {
        [self showTip:@"私信内容不能为空"];
        return;
    }
    
    NSDictionary *param = @{@"receiverId": [NSString stringWithFormat:@"%d", _designer.userId],
                            @"senderName":_senderName,
                            @"mobilePhone":_mobilePhone,
                            @"likeStyle":_likeStyle,
                            @"houseArea": _houseArea,
                            @"memo": memo};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SEND_PRIVATE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self showTip:@"发送私信成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super back:nil];
            });
        }
    }];
}

- (void)hideKeyboard{
    [_selectedTextField resignFirstResponder];
    [_contentTextView resignFirstResponder];
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
    [_tableView addGestureRecognizer:_tapHide];
    
    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    _tableView.frame = kContentFrameWithoutNavigationBar;
    [_tableView removeGestureRecognizer:_tapHide];
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
