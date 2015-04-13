//
//  InputCodeViewController.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
#import "QRCodeViewController.h"

@protocol InputCodeViewControllerDelegate <NSObject>

//确认按钮触发的回调，参数为输入的信息
- (void)confirmButtonDidClick:(NSString *)message;

@end

@interface InputCodeViewController : ALViewController

@property (assign, nonatomic) id<InputCodeViewControllerDelegate>delegate;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil QRVC:(QRCodeViewController *)vc;
- (void)configBackgroundLayer;
- (void)removeBackgroundLayer;

@end
