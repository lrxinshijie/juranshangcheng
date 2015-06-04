//
//  NaviStoreInfoViewController.h
//  JuranClient
//
//  Created by 彭川 on 15/4/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
#import "NaviStoreListViewController.h"
@class JRStore;

@interface NaviStoreInfoViewController : ALViewController
@property (strong, nonatomic) JRStore *store;
@property (nonatomic, assign) NaviType naviType;
@property (assign, nonatomic) BOOL couldGuide;
@end
