//
//  OrderCell.m
//  JuranClient
//
//  Created by Kowloon on 15/2/7.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderCell.h"
#import "JROrder.h"
#import "TTTAttributedLabel.h"
#import "OrderActionView.h"

@interface OrderCell () <OrderActionViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *orderView;
@property (nonatomic, strong) IBOutlet UIImageView *orderImageView;
@property (nonatomic, strong) IBOutlet UILabel *desigOrderLabel;
@property (nonatomic, strong) IBOutlet UILabel *measureOrderLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) IBOutlet UIView *authorView;
@property (nonatomic, strong) IBOutlet UIImageView *authorImageView;
@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *mobileLabel;
@property (nonatomic, strong) IBOutlet UILabel *amountLabel;

@property (nonatomic, strong) IBOutlet UIView *amountView;
@property (nonatomic, strong) IBOutlet UIImageView *amountImageView;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *payAmountLabel;

@property (nonatomic, strong) IBOutlet UIView *effectView;
@property (nonatomic, strong) IBOutlet UIImageView *effectImageView;

@property (nonatomic, strong) IBOutlet UIView *actionBgView;
@property (nonatomic, strong) IBOutlet UIImageView *actionImageView;
@property (nonatomic, strong) OrderActionView *actionView;

@property (nonatomic, strong) JROrder *order;

@end

@implementation OrderCell

- (void)awakeFromNib {
    // Initialization code
    
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.cornerRadius = CGRectGetWidth(_avtarImageView.frame) / 2;
    
    self.actionView = [[OrderActionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 37)];
    _actionView.delegate = self;
    [_actionBgView addSubview:_actionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithOrder:(JROrder *)order{
    
    self.order = order;
    
    [self layoutFrame];
    
    _payAmountLabel.numberOfLines = 0;
    _payAmountLabel.backgroundColor = [UIColor clearColor];
    _payAmountLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    
    [_actionView fillViewWithOrder:order];
    
    [_avtarImageView setImageWithURLString:order.headUrl];
    
    _nameLabel.text = order.decoratorName;
    _mobileLabel.text = order.decoratorMobile;
    _amountLabel.text = [NSString stringWithFormat:@"￥%d", order.amount];
    if (order.type == 0) {
        _desigOrderLabel.text = [NSString stringWithFormat:@"量房订单：%@", order.measureTid];;
        _measureOrderLabel.text = @"";
    }else{
        _desigOrderLabel.text = [NSString stringWithFormat:@"设计订单：%@", order.designTid];
        _measureOrderLabel.text = [NSString stringWithFormat:@"量房订单：%@(已转为设计订单)", order.measureTid];
    }
    _statusLabel.text = order.statusName;
    
    if (order.type == 0) {
        NSString *measurePay = [NSString stringWithFormat:@"￥%d", order.measurePayAmount];
        NSString *content = [NSString stringWithFormat:@"量房费 实付：%@", measurePay];
        
        [_payAmountLabel setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange waitPayRange = [[mutableAttributedString string] rangeOfString:measurePay  options:NSCaseInsensitiveSearch];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:waitPayRange];
            
            return mutableAttributedString;
        }];
    }else{
        NSString *payAmount = [NSString stringWithFormat:@"已付：￥%d", order.payAmount];
        NSString *unPaidAmount = [NSString stringWithFormat:@"未付：￥%d", order.unPaidAmount];
        NSString *waitPayAmount = [NSString stringWithFormat:@"￥%d", order.waitPayAmount];
        
        NSString *content = [NSString stringWithFormat:@"%@   %@\n实付：%@", payAmount, unPaidAmount, waitPayAmount];
        
        [_payAmountLabel setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange payRange = [[mutableAttributedString string] rangeOfString:payAmount  options:NSCaseInsensitiveSearch];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[RGBColor(120, 120, 120) CGColor] range:payRange];
            UIFont *payFont = [UIFont systemFontOfSize:11];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)payFont.fontName, payFont.pointSize, NULL);
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:payRange];
            CFRelease(font);
            
            NSRange unPaidRange = [[mutableAttributedString string] rangeOfString:unPaidAmount  options:NSCaseInsensitiveSearch];
            payFont = [UIFont systemFontOfSize:13];
            font = CTFontCreateWithName((__bridge CFStringRef)payFont.fontName, payFont.pointSize, NULL);
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:unPaidRange];
            CFRelease(font);
            
            NSRange waitPayRange = [[mutableAttributedString string] rangeOfString:waitPayAmount  options:NSCaseInsensitiveSearch];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:waitPayRange];
            
            return mutableAttributedString;
        }];
    }
}

