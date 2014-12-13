//
//  JRAnswer.m
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRAnswer.h"

@implementation JRAnswer

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.answerId = [dict getIntValueForKey:@"answerId" defaultValue:0];
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.questionType = [dict getIntValueForKey:@"questionType" defaultValue:0];
        self.content = [dict getStringValueForKey:@"content" defaultValue:@""];
        self.commitTime = [dict getStringValueForKey:@"commitTime" defaultValue:@""];
        self.status = [dict getStringValueForKey:@"status" defaultValue:@""];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRAnswer *s = [[JRAnswer alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (NSString*)userTypeString{
    if (_userType == 1) {
        return @"消费者";
    }else if (_userType == 2){
        return @"设计师";
    }
    return @"";
}

- (BOOL)isResolved{
    BOOL flag = NO;
    if ([_status isEqualToString:@"resolved"]){
        flag = YES;
    }
    return flag;
}

- (AnswerStatus)answerStatus{
    AnswerStatus s;
    if ([_status isEqualToString:@"resolved"]){
        s = AnswerStatusResolved;
    }else if ([_status isEqualToString:@"unresolved"]){
        s = AnswerStatusUnResolved;
    }else if ([_status isEqualToString:@"waitAdopt"]){
        s = AnswerStatusWatiAdopt;
    }else if ([_status isEqualToString:@"adopted"]){
        s = AnswerStatusAdopted;
    }
    return s;
}

+ (NSMutableArray *)buildUpDetailWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRAnswer *s = [[JRAnswer alloc] initWithDictionaryForDetail:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (id)initWithDictionaryForDetail:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.answerId = [dict getIntValueForKey:@"answerId" defaultValue:0];
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.userType = [dict getIntValueForKey:@"userType" defaultValue:0];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.content = [dict getStringValueForKey:@"content" defaultValue:@""];
        
        self.imageUrl = [dict getStringValueForKey:@"imageUrl" defaultValue:@""];
        self.commitTime = [dict getStringValueForKey:@"commitTime" defaultValue:@""];
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.bestAnswerFlag = [dict getBoolValueForKey:@"bestAnswerFlag" defaultValue:NO];
    }
    
    return self;
}


@end
