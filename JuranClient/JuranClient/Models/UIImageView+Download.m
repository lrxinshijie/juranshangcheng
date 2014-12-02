//
//  UIImageView+Download.m
//  JuranClient
//
//  Created by Kowloon on 14/12/2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "UIImageView+Download.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Download)

- (void)setImageWithURLString:(NSString *)url{
    NSURL *URL = [Public imageURL:url Width:CGRectGetWidth(self.frame)*2 Height:CGRectGetHeight(self.frame)*2];
    [self setImageWithURL:URL placeholderImage:self.image];
}


@end
