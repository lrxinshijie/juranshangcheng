//
//  JRQuestion.h
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRQuestion : NSObject

@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger questionType;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, assign) NSInteger answerCount;
@property (nonatomic, assign) NSInteger viewCount;

//questionDetail


+ (NSMutableArray *)buildUpWithValue:(id)value;

- (BOOL)isResolved;

@end
