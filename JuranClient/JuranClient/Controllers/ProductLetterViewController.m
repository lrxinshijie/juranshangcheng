//
//  ProductLetterViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/4/20.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductLetterViewController.h"
#import "TextFieldCell.h"
#import "JRProduct.h"
#import "JRShop.h"
#import "AppDelegate.h"
#import "UserLocation.h"

@interface ProductLetterViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIButton *arrowButton;
@property (nonatomic, strong) IBOutlet ASPlaceholderTextView *contentTextView;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UIView *productView;
@property (nonatomic, assign) BOOL isPopview;

@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *mobilePhone;

@end

@implementation ProductLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"私信";
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 40, 30) target:self action:@selector(onSubmit) title:@"发送" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    if (_product) {
        [_photoImageView setImageWithURLString:_product.goodsLogo];
        _nameLabel.text = _product.goodsName;
        _priceLabel.text = ApplicationDelegate.gLocation.isSuccessLocation ? _product.priceString : @"";
        _priceLabel.textColor = kBlueColor;
    }else{
        _productView.hidden = YES;
    }
    
    
    self.senderName = @"";
    self.mobilePhone = @"";
    
    _contentTextView.backgroundColor = [UIColor whiteColor];
    _contentTextView.placeholder = @"请输入私信内容";
    _contentTextView.delegate = self;
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(237, 237, 237);
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = _headerView;
    
    self.isPopview = YES;
}

- (IBAction)onArrow:(id)sender{
    self.isPopview = !_isPopview;
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TextFieldCell";
    TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (TextFieldCell *)[nibs firstObject];
    }
    cell.textField.enabled = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *placeholder = @"";
    NSString *title = @"";
    if (indexPath.row == 0) {
        //placeholder = @"请输入姓名";
        title = @"您的姓名";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.text = _senderName;
    }else if (indexPath.row == 1) {
        //placeholder = @"请输入11位手机号";
        title = @"您的电话";
        cell.textField.text = _mobilePhone;
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    cell.titleLabel.text = title;
    cell.titleLabel.textColor = [UIColor grayColor];
    cell.textField.placeholder = placeholder;
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        self.senderName = textField.text;
    }else if (textField.tag == 1){
        self.mobilePhone = textField.text;
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
        [textView resignFirstResponder];
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
    [self.tableView endEditing:YES];
    
    if (![self checkLogin]) {
        return;
    }
    
    NSString *memo = _contentTextView.text;
    if (memo.length == 0) {
        [self showTip:@"私信内容不能为空"];
        return;
    }
    
    if (_senderName.length > 0 || _mobilePhone.length > 0) {
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
    }
    
    NSDictionary *param = @{@"receiverId": [NSString stringWithFormat:@"%d", _product?_product.shopId:_shop.shopId],
                            @"senderName":_senderName,
                            @"mobilePhone":_mobilePhone,
                            @"memo": memo};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SHOP_PRIVATE_LETTER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self showTip:@"发送私信成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super back:nil];
            });
        }
    }];
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
