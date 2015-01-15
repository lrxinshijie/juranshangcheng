//
//  JRCaseImage.m
//  JuranClient
//
//  Created by Kowloon on 15/1/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRCaseImage.h"

@implementation JRCaseImage

- (id)init{
    if (self = [super init]) {
        self.imageUrl = @"";
        self.image = nil;
        self.frontFlag = NO;
        self.picType = @"02";
        self.picRoom = @"livingroom";
        self.imageId = @"";
    }
    return self;
}

- (NSDictionary *)dictionaryValue{
    return @{@"imageUrl":self.imageUrl,@"frontFlag":[NSString stringWithFormat:@"%d", self.frontFlag],@"picType":self.picType,@"picRoom":self.picRoom};
}

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.imageId = [dict getStringValueForKey:@"imageId" defaultValue:@""];
        self.imageUrl = [dict getStringValueForKey:@"imageUrl" defaultValue:@""];
        self.frontFlag = [dict getBoolValueForKey:@"frontFlag" defaultValue:NO];
        self.picType = [dict getStringValueForKey:@"picType" defaultValue:@""];
        self.picRoom = [dict getStringValueForKey:@"picRoom" defaultValue:@""];
    }
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRCaseImage *s = [[JRCaseImage alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}


@end
