//
//  ALTheme.m
//  JuranClient
//
//  Created by Kowloon on 15/1/7.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALTheme.h"

@implementation ALTheme

+ (ALTheme *)sharedTheme{
    static ALTheme *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (UIColor *)navigationColor{
#ifdef kJuranDesigner
    return [UIColor blackColor];
#endif
    
    return [UIColor whiteColor];
}

- (UIColor *)navigationTitleColor{
#ifdef kJuranDesigner
    return [UIColor whiteColor];
#endif
    return [UIColor blackColor];
}

- (UIColor *)navigationButtonColor{
#ifdef kJuranDesigner
    return [UIColor whiteColor];
#endif
    return kBlueColor;
}

- (NSString *)userType{
#ifdef kJuranDesigner
    return @"designer";
#endif
    return @"member";
}

- (UIImage *)imageNamed:(NSString *)name ofType:(NSString *)type{
#ifdef kJuranDesigner
    name = [name stringByAppendingString:@"_white"];
    ;
    UIImage *image = [UIImage imageNamed:name];
//    return [UIImage imageNamed:name];
//    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]];
    if (image) {
        return image;
    }
    
#endif
    return [UIImage imageNamed:name];
//    return [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]];
}

- (UIImage *)imageNamed:(NSString *)name{
    return [self imageNamed:name ofType:@"png"];
}

@end
