//
//  PrivateMessage.h
//  JuranClient
//
//  Created by Kowloon on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrivateMessage : NSObject

@property (nonatomic, assign) NSInteger letterId;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, assign) NSInteger senderId;
@property (nonatomic, copy) NSString *senderHeadUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *publishCustomTime;
@property (nonatomic, assign) NSInteger unReadNum;
@property (nonatomic, assign) NSInteger receiverId;
@property (nonatomic, copy) NSString *receiverHeadUrl;
@property (nonatomic, copy) NSString *senderNickName;
@property (nonatomic, copy) NSString *receiverNickName;

+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

@interface PrivateMessageDetail : NSObject

@property (nonatomic, assign) NSInteger letterId;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, assign) NSInteger fromUserId;
@property (nonatomic, copy) NSString *fromNickName;
@property (nonatomic, copy) NSString *fromHeadUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger letterContentId;
@property (nonatomic, assign) NSInteger toUserId;
@property (nonatomic, copy) NSString *toNickName;
@property (nonatomic, copy) NSString *toHeadUrl;
@property (nonatomic, copy) NSString *isRead;
@property (nonatomic, assign) NSInteger sort;
+ (NSMutableArray *)buildUpWithValue:(id)value;

@end
