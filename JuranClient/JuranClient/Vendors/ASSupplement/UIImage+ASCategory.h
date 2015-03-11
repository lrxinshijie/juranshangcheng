//
//  UIImage+ASCategory.h
//  FollowMe
//
//  Created by Kowloon on 12-7-13.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>

@interface UIImage (ASCategory)

+ (UIImage *) imageWithColor: (UIColor *) color;

+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize;
+ (UIImage *) image: (UIImage *) image fitInSize: (CGSize) viewsize;

+ (UIImage*)blackWhite:(UIImage*)inImage;
+ (UIImage*)cartoon:(UIImage*)inImage;
+ (UIImage*)memory:(UIImage*)inImage;
+ (UIImage*)bopo:(UIImage*)inImage;
+ (UIImage*)scanLine:(UIImage*)inImage;

+ (UIImage *)rotateImage:(UIImage *)aImage;
+ (UIImage *)doImageBlacknWhite:(UIImage *)originalImage;

+ (UIImage *)imageWithContentsOfFileNamed:(NSString *)name;
+ (UIImage *)imageFromView:(UIView *)view;
+ (UIImage *)imageFromColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
