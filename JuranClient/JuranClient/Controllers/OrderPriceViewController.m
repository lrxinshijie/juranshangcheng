//
//  OrderPriceViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/2/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderPriceViewController.h"
#import "JROrder.h"
#import "UIAlertView+Blocks.h"

@interface OrderPriceViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *amountTextField;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *orderLabel;

- (IBAction)onSubmit:(id)sender;

@end

@implementation OrderPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"修改价格";
    
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
    
    [UIAlertView showWithTitle:nil message:@"请确认量房费用，确认后无法修改" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (alertView.cancelButtonIndex == buttonIndex) {
            return ;
        }
        
        NSDictionary *param = @{@"measurePayAmount": [NSString stringWithFormat:@"%@", amount],
                                @"id": [NSString stringWithFormat:@"%d", _order.key],
                                @"serviceDate": _order.serviceDate};
        [self showHUD];
        [[ALEngine shareEngine] pathURL:JR_DESIGNER_CONFIRM_ORDER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
            [self hideHUD];
            if (!error) {
                if (_order.amount == 0) {
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
