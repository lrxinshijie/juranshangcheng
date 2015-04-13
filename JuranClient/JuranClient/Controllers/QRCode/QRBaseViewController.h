//
//  QRBaseViewController.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@interface QRBaseViewController : ALViewController

//实例化请使用这个方法，最后一个参数的作用是，表示当从此页面pop会上级页面时，navigation是否隐藏。即push到这个页面的那个页面的navi是否隐藏。
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isPopNavHide:(BOOL)hide;

@end
