//
//  UIImageView+Download.h
//  JuranClient
//
//  Created by Kowloon on 14/12/2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Download)

- (void)setImageWithURLString:(NSString *)url;
- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)image;
- (void)setImageWithURLString:(NSString *)url Editing:(BOOL)editing;
- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)image editing:(BOOL)editing;
@end
