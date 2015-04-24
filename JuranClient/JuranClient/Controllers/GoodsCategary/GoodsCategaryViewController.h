//
//  GoodsCategaryViewController.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

typedef enum {
    
    CategaryStyle_Goods = 0,
    CategaryStyle_Shop
    
}CategaryStyle;

@interface GoodsCategaryViewController : ALViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isPopNavHide:(BOOL)hide style:(CategaryStyle)style;

@end
