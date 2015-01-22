//
//  JRActivity.m
//  JuranClient
//
//  Created by HuangKai on 15/1/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRActivity.h"

@implementation JRActivity

- (id)init{
    self = [super init];
    if (self) {
        self.activityIntro = @"";
        self.activityName = @"";
        self.activityListUrl = @"";
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        [self buildupGeneralWithValue:dict];
    }
    
    return self;
}

- (void)buildupGeneralWithValue:(NSDictionary*)dict{
    self.activityId = [dict getIntValueForKey:@"id" defaultValue:0];
    self.activityIntro = [dict getStringValueForKey:@"activityIntro" defaultValue:@""];
    self.activityName = [dict getStringValueForKey:@"activityName" defaultValue:@""];
    self.activityListUrl = [dict getStringValueForKey:@"activityListUrl" defaultValue:@""];
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRActivity *a = [[JRActivity alloc] initWithDictionary:item];
            [retVal addObject:a];
        }
    }
    return retVal;
}


- (void)buildUpWithValueForDetail:(id)dict{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    self.activityName = [dict getStringValueForKey:@"activityName" defaultValue:@""];
    self.activityContent = [dict getStringValueForKey:@"activityContent" defaultValue:@""];
    self.activityContentUrl = [dict getStringValueForKey:@"activityContentUrl" defaultValue:@""];
}

- (NSString*)shareImagePath{
    if (_activityListUrl.length == 0) {
        return nil;
    }else{
        return [Public imageURLString:_activityListUrl];
    }
}

@end
