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
#import "OrderPhotoViewController.h"

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
@property (nonatomic, strong) TTTAttributedLabel *payAmountLabel;

@property (nonatomic, strong) IBOutlet UIView *effectView;
@property (nonatomic, strong) IBOutlet UIImageView *effectImageView;
@property (nonatomic, strong) IBOutlet UIButton *sizeButton;
@property (nonatomic, strong) IBOutlet UIButton *effectButton;

@property (nonatomic, strong) IBOutlet UIView *actionBgView;
@property (nonatomic, strong) IBOutlet UIImageView *actionImageView;
@property (nonatomic, strong) OrderActionView *actionView;

@property (nonatomic, strong) IBOutlet UIView *designerOrderView;
@property (nonatomic, strong) IBOutlet UILabel *designerOrderLabel;
@property (nonatomic, strong) IBOutlet UILabel *designerStatusLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) IBOutlet UIView *houseAreaView;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UILabel *houseAreaLabel;
@property (nonatomic, strong) IBOutlet UILabel *designerAmountLabel;

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
    
    self.payAmountLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(72, 8, 238, 21)];
    _payAmountLabel.backgroundColor = [UIColor clearColor];
    _payAmountLabel.numberOfLines = 0;
    _payAmountLabel.font = [UIFont systemFontOfSize:14];
    _payAmountLabel.textAlignment = NSTextAlignmentRight;
    _payAmountLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    [_amountView addSubview:_payAmountLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onEffect:(UIButton *)btn{
    if ([btn isEqual:_sizeButton]) {
        //户型图
        OrderPhotoViewController *vc = [[OrderPhotoViewController alloc] init];
        vc.order = _order;
        vc.needLoadData = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else if ([btn isEqual:_effectButton]){
        //效果图
        OrderPhotoViewController *vc = [[OrderPhotoViewController alloc] init];
        vc.order = _order;
        vc.needLoadData = YES;
        vc.type = 1;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)fillCellWithOrder:(JROrder *)order{
    
    self.order = order;
    
    [self layoutFrame];
    
    NSString *pay = @"付";
    
#ifdef kJuranDesigner
    pay = @"收";
#endif
    
    [_actionView fillViewWithOrder:order];
    
    [_avtarImageView setImageWithURLString:order.headUrl];
    
    _nameLabel.text = order.decoratorName;
    _mobileLabel.text = order.decoratorMobile;
    _amountLabel.text = [NSString stringWithFormat:@"￥%@", order.amount];
    if (order.type == 0) {
        _desigOrderLabel.text = [NSString stringWithFormat:@"量房订单：%@", order.measureTid];;
        _measureOrderLabel.text = @"";
    }else{
        _desigOrderLabel.text = [NSString stringWithFormat:@"设计订单：%@", order.designTid];
        _measureOrderLabel.text = [NSString stringWithFormat:@"量房订单：%@(已转为设计订单)", order.measureTid];
    }
    _statusLabel.text = order.statusName;
    
    if (order.type == 0) {
        NSString *measurePay = [NSString stringWithFormat:@"￥%@", order.measurePayAmount];
        NSString *content = [NSString stringWithFormat:@"量房费 实%@：%@", pay, measurePay];
        
        [_payAmountLabel setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange waitPayRange = [[mutableAttributedString string] rangeOfString:measurePay  options:NSCaseInsensitiveSearch];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:waitPayRange];
            
            return mutableAttributedString;
        }];
    }else{
        NSString *payAmount = [NSString stringWithFormat:@"已%@：￥%@",pay, order.payAmount];
        NSString *unPaidAmount = [NSString stringWithFormat:@"未%@：￥%@",pay, order.unPaidAmount];
        NSString *waitPayAmount = [NSString stringWithFormat:@"￥%@", order.waitPayAmount];
        
        NSString *content = [NSString stringWithFormat:@"%@   %@\n实%@：%@", payAmount, unPaidAmount, pay, waitPayAmount];
        
        [_payAmountLabel setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange payRange = [[mutableAttributedString string] rangeOfString:payAmount  options:NSCaseInsensitiveSearch];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[RGBColor(120, 120, 120) CGColor] range:payRange];
            UIFont *payFont = [UIFont systemFontOfSize:13];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)payFont.fontName, payFont.pointSize, NULL);
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:payRange];
            
            NSRange unPaidRange = [[mutableAttributedString string] rangeOfString:unPaidAmount  options:NSCaseInsensitiveSearch];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:unPaidRange];
            CFRelease(font);
            
            NSRange waitPayRange = [[mutableAttributedString string] rangeOfString:waitPayAmount  options:NSBackwardsSearch];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:waitPayRange];
            
            return mutableAttributedString;
        }];
    }
    
