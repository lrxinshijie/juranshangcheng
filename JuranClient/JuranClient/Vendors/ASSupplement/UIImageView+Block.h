//
//  UIImageView+Block.h
//  AMOA
//
//  Created by 李 久龙 on 14-11-19.
//  Copyright (c) 2014年 kowloon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Block)

- (void) setOnTap:(void(^)())block;

@end
