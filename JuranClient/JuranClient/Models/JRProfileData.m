//
//  JRProfileData.m
//  JuranClient
//
//  Created by song.he on 14-11-29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRProfileData.h"

@implementation JRProfileData

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
         self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
         self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.hasNewBidCount = [dict getIntValueForKey:@"hasNewBidCount" defaultValue:0];
        self.newPrivateLetterCount = [dict getIntValueForKey:@"newPrivateLetterCount" defaultValue:0];
        self.newAnswerCount = [dict getIntValueForKey:@"newAnswerCount" defaultValue:0];
        self.newPushMsgCount = [dict getIntValueForKey:@"newPushMsgCount" defaultValue:0];
        self.isSigned = [dict getBoolValueForKey:@"isSigned" defaultValue:FALSE];
    }
    
    return self;
}



@end