- (void)layoutFrame{
    [_orderView removeFromSuperview];
    [_authorView removeFromSuperview];
    [_amountView removeFromSuperview];
    [_effectView removeFromSuperview];
    [_actionBgView removeFromSuperview];
    
    CGRect frame = _orderView.frame;
    frame.origin.y = 10;
    if (_order.type == 0) {
        frame.size.height = 37;
        _orderView.frame = frame;
        
        frame = _orderImageView.frame;
        frame.origin.y = CGRectGetHeight(_orderView.frame)-1;
        _orderImageView.frame = frame;
        [self addSubview:_orderView];
        
        frame = _authorView.frame;
        frame.origin.y = CGRectGetMaxY(_orderView.frame);
        _authorView.frame = frame;
        [self addSubview:_authorView];
        
        frame = _amountView.frame;
        frame.origin.y = CGRectGetMaxY(_authorView.frame);
        frame.size.height = 37;
        _amountView.frame = frame;
        [self addSubview:_amountView];
        
        frame = _payAmountLabel.frame;
        frame.origin.y = 0;
        frame.size.height = CGRectGetHeight(_amountView.frame);
        _payAmountLabel.frame = frame;
        frame = _amountImageView.frame;
        frame.origin.y = CGRectGetHeight(_amountView.frame)-1;
        _amountImageView.frame = frame;
        
        
        CGFloat y = CGRectGetMaxY(_amountView.frame);
        if ([_order.status isEqualToString:@"wait_designer_measure"] || [_order.status isEqualToString:@"complete"]) {
            frame = _effectView.frame;
            frame.origin.y = CGRectGetMaxY(_amountView.frame);
            _effectView.frame = frame;
            [self addSubview:_effectView];
            
            y = CGRectGetMaxY(frame);
        }
        
        if ([_order.status isEqualToString:@"wait_designer_confirm"] || [_order.status isEqualToString:@"wait_consumer_pay"]) {
            frame = _actionBgView.frame;
            frame.origin.y = y;
            _actionBgView.frame = frame;
            [self addSubview:_actionBgView];
        }
    }else{
        frame.size.height = 55;
        _orderView.frame = frame;
        
        frame = _orderImageView.frame;
        frame.origin.y = CGRectGetHeight(_orderView.frame)-1;
        _orderImageView.frame = frame;
        [self addSubview:_orderView];
        
        
        frame = _authorView.frame;
        frame.origin.y = CGRectGetMaxY(_orderView.frame);
        _authorView.frame = frame;
        [self addSubview:_authorView];
        
        
        frame = _amountView.frame;
        frame.origin.y = CGRectGetMaxY(_authorView.frame);
        frame.size.height = 55;
        _amountView.frame = frame;
        
        frame = _payAmountLabel.frame;
        frame.origin.y = 0;
        frame.size.height = CGRectGetHeight(_amountView.frame);
        _payAmountLabel.frame = frame;
        
        frame = _amountImageView.frame;
        frame.origin.y = CGRectGetHeight(_amountView.frame)-1;
        _amountImageView.frame = frame;
        
        [self addSubview:_amountView];
        
        
        frame = _effectView.frame;
        frame.origin.y = CGRectGetMaxY(_amountView.frame);
        _effectView.frame = frame;
        [self addSubview:_effectView];
        
        
        frame = _actionBgView.frame;
        frame.origin.y = CGRectGetMaxY(_effectView.frame);
        _actionBgView.frame = frame;
        [self addSubview:_actionBgView];
    }
}

- (void)clickOrderAction:(OrderActionView *)view Action:(OrderAction)action{
    
}

+ (CGFloat)cellHeight:(JROrder *)order{
    CGFloat height = 20;
    if (order.type == 0) {
        height += (37+70+37);
        if ([order.status isEqualToString:@"wait_designer_measure"] || [order.status isEqualToString:@"complete"]) {
            height += 37;
        }
        
        if ([order.status isEqualToString:@"wait_designer_confirm"] || [order.status isEqualToString:@"wait_consumer_pay"]) {
            height += 37;
        }
    }else{
        height += (55+70+55+37+37);
    }
    
    return height;
}

@end
