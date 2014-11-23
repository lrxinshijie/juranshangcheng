//
//  UIImageView+ASCategory.m
//  PhoneOnline
//
//  Created by Kowloon on 12-10-12.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "UIImageView+ASCategory.h"

@implementation UIImageView (ASCategory)

- (CGFloat)constrainedToWidth:(CGFloat)width originalWidth:(CGFloat)originalWidth originalHeight:(CGFloat)originalHeight
{
    CGFloat height = originalHeight;
    
    if (originalWidth > 0 && originalHeight > 0) {
        
        CGFloat factor = width / originalWidth;
        height *= factor;
        
        CGRect rect = self.frame;
        rect.size.height = height;
        self.frame = rect;
        
        //self.center = CGPointMake(self.superview.bounds.size.width * .5, self.superview.bounds.size.height * .5);
    } else {
        height = width;
    }
    
    return height;
}

- (CGFloat)constrainedToHeight:(CGFloat)height originalWidth:(CGFloat)originalWidth originalHeight:(CGFloat)originalHeight
{
    CGFloat width = originalWidth;
    
    if (originalWidth > 0 && originalHeight > 0) {
        
        CGFloat factor = height / originalHeight;
        width *= factor;
        
        CGRect rect = self.frame;
        rect.size.width = width;
        self.frame = rect;
        
        //self.center = CGPointMake(self.superview.bounds.size.width * .5, self.superview.bounds.size.height * .5);
    } else {
        width = height;
    }
    
    return width;
}

@end
