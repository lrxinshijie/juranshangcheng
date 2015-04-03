//
//  OrderPriceViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/2/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderPriceViewController.h"
#import "JROrder.h"
#import "UIActionSheet+Blocks.h"

@interface OrderPriceViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *amountTextField;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *orderLabel;
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;

- (IBAction)onSubmit:(id)sender;

@end

@implementation OrderPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"确认量房";
    
    [_submitButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 2;
    _submitButton.layer.borderColor = [kBlueColor CGColor];
    _submitButton.layer.borderWidth = 1;
    
    _bgImageView.layer.borderColor = [RGBColor(216, 216, 216) CGColor];
    _bgImageView.layer.borderWidth = 1;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.layer.cornerRadius = 2;
    
    _amountTextField.text = [NSString stringWithFormat:@"%@", _order.amount];
    _dateLabel.text = [NSString stringWithFormat:@"期望量房时间：%@", _order.serviceDateString];
    _orderLabel.text = [NSString stringWithFormat:@"量房订单：%@", _order.measureTid];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)onSubmit:(id)sender{
    NSString *amount = _amountTextField.text;
    
    [UIActionSheet showInView:[UIApplication sharedApplication].keyWindow withTitle:@"量房地址、金额确定后将无法修改" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确认"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        
        if (actionSheet.cancelButtonIndex == buttonIndex) {
            return ;
        }
        
        NSDictionary *param = @{@"measurePayAmount": [NSString stringWithFormat:@"%@", amount],
                                @"id": [NSString stringWithFormat:@"%d", _order.key],
                                @"serviceDate": _order.serviceDate};
        [self showHUD];
        [[ALEngine shareEngine] pathURL:JR_DESIGNER_CONFIRM_ORDER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
            [self hideHUD];
            if (!error) {
                if ([_order.amount doubleValue] == 0) {
                    _order.status = @"wait_designer_measure";
                }else{
                    _order.status = @"wait_consumer_pay";
                }
                _order.amount = amount;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameOrderReloadData object:@""];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
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