//
//  JRDesigner.m
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRDesigner.h"
#import "JRCase.h"

@implementation JRDesigner

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }

        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.isRealNameAuth = [dict getIntValueForKey:@"isRealNameAuth" defaultValue:0];
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.levelCode = [dict getStringValueForKey:@"levelCode" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.userName = [dict getStringValueForKey:@"userName" defaultValue:@""];
        self.styleNames = [dict getStringValueForKey:@"styleNames" defaultValue:@""];
        self.styleCodes = [dict getStringValueForKey:@"styleCodes" defaultValue:@""];
        self.selfIntroduction = [dict getStringValueForKey:@"selfIntroduction" defaultValue:@""];
        self.projectCount = [dict getIntValueForKey:@"projectCount" defaultValue:0];
        self.fansCount = [dict getIntValueForKey:@"fansCount" defaultValue:0];
        self.creditRateCount = [dict getIntValueForKey:@"creditRateCount" defaultValue:0];
        self.minisite = [dict getStringValueForKey:@"minisite" defaultValue:@""];
        
        self.projectDtoList = [JRCase buildUpWithValue:dict[@"projectDtoList"]];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRDesigner *d = [[JRDesigner alloc] initWithDictionary:item];
            [retVal addObject:d];
        }
    }
    return retVal;
}

- (NSURL *)imageURL{
    return [NSURL URLWithString:self.headUrl relativeToURL:[NSURL URLWithString:JR_IMAGE_SERVICE]];
}

- (NSString*)styleNamesForDesignerList{
    NSArray *arr = [self.styleNames componentsSeparatedByString:@","];
    NSString* styleNames = @"";
    for (NSInteger i = 0; arr.count; i++) {
        styleNames = [styleNames stringByAppendingString:arr[i]];
        if (i == arr.count - 1) {
            break;
        }
        styleNames = [styleNames stringByAppendingString:@"｜"];
    }
    return styleNames;
}

@end
