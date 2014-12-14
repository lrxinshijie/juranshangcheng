//
//  AskDetailViewController.h
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRQuestion;

@interface AskDetailViewController : ALViewController

@property (nonatomic, assign) BOOL isMyQuestion;
@property (nonatomic, strong) JRQuestion *question;

@end
