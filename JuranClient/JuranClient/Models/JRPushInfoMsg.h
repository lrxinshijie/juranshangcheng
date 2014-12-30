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

//Detail
@property (nonatomic, strong) NSString *msgImgUrl;
@property (nonatomic, strong) NSString *msgContent;
@property (nonatomic, strong) NSString *msgLinkTitle;
@property (nonatomic, strong) NSString *msgLinkUrl;
@property (nonatomic, assign) NSInteger msgUrlType;
@property (nonatomic, strong) NSString *msgUrl;

+ (NSMutableArray *)buildUpWithValue:(id)value;
- (void)buildUpDetailWithValue:(id)value;

@end
