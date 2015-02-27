//
//  OrderActionView.m
//  JuranClient
//
//  Created by Kowloon on 15/2/8.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderActionView.h"
#import "JROrder.h"
#import "OrderPayViewController.h"
#import "OrderConfirmPayViewController.h"
#import "OrderPriceViewController.h"
#import "OrderExtractViewController.h"
#import "UIAlertView+Blocks.h"
#import "OrderCommentViewController.h"
#import "OrderCommentReadViewController.h"
#import "ContractViewController.h"
#import "UIActionSheet+Blocks.h"

@interface OrderActionView ()

@property (nonatomic, strong) JROrder *order;

@end

@implementation OrderActionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)fillViewWithOrder:(JROrder *)order{
    self.order = order;
    
#ifdef kJuranDesigner
    if (_order.type == 0) {
        if ([_order.status isEqualToString:@"wait_designer_confirm"]) {
            [self addSubview:[self buttonWithAction:OrderActionConfirm]];
            [self addSubview:[self buttonWithAction:OrderActionReject]];
            [self addSubview:[self buttonWithAction:OrderActionPrice]];
        }else if ([_order.status isEqualToString:@"wait_designer_measure"]) {
            [self addSubview:[self buttonWithAction:OrderActionExtract]];
            [self addSubview:[self buttonWithAction:OrderActionDesigner]];
        }
    }else if (_order.type == 1){
        if ([_order.status isEqualToString:@"wait_first_pay"] || [_order.status isEqualToString:@"wait_last_pay"]) {
            [self addSubview:[self buttonWithAction:OrderActionExtract]];
        }
    }
#else
    if (_order.type == 0) {
        if ([_order.status isEqualToString:@"wait_designer_confirm"]) {
            [self addSubview:[self buttonWithAction:OrderActionCancel]];
        }else if ([_order.status isEqualToString:@"wait_consumer_pay"]) {
            [self addSubview:[self buttonWithAction:OrderActionCancel]];
            [self addSubview:[self buttonWithAction:OrderActionPay]];
        }
    }else if (_order.type == 1){
        if ([_order.status isEqualToString:@"wait_first_pay"] || [_order.status isEqualToString:@"wait_last_pay"]) {
            [self addSubview:[self buttonWithAction:OrderActionPay]];
        }else if ([_order.status isEqualToString:@"wait_confirm_design"]) {
            [self addSubview:[self buttonWithAction:OrderActionConfirm]];
        }else if ([_order.status isEqualToString:@"complete"]){
            [self addSubview:[self buttonWithAction:OrderActionComment]];
//            [self addSubview:[self buttonWithAction:OrderActionDecoration]];
        }
    }
#endif
    
}

- (UIButton *)buttonWithAction:(OrderAction)action{
    
    UIColor *textColor = RGBColor(57, 57, 57);
    NSString *title = @"";
    CGFloat x = 240;
    CGFloat width = 70;
    
    switch (action) {
        case OrderActionCancel:
            if (_order.type == 0 && [_order.status isEqualToString:@"wait_consumer_pay"]) {
                x = 160;
            }
            
            title = @"取消订单";
            break;
        case OrderActionPay:
            title = @"立即支付";
            textColor = RGBColor(0, 49, 159);
            break;
        case OrderActionConfirm:
            title = @"确认";
            break;
        case OrderActionComment:
            title = _order.ifCanViewCredit ? @"查看评价" : @"评价设计";
//            x = 160;
            break;
        case OrderActionReject:
            title = @"拒绝";
            x = 160;
            break;
        case OrderActionPrice:
            title = @"修改价格";
            x = 80;
            break;
        case OrderActionExtract:
            title = @"申请提取量房费";
            width = 110;
            x = 200;
            if ([_order.status isEqualToString:@"wait_designer_measure"]) {
                x = 105;
            }
            break;
        case OrderActionDesigner:
            title = @"签设计合同";
            width = 85;
            x = 225;
            break;
        case OrderActionDecoration:
            title = @"发起装修";
            break;
        default:
            break;
    }
    
    CGRect frame = CGRectMake(x, 5, width, 25);
    
    UIButton *button = [self buttonWithFrame:frame target:self action:@selector(onAction:) title:title backgroundImage:nil];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.tag = action;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2;
    button.layer.borderColor = [textColor CGColor];
    button.layer.borderWidth = 1;
    
    return button;
}

