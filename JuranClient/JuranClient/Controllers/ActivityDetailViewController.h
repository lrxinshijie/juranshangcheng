//
//  ActivityDetailViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/1/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRActivity;
@interface ActivityDetailViewController : ALViewController

@property (nonatomic, strong) JRActivity *activity;
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *urlString;


@end
