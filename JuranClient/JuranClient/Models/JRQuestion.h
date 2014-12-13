//
//  JRQuestion.h
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JRAnswer;

@interface JRQuestion : NSObject

@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *questionType;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, assign) NSInteger answerCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, strong) NSString *status;

//questionDetail
@property (nonatomic, strong) JRAnswer *adoptedAnswer;
@property (nonatomic, strong) NSMutableArray *otherAnswers;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *questionContent;

+ (NSMutableArray *)buildUpWithValue:(id)value;

- (BOOL)isResolved;
- (NSString*)descriptionForCell;

- (void)buildUpDetailWithValue:(id)value;
- (void)buildUpMyQuestionDetailWithValue:(id)value;

@end
