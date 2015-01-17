//
//  JRWiki.m
//  JuranClient
//
//  Created by HuangKai on 15/1/17.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRWiki.h"

@implementation JRWiki


- (id)init{
    self = [super init];
    if (self) {
        self.imageUrl = @"";
        self.title = @"";
        self.summary = @"";
        self.keyWords = @"";
        self.content = @"";
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
    self.wikiId = [dict getIntValueForKey:@"id" defaultValue:0];
    self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
    self.imageUrl = [dict getStringValueForKey:@"imageUrl" defaultValue:@""];
    self.browseCount = [dict getIntValueForKey:@"browseCount" defaultValue:0];
    self.hasVideo = [dict getBoolValueForKey:@"hasVideo" defaultValue:NO];
    self.summary = [dict getStringValueForKey:@"summary" defaultValue:@""];
    self.keyWords = [dict getStringValueForKey:@"keyWords" defaultValue:@""];
    self.content = [dict getStringValueForKey:@"content" defaultValue:@""];
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRWiki *s = [[JRWiki alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}


@end
