//
//  DemandEditTextViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DemandEditTextViewController.h"
#import "JRDemand.h"

@interface DemandEditTextViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *valueTextField;

@end

@implementation DemandEditTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSave) title:@"保存" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.title = @"编辑需求";
    self.view.backgroundColor = RGBColor(237, 237, 237);
    NSString *placeholder = @"";
    NSString *value = @"";
    UIKeyboardType keyboardType = UIKeyboardTypeDefault;
    switch (_editType) {
        case DemandEditContactsName:
            placeholder = @"请填写您的姓名";
            value = _demand.contactsName;
            keyboardType = UIKeyboardTypeDefault;
            break;
        case DemandEditContactsMobile:
            placeholder = @"必须是11位数字";
            value = _demand.contactsMobile;
            keyboardType = UIKeyboardTypeNumberPad;
            break;
        case DemandEditNeighbourhoods:
            placeholder = @"请填写您的小区名称";
            value = _demand.neighbourhoods;
            keyboardType = UIKeyboardTypeDefault;
            break;
        case DemandEditBudget:
            placeholder = @"装修预算(万元)";
            value = _demand.budget;
            keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case DemandEditHouseArea:
            placeholder = @"房屋面积(平方米)";
            value = [NSString stringWithFormat:@"%.2f", _demand.houseArea];
            keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            placeholder = @"";
            value = @"";
            keyboardType = UIKeyboardTypeDefault;
            break;
    }
    
    _valueTextField.placeholder = placeholder;
    _valueTextField.text = value;
    _valueTextField.keyboardType = keyboardType;
    [_valueTextField becomeFirstResponder];
}

- (void)onSave{
    NSString *text = [_valueTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    switch (_editType) {
        case DemandEditContactsName:
            _demand.contactsName = text;
            break;
        case DemandEditContactsMobile:
            if (![Public validateMobile:text]) {
                [self showTip:@"手机号码不合法"];
                return;
            }
            _demand.contactsMobile = text;
            break;
        case DemandEditHouseArea:
            _demand.houseArea = [text integerValue];
            break;
        case DemandEditBudget:
            _demand.budget = text;
            break;
        case DemandEditNeighbourhoods:
            _demand.neighbourhoods = text;
            break;
        default:
            break;
    }
    
    [super back:nil];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isContainsEmoji]) {
        return NO;
    }
    
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_editType == DemandEditContactsMobile && value.length > kPhoneMaxNumber) {
        return NO;
    }else if (_editType == DemandEditContactsMobile && value.length > 32){
        return NO;
    }else if (_editType == DemandEditBudget){
        double budget = [value doubleValue];
        if (budget > 99999) {
            return NO;
        }
    }
    
    return YES;
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
