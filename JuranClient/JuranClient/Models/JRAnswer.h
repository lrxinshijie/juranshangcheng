//
//  JRAnswer.h
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AnswerStatusUnResolved,
    AnswerStatusResolved,
    AnswerStatusWatiAdopt,
    AnswerStatusAdopted
} AnswerStatus;

@interface JRAnswer : NSObject

@property (nonatomic, assign) NSInteger answerId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger questionType;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *commitTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *questionId;

//
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *headUrl;

@property (nonatomic, assign) BOOL bestAnswerFlag;

+ (NSMutableArray *)buildUpWithValue:(id)value;
- (BOOL)isResolved;
- (AnswerStatus)answerStatus;
- (NSString*)userTypeString;
//
+ (NSMutableArray *)buildUpDetailWithValue:(id)value;
- (id)initWithDictionaryForDetail:(NSDictionary *)dict;

@end
