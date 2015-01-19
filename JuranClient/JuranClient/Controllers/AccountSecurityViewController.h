//
//  AccountSecurityViewController.h
//  JuranClient
//
//  Created by song.he on 14-11-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

#ifdef kJuranDesigner
@class JRDesigner;
#endif

@interface AccountSecurityViewController : ALViewController

#ifdef kJuranDesigner
@property (nonatomic, strong) JRDesigner *user;
#else
@property (nonatomic, strong) JRUser *user;
#endif

@end
