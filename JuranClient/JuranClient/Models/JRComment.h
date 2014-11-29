//
//  JRComment.h
//  JuranClient
//
//  Created by 李 久龙 on 14/11/29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRComment : NSObject

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *commentContent;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, copy) NSString *commentTime;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, strong) NSArray *replyList;

//Reply
@property (nonatomic, copy) NSString *replyContent;
@property (nonatomic, copy) NSString *replyTime;
@property (nonatomic, assign) NSInteger replyId;

+ (NSMutableArray *)buildUpWithValue:(id)value;;

@end
