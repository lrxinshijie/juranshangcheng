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
    }
    return self;
}

- (NSDictionary *)dictionaryValue{
    return @{@"imageUrl":self.imageUrl,@"frontFlag":[NSString stringWithFormat:@"%d", self.frontFlag],@"picType":self.picType,@"picRoom":self.picRoom};
}


@end
