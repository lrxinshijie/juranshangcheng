//
//  JRProfileData.h
//  JuranClient
//
//  Created by song.he on 14-11-29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRProfileData : NSObject

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, assign) NSInteger hasNewBidCount;
@property (nonatomic, assign) NSInteger newPrivateLetterCount;
@property (nonatomic, assign) NSInteger newAnswerCount;
@property (nonatomic, assign) NSInteger newPushMsgCount;
@property (nonatomic, assign) BOOL isSigned;


- (id)initWithDictionary:(NSDictionary *)dict;

@end