- (void)onAction:(UIButton *)button{
    if (button.tag == OrderActionCancel) {
        //消费者取消订单
        [UIActionSheet showInView:[UIApplication sharedApplication].keyWindow withTitle:@"您确定要取消订单么?" cancelButtonTitle:@"否" destructiveButtonTitle:nil otherButtonTitles:@[@"是"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == [actionSheet cancelButtonIndex]) {
                return;
            }
            
            NSDictionary *param = @{@"measureTid": _order.measureTid};
            [self.viewController showHUD];
            [[ALEngine shareEngine] pathURL:JR_CANCEL_ORDER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
                [self.viewController hideHUD];
                if (!error) {
                    _order.status = @"cancel";
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameOrderReloadData object:nil];
                }
            }];
        }];
        
    }else if (button.tag == OrderActionConfirm){
        //设计师确认订单
#ifdef kJuranDesigner
        [UIAlertView showWithTitle:nil message:@"请确认量房费用，确认后无法修改" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (alertView.cancelButtonIndex == buttonIndex) {
                return ;
            }
            
            NSDictionary *param = @{@"measurePayAmount": [NSString stringWithFormat:@"%d", _order.amount],
                                    @"id": [NSString stringWithFormat:@"%d", _order.key],
                                    @"serviceDate": _order.serviceDate};
            [self.viewController showHUD];
            [[ALEngine shareEngine] pathURL:JR_DESIGNER_CONFIRM_ORDER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self.viewController responseHandler:^(NSError *error, id data, NSDictionary *other) {
                [self.viewController hideHUD];
                if (!error) {
                    if (_order.amount == 0) {
                        _order.status = @"wait_designer_measure";
                    }else{
                        _order.status = @"wait_consumer_pay";
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameOrderReloadData object:nil];
                }
            }];
        }];
#else
        [UIActionSheet showInView:[UIApplication sharedApplication].keyWindow withTitle:@"是否确认设计交付物已达要求?" cancelButtonTitle:@"否" destructiveButtonTitle:nil otherButtonTitles:@[@"是"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == [actionSheet cancelButtonIndex]) {
                return ;
            }
            
            NSDictionary *param = @{@"designTid": _order.designTid};
            [self.viewController showHUD];
            [[ALEngine shareEngine] pathURL:JR_CONFIRM_ORDER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
                [self.viewController hideHUD];
                if (!error) {
                    _order.status = @"complete";
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameOrderReloadData object:nil];
                }
            }];
        }];
        
#endif
    }else if (button.tag == OrderActionPay){
        //消费者支付
        if (_order.type == 0) {
            OrderConfirmPayViewController *ov = [[OrderConfirmPayViewController alloc] init];
            ov.order = _order;
            [self.viewController.navigationController pushViewController:ov animated:YES];
        }else{
            OrderPayViewController *ov = [[OrderPayViewController alloc] init];
            ov.order = _order;
            [self.viewController.navigationController pushViewController:ov animated:YES];
        }
    }else if (button.tag == OrderActionPrice){
        //设计师修改价格
        OrderPriceViewController *ov = [[OrderPriceViewController alloc] init];
        ov.order = _order;
        [self.viewController.navigationController pushViewController:ov animated:YES];
    }else if (button.tag == OrderActionExtract){
        //设计师提取量房费用
        OrderExtractViewController *ov = [[OrderExtractViewController alloc] init];
        ov.order = _order;
        [self.viewController.navigationController pushViewController:ov animated:YES];
    }else if (button.tag == OrderActionComment){
        //消费者评论
        if (_order.ifCanViewCredit) {
            //查看评价
            OrderCommentReadViewController  *ov = [[OrderCommentReadViewController alloc] init];
            ov.order = _order;
            [self.viewController.navigationController pushViewController:ov animated:YES];
        }else{
            //评价
            OrderCommentViewController  *ov = [[OrderCommentViewController alloc] init];
            ov.order = _order;
            [self.viewController.navigationController pushViewController:ov animated:YES];
        }
    }else if (button.tag == OrderActionReject){
        //设计师拒绝
        NSDictionary *param = @{@"measureTid": _order.measureTid};
        [self.viewController showHUD];
        [[ALEngine shareEngine] pathURL:JR_REJECT_ORDER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
            [self.viewController hideHUD];
            if (!error) {
                _order.status = @"cancel";
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameOrderReloadData object:nil];
            }
        }];
    }else if (button.tag == OrderActionDesigner){
        //签设计合同
        ContractViewController *vc = [[ContractViewController alloc] init];
        vc.order = _order;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
    if ([_delegate respondsToSelector:@selector(clickOrderAction:Action:)]) {
        [_delegate clickOrderAction:self Action:button.tag];
    }
}

@end
