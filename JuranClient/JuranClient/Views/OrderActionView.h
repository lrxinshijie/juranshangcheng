//
//  OrderActionView.h
//  JuranClient
//
//  Created by Kowloon on 15/2/8.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    OrderActionCancel = 1001,
    OrderActionPay = 1002,
    OrderActionConfirm = 1003,
    OrderActionComment = 1004,
    OrderActionReject = 1005,
    OrderActionPrice = 1006,
    OrderActionExtract = 1007,
    OrderActionDesigner = 1008,
    OrderActionDecoration = 1009,
} OrderAction;

@class JROrder;
@class OrderActionView;
@protocol OrderActionViewDelegate <NSObject>

- (void)clickOrderAction:(OrderActionView *)view Action:(OrderAction)action;

@end

@interface OrderActionView : UIView

@property (nonatomic, assign) id<OrderActionViewDelegate> delegate;

- (void)fillViewWithOrder:(JROrder *)order;

@end
