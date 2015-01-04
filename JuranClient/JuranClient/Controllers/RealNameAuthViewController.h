//
//  RealNameAuthViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/1/1.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

typedef enum : NSUInteger {
    RealNameAuthStatusCommiting,
    RealNameAuthStatusReview,
    RealNameAuthStatusApproved
} RealNameAuthStatus;

@class JRDesigner;
@interface RealNameAuthViewController : ALViewController

@property (nonatomic, strong) JRDesigner *designer;

@end
