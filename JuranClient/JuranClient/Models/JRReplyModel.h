//
//  JRReplyModel.h
//  JuranClient
//
//  Created by 123 on 15/11/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRReplyModel : NSObject
@property (nonatomic, assign) NSInteger replyId;//回复的点评id
@property (nonatomic, assign) NSInteger rid;//回复的id
@property (nonatomic, copy) NSString *userNickname;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *replyNickname; //回复的用户昵称
@property (nonatomic, copy) NSString *gmtCreate; //回复的时间

@property (nonatomic, copy) NSString *content;
- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray *)buildUpWithValue:(id)value;

@end
