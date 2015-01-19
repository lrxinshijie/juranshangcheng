//
//  BindPhoneNumberViewController.h
//  JuranClient
//
//  Created by song.he on 14-12-8.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

#ifdef kJuranDesigner
@class JRDesigner;
#endif

@interface BindPhoneNumberViewController : ALViewController

#ifdef kJuranDesigner
@property (nonatomic, strong) JRDesigner *user;
#else
@property (nonatomic, strong) JRUser *user;
#endif

@end
