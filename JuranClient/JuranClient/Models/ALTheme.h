//
//  ALTheme.h
//  JuranClient
//
//  Created by Kowloon on 15/1/7.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALTheme : NSObject

+ (ALTheme *)sharedTheme;

- (UIColor *)navigationColor;
- (UIColor *)navigationTitleColor;
- (UIColor *)navigationButtonColor;

- (NSString *)userType;

- (UIImage *)imageNamed:(NSString *)name;
- (UIImage *)imageNamed:(NSString *)name ofType:(NSString *)type;

@end
