//
//  UIProgressView+ASCategory.m
//  BusOnline
//
//  Created by Kowloon on 13-8-9.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import "UIProgressView+ASCategory.h"
#import "NSObject+ASCategory.h"

@implementation UIProgressView (ASCategory)

- (void)setTheProgress:(float)progress animated:(BOOL)animated{
    if (SystemVersionGreaterThanOrEqualTo5) {
        [self setProgress:progress animated:animated];
    }else {
        self.progress = progress;
    }
}

@end
