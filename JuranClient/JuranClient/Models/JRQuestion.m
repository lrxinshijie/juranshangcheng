//
//  JRQuestion.m
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRQuestion.h"
#import "JRAnswer.h"

@implementation JRQuestion

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.questionId = [dict getIntValueForKey:@"questionId" defaultValue:0];
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.questionType = [dict getStringValueForKey:@"questionType" defaultValue:@""];
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.userType = [dict getIntValueForKey:@"userType" defaultValue:0];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.publishTime = [dict getStringValueForKey:@"publishTime" defaultValue:@""];
        self.answerCount = [dict getIntValueForKey:@"answerCount" defaultValue:0];
        self.viewCount = [dict getIntValueForKey:@"viewCount" defaultValue:0];
        self.status = [dict getStringValueForKey:@"status" defaultValue:@""];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRQuestion *s = [[JRQuestion alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (BOOL)isResolved{
    BOOL flag = NO;
    if ([_status isEqualToString:@"resolved"]){
        flag = YES;
    }
    return flag;
}

- (NSString*)descriptionForCell{
    
    return [NSString stringWithFormat:@"%@ | %@", _nickName.length?_nickName:_account, [self questionTypeString]];
}

- (NSString*)questionTypeString{
    NSDictionary *dic = @{@"account": @"账户管理",
                          @"design": @"设计疑惑",
                          @"decoration": @"装修前后",
                          @"goods": @"商品选购",
                          @"diy": @"DIY工具使用困境",
                          @"other": @"其他"};
    NSString *s = dic[_questionType];
    if (!(s && s.length > 0)) {
        s = @"其他";
    }
    return s;
}

- (void)buildUpDetailWithValue:(id)value{
    if (!value || ![value isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    NSDictionary *dic = (NSDictionary*)value;
    self.imageUrl = [dic getStringValueForKey:@"imageUrl" defaultValue:@""];
    self.questionContent = [dic getStringValueForKey:@"questionContent" defaultValue:@""];
    NSDictionary *adoptedAnswerDic = dic[@"adoptedAnswer"];
    self.adoptedAnswer = [[JRAnswer alloc] initWithDictionaryForDetail:adoptedAnswerDic];
    NSDictionary *otherAnswersDic = dic[@"otherAnswers"];
    self.otherAnswers = [JRAnswer buildUpDetailWithValue:otherAnswersDic];
    
}

- (void)buildUpMyQuestionDetailWithValue:(id)value{
    if (!value || ![value isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    NSDictionary *dic = (NSDictionary*)value;
    self.imageUrl = [dic getStringValueForKey:@"imageUrl" defaultValue:@""];
    self.questionContent = [dic getStringValueForKey:@"questionContent" defaultValue:@""];
    NSDictionary *otherAnswersDic = dic[@"answerList"];
    self.otherAnswers = [JRAnswer buildUpDetailWithValue:otherAnswersDic];
}



@end
