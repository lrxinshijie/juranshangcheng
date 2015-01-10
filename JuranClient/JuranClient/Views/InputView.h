//
//  InputView.h
//  JuranClient
//
//  Created by HuangKai on 15/1/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishBlock)(id result);

@interface InputView : UIView

- (void)showWithTitle:(NSString*)title placeHolder:(NSString*)place content:(NSString*)content block:(FinishBlock)finished;
- (void)unShow;


@end
