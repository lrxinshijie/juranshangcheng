//
//  WelcomeView.h
//  JuranClient
//
//  Created by HuangKai on 15-3-10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeView : UIView

+ (WelcomeView *)sharedView;
+ (void)fecthData;
- (void)show;

@end
