//
//  DetailAddressViewController.h
//  JuranClient
//
//  Created by song.he on 14-12-8.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRDesigner;

@interface DetailAddressViewController : ALViewController
#ifdef kJuranDesigner
@property (nonatomic, strong) JRDesigner *user;
#else
@property (nonatomic, strong) JRUser *user;
#endif

@property (nonatomic, assign) NSInteger type;

@end
