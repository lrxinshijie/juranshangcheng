//
//  JRPushInfoMsg.h
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRPushInfoMsg : NSObject

@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, assign) NSInteger msgId;
@property (nonatomic, assign) NSInteger msgType;
@property (nonatomic, assign) NSInteger isUnread;
@property (nonatomic, strong) NSString *gmtMsgExpire;
@property (nonatomic, strong) NSString *msgTitle;
@property (nonatomic, strong) NSString *gmtCreate;
@property (nonatomic, strong) NSString *msgAbstract;

+ (NSMutableArray *)buildUpWithValue:(id)value;

@end
