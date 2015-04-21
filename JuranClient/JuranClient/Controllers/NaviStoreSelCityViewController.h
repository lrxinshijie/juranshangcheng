//
//  NaviStoreSelCityViewController.h
//  JuranClient
//
//  Created by 彭川 on 15/4/21.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
@class JRAreaInfo;
typedef void (^AddressSelected)(JRAreaInfo *areaInfo);
@interface NaviStoreSelCityViewController : ALViewController

@property (nonatomic, copy) AddressSelected block;

- (void)setFinishBlock:(AddressSelected)finished;

@end
