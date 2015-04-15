//
//  QuestionDetailViewController.h
//  JuranClient
//
//  Created by song.he on 14-12-11.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"
@class JRQuestion;

@interface QuestionDetailViewController : ALViewController

@property (nonatomic, assign) BOOL isResolved;
@property (nonatomic, strong) JRQuestion *question;

@end
