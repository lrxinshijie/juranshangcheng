//
//  OrderActionView.m
//  JuranClient
//
//  Created by Kowloon on 15/2/8.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderActionView.h"
#import "JROrder.h"

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
            [self addSubview:[self buttonWithAction:OrderActionDecoration]];
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
            title = @"评价设计";
            x = 160;
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
    if ([_delegate respondsToSelector:@selector(clickOrderAction:Action:)]) {
        [_delegate clickOrderAction:self Action:button.tag];
    }
}

@end
