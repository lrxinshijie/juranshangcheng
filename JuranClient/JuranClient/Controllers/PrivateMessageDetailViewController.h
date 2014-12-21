//
//  PrivateMessageDetailViewController.h
//  JuranClient
//
//  Created by Kowloon on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class PrivateMessage;
@interface PrivateMessageDetailViewController : ALViewController;

@property (nonatomic, strong) PrivateMessage *message;

@end
