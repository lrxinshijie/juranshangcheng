//
//  OrderConfirmPayViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/2/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderConfirmPayViewController.h"
#import "JROrder.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "OrderListViewController.h"

@interface OrderConfirmPayViewController ()

@property (nonatomic, strong) IBOutlet UILabel *orderLabel;
@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *payAmountLabel;

@property (nonatomic, strong) IBOutlet UIButton *aliButton;
@property (nonatomic, strong) IBOutlet UIButton *wxButton;

@property (nonatomic, assign) BOOL isPayAli;

- (IBAction)onSelectPay:(UIButton *)btn;

- (IBAction)onPay:(id)sender;

@end

@implementation OrderConfirmPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"支付订单";
    
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.cornerRadius = CGRectGetWidth(_avtarImageView.frame) / 2;
    
    _orderLabel.text = [NSString stringWithFormat:@"订单号：%@", _order.designTid];
    [_avtarImageView setImageWithURLString:_order.headUrl];
    _nameLabel.text = _order.decoratorName;
    
    _payAmountLabel.text = [NSString stringWithFormat:@"￥%@", _order.waitPayAmount];
    
    self.isPayAli = YES;
}

- (IBAction)onSelectPay:(UIButton *)btn{
    if ([btn isEqual:_aliButton] && !_isPayAli) {
        self.isPayAli = YES;
    }else if ([btn isEqual:_wxButton] && _isPayAli){
        self.isPayAli = NO;
    }
}

- (void)setIsPayAli:(BOOL)isPayAli{
    _isPayAli = isPayAli;
    UIImage *image = [UIImage imageNamed:@"image_quality_unselected.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"image_quality_selected.png"];
    
    [_aliButton setImage:_isPayAli ? selectedImage : image forState:UIControlStateNormal];
    [_wxButton setImage:_isPayAli ? image : selectedImage forState:UIControlStateNormal];
}

- (IBAction)onPay:(id)sender{
    [self showHUD];
    NSDictionary *param = @{@"tid": _order.type == 0 ? _order.measureTid : _order.designTid,
                            @"status": _order.status,
                            @"type": _isPayAli ? @"ALIPAY" : @"wechat"};
    [[ALEngine shareEngine] pathURL:JR_PAY_RESPONE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSDictionary *aliPayDto = data;//[data objectForKey:@"aliPayDto"];
            NSString *totalFee = [aliPayDto getStringValueForKey:@"totalFee" defaultValue:@""];
            NSString *subject = [aliPayDto getStringValueForKey:@"subject" defaultValue:@""];
            NSString *body = [aliPayDto getStringValueForKey:@"body" defaultValue:@""];
            NSString *notifyUrl = [aliPayDto getStringValueForKey:@"notifyUrl" defaultValue:@""];
            NSString *partner = [aliPayDto getStringValueForKey:@"partner" defaultValue:@""];
            NSString *sellerEmail = [aliPayDto getStringValueForKey:@"sellerEmail" defaultValue:@""];
            NSString *outTrade_no = [aliPayDto getStringValueForKey:@"outTrade_no" defaultValue:@""];
//            NSString *returnUrl = [aliPayDto getStringValueForKey:@"returnUrl" defaultValue:@""];
            NSString *paymentType = [aliPayDto getStringValueForKey:@"paymentType" defaultValue:@""];
            NSString *service = [aliPayDto getStringValueForKey:@"service" defaultValue:@""];
            NSString *inputCharset = [aliPayDto getStringValueForKey:@"inputCharset" defaultValue:@""];
            
//            NSString *sign = [aliPayDto getStringValueForKey:@"sign" defaultValue:@""];
            NSString *signType = [aliPayDto getStringValueForKey:@"signType" defaultValue:@""];
            
            NSDictionary *orderData = @{@"partner": partner,
                                        @"seller_id": sellerEmail,
                                        @"out_trade_no": outTrade_no,
                                        @"subject": subject,
                                        @"body": body,
                                        @"total_fee": totalFee,
                                        @"notify_url": notifyUrl,
                                        @"service": service,
                                        @"payment_type": paymentType,
                                        @"_input_charset": inputCharset,
//                                        @"it_b_pay": @"30m",
//                                        @"show_url": @"m.alipay.com",
//                                        @"sign": sign,
//                                        @"sign_type": signType
                                        };
            __block NSMutableString *orderString = [NSMutableString string];
            NSString *appScheme = @"JuranClient";
            [orderData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (orderString.length > 0) {
                    [orderString appendFormat:@"&"];
                }
                [orderString appendFormat:@"%@=\"%@\"", key, obj];
            }];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"rsa_private_key" ofType:@"txt"];
            NSString *privateKey = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            
            id<DataSigner> signer = CreateRSADataSigner(privateKey);
            NSString *sign = [signer signString:orderString];
            
            [orderString appendFormat:@"&sign=\"%@\"&sign_type=\"%@\"", sign, signType];
            
            ASLog(@"%@,%@",[[AlipaySDK defaultService] currentVersion],orderString);
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSInteger resultStatus = [resultDic getIntValueForKey:@"resultStatus" defaultValue:0];
                if (resultStatus == 9000) {
                    //交易成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameOrderReloadData object:@(YES)];
                    
                    OrderListViewController *cm = (OrderListViewController *)[self.navigationController.viewControllers objectAtTheIndex:1];
                    if (cm && [cm isKindOfClass:[OrderListViewController class]]) {
                        [self.navigationController popToViewController:cm animated:YES];
                    }
                }
//                ASLog(@"resultDic:%@", resultDic);
            }];
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
