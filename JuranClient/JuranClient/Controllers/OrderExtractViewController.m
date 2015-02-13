//
//  OrderExtractViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/2/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderExtractViewController.h"
#import "JROrder.h"

@interface OrderExtractViewController () <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *orderLabel;
@property (nonatomic, strong) IBOutlet UILabel *amountLabel;
@property (nonatomic, strong) IBOutlet UILabel *payAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel *noteLabel;
@property (nonatomic, strong) IBOutlet ASPlaceholderTextView *textView;
@property (nonatomic, assign) NSInteger applyAmount;

- (IBAction)onSubmit:(id)sender;

@end

@implementation OrderExtractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"申请提取量房费用";
    
    _textView.backgroundColor = [UIColor clearColor];
    _textView.placeholder = @"请输入120字以内的提取理由";
    _textView.layer.borderColor = [[UIColor blackColor] CGColor];
    _textView.layer.borderWidth = 1;
    _orderLabel.text = [NSString stringWithFormat:@"量房订单：%@", _order.measureTid];
    
    
    NSDictionary *param = @{@"tid": _order.measureTid};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_EXTRACT_AMOUNT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            self.applyAmount = [data getIntValueForKey:@"applyAmount" defaultValue:0];
            _amountLabel.text = [NSString stringWithFormat:@"￥%d", [data getIntValueForKey:@"amount" defaultValue:0]];
            _payAmountLabel.text = [NSString stringWithFormat:@"￥%d", _applyAmount];
            
            _noteLabel.text = [NSString stringWithFormat:@"温馨提示：\n提取量房费后，将无法再进行下一步签订设计合同，请确认是否提取；\n未签订设计合同就申请提取量房费，将扣除%d%%服务费；申请成功并审核通过后，经平台周期结算量词费用将转至您的帐户，届时您可进行提现操作。", (NSInteger)([data getDoubleValueForKey:@"designMeasureDrawDeduction" defaultValue:0]*100)];
        }
    }];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    NSString *key = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (key.length > 120) {
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)onSubmit:(id)sender{
    NSString *content = _textView.text;
    if (content.length == 0) {
        [self showTip:@"提取理由不能为空"];
        return;
    }
    
    if (_applyAmount == 0) {
        [self showTip:@"可提取金额为0"];
        return;
    }
    
    NSDictionary *param = @{@"tid": _order.measureTid,
                            @"applyAmount": [NSString stringWithFormat:@"%d", _applyAmount],
                            @"applyReason": content};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_EXTRACT_AMOUNT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
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