#ifdef kJuranDesigner
    _amountLabel.text = @"";
    _designerAmountLabel.text = [NSString stringWithFormat:@"￥%d", order.amount];
    _designerStatusLabel.text = _order.statusName;
    CGRect frame = _designerStatusLabel.frame;
    frame.size.width = [_order.statusName widthWithFont:_designerStatusLabel.font constrainedToHeight:CGRectGetHeight(frame)];
    _designerStatusLabel.frame = frame;
    
    frame = _designerOrderLabel.frame;
    frame.origin.x = CGRectGetMaxX(_designerStatusLabel.frame) + 5;
    _designerOrderLabel.frame = frame;
    
    _designerOrderLabel.text = _order.type == 0 ? _order.measureTid : _order.designTid;
    _addressLabel.text = _order.addressInfo;
    _houseAreaLabel.text = [NSString stringWithFormat:@"面积：%@m²", _order.houseArea];
    _timeLabel.text = _order.gmtCreate;
    
    [_avtarImageView setImageWithURLString:order.headUrl];
    _nameLabel.text = order.customerName;
    _mobileLabel.text = order.customerMobile;
#endif
}

- (void)layoutFrame{
    if (_order.type == 0) {
        _effectButton.hidden = YES;
        _sizeButton.hidden = NO;
        
        CGRect frame = _sizeButton.frame;
        frame.origin.x = 240;
        _sizeButton.frame = frame;
    }else{
        _effectButton.hidden = NO;
        _sizeButton.hidden = NO;
        
        CGRect frame = _sizeButton.frame;
        frame.origin.x = 157;
        _sizeButton.frame = frame;
    }
#ifdef kJuranDesigner
    [_designerOrderView removeFromSuperview];
    [_authorView removeFromSuperview];
    [_amountView removeFromSuperview];
    [_effectView removeFromSuperview];
    [_actionBgView removeFromSuperview];
    [_houseAreaView removeFromSuperview];
    
    CGRect frame = _designerOrderView.frame;
    frame.origin.y = 10;
    _designerOrderView.frame = frame;
    [self addSubview:_designerOrderView];
    
    frame = _authorView.frame;
    frame.origin.y = CGRectGetMaxY(_designerOrderView.frame);
    _authorView.frame = frame;
    [self addSubview:_authorView];
    
    frame = _houseAreaView.frame;
    frame.origin.y = CGRectGetMaxY(_authorView.frame);
    _houseAreaView.frame = frame;
    [self addSubview:_houseAreaView];
    
    if (_order.type == 0) {
        
        frame = _amountView.frame;
        frame.origin.y = CGRectGetMaxY(_houseAreaView.frame);
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
        
        if ([_order.status isEqualToString:@"wait_designer_confirm"] || [_order.status isEqualToString:@"wait_designer_measure"]) {
            frame = _actionBgView.frame;
            frame.origin.y = y;
            _actionBgView.frame = frame;
            [self addSubview:_actionBgView];
        }
        
    }else{
        frame = _amountView.frame;
        frame.origin.y = CGRectGetMaxY(_houseAreaView.frame);
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
        
        if ([_order.status isEqualToString:@"wait_first_pay"] || [_order.status isEqualToString:@"wait_last_pay"]) {
            frame = _actionBgView.frame;
            frame.origin.y = CGRectGetMaxY(_effectView.frame);
            _actionBgView.frame = frame;
            [self addSubview:_actionBgView];
        }
    }
#else
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
#endif
}

- (void)clickOrderAction:(OrderActionView *)view Action:(OrderAction)action{
    
}

+ (CGFloat)cellHeight:(JROrder *)order{
    CGFloat height = 20;
#ifdef kJuranDesigner
    if (order.type == 0) {
        height += (37+70+55+37);
        if ([order.status isEqualToString:@"wait_designer_measure"] || [order.status isEqualToString:@"complete"]) {
            height += 37;
        }
        
        if ([order.status isEqualToString:@"wait_designer_confirm"] || [order.status isEqualToString:@"wait_designer_measure"]) {
            height += 37;
        }
    }else{
        height += (37+70+55+55+37);
        if ([order.status isEqualToString:@"wait_first_pay"] || [order.status isEqualToString:@"wait_last_pay"]) {
            height += 37;
        }
    }
#else
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
#endif
    
    
    return height;
}

@end
