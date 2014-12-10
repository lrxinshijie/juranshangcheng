//
//  PrivateMessageDetailViewController.h
//  JuranClient
//
//  Created by Kowloon on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JSMessagesViewController.h"

@class PrivateMessage;
@interface PrivateMessageDetailViewController : JSMessagesViewController

@property (nonatomic, strong) PrivateMessage *message;

@end
