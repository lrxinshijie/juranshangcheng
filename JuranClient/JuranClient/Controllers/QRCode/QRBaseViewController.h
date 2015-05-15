//
//  QRBaseViewController.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@interface QRBaseViewController : ALViewController

@property (nonatomic, copy) void (^enableClick)(BOOL);

//实例化请使用这个方法，最后一个参数的作用是，表示当从此页面pop会上级页面时，navigation是否隐藏。即push到这个页面的那个页面的navi是否隐藏。
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isPopNavHide:(BOOL)hide;
+ (BOOL)isRuning;
/*
 所有添加二维码的页面需要按照入下方式进行设置，目的在于避免连续点击，造成前一次的释放不完全而引发的BUG，
 其中couldClick为所在页面的一个属性，请自行定义，并初始化为YES。
if (couldClick) {
    
    QRBaseViewController * vc = [[QRBaseViewController alloc] initWithNibName:@"QRBaseViewController" bundle:nil isPopNavHide:NO];
    vc.enableClick = ^(BOOL enabled)
    {
        couldClick = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
    couldClick = NO;
}
*/

@end
