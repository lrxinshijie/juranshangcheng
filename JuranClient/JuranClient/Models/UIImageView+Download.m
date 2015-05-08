//
//  UIImageView+Download.m
//  JuranClient
//
//  Created by Kowloon on 14/12/2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "UIImageView+Download.h"
#import "UIImageView+WebCache.h"
#import "AHReach.h"

@implementation UIImageView (Download)

- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)image{
    [self setImageWithURLString:url placeholderImage:image editing:NO];
}

- (void)setImageWithURLString:(NSString *)url{
    [self setImageWithURLString:url placeholderImage:self.image];
}

- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)image editing:(BOOL)editing{
    NSInteger scale = 2;
    
    if ([[Public intelligentModeForImageQuality] boolValue]) {
        if ([AHReach reachForDefaultHost].isReachableViaWWAN) {
            scale = 1;
        }
    }else{
        if ([[DefaultData sharedData].imageQuality integerValue] == 0) {
            scale = 1;
        }
    }
    
    
    NSURL *URL = [Public imageURL:url Width:CGRectGetWidth(self.frame)*scale Height:CGRectGetHeight(self.frame)*scale Editing:editing];
    [self sd_setImageWithURL:URL placeholderImage:self.image];
}


- (void)setImageWithURLString:(NSString *)url Editing:(BOOL)editing{
    [self setImageWithURLString:url placeholderImage:nil editing:editing];
}

@end
