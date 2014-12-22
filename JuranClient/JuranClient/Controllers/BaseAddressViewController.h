//
//  BaseAddressViewController.h
//  JuranClient
//
//  Created by song.he on 14-12-7.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRAreaInfo;

typedef void (^AddressSelected)(JRAreaInfo *areaInfo);

@interface BaseAddressViewController : ALViewController

@property (nonatomic, copy) AddressSelected block;

- (void)setFinishBlock:(AddressSelected)finished;

@end
