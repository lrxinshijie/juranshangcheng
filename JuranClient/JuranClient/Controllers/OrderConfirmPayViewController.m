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
#import "WXApi.h"

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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kNotificationNameOrderPaySuccess object:nil];
    
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
                            @"type": _isPayAli ? @"ALIPAY" : @"WXPAY"};
    [[ALEngine shareEngine] pathURL:JR_PAY_RESPONE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if (_isPayAli) {
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
                
                NSString *sign = [aliPayDto getStringValueForKey:@"sign" defaultValue:@""];
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
                                            @"sign": sign,
                                            @"sign_type": signType
                                            };
                
                NSArray *sorts = @[@"_input_charset",@"body",@"notify_url",@"out_trade_no",@"partner",@"payment_type",@"seller_id",@"service",@"subject", @"total_fee", @"sign", @"sign_type"];
                __block NSMutableString *orderString = [NSMutableString string];
                [sorts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if (orderString.length > 0) {
                        [orderString appendFormat:@"&"];
                    }
                    [orderString appendFormat:@"%@=\"%@\"", obj, orderData[obj]];
                }];
                //            __block NSMutableString *orderString = [NSMutableString string];
                NSString *appScheme = @"JuranClient";
                //            [orderData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                //                if (orderString.length > 0) {
                //                    [orderString appendFormat:@"&"];
                //                }
                //                [orderString appendFormat:@"%@=\"%@\"", key, obj];
                //            }];
                
                //            NSString *path = [[NSBundle mainBundle] pathForResource:@"rsa_private_key" ofType:@"txt"];
                //            NSString *privateKey = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                
                //            id<DataSigner> signer = CreateRSADataSigner(privateKey);
                //            NSString *sign = [signer signString:orderString];
                
                //            [orderString appendFormat:@"&sign=\"%@\"&sign_type=\"%@\"", sign, signType];
                
                ASLog(@"%@,%@",[[AlipaySDK defaultService] currentVersion],orderString);
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSInteger resultStatus = [resultDic getIntValueForKey:@"resultStatus" defaultValue:0];
                    
                    NSDictionary *tips = @{@"9000": @"支付成功",
                                           @"8000": @"订单支付成功",
                                           @"4000": @"订单支付失败",
                                           @"6001": @"用户中途取消",
                                           @"6002": @"网络连接出错"
                                           };
                    NSString *tip = [tips getStringValueForKey:[NSString stringWithFormat:@"%d", resultStatus] defaultValue:@""];
                    if (tip.length > 0) {
                        [self showTip:tip];
                    }
                    
                    if (resultStatus == 9000) {
                        //交易成功
                        [self paySuccess];
                    }
                    ASLog(@"resultDic:%@", resultDic);
                }];
            }else{
                NSDictionary *dict = data;
                
                PayReq *req = [[PayReq alloc] init];
                req.openID = [dict objectForKey:@"appid"];
                req.partnerId = [dict objectForKey:@"partnerid"];
                req.prepayId = [dict objectForKey:@"prepayid"];
                req.nonceStr = [dict objectForKey:@"noncestr"];
                req.timeStamp = [[dict objectForKey:@"timestamp"] intValue];
                req.package = [dict objectForKey:@"packageValue"];
                req.sign = [dict objectForKey:@"sign"];
                BOOL bol = [WXApi safeSendReq:req];
                if (!bol) {
                    [self showTip:@"支付失败"];
                }
            }
            
        }
    }];
}

- (void)paySuccess{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameOrderReloadData object:@(YES)];
    
    OrderListViewController *cm = (OrderListViewController *)[self.navigationController.viewControllers objectAtTheIndex:1];
    if (cm && [cm isKindOfClass:[OrderListViewController class]]) {
        [self.navigationController popToViewController:cm animated:YES];
    }
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
