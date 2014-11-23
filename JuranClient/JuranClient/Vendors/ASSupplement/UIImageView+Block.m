//
//  UIImageView+Block.m
//  AMOA
//
//  Created by 李 久龙 on 14-11-19.
//  Copyright (c) 2014年 kowloon. All rights reserved.
//

#import "UIImageView+Block.h"
#import "objc/runtime.h"

@implementation UIImageView (Block)

static char overviewKey;

- (void) setOnTap:(void(^)())block {
    
    [self setBlock:block];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturePearls =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tapGesturePearls];
    
}

- (void)setBlock:(void(^)())block {
    objc_setAssociatedObject (self, &overviewKey,block,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)())block {
    return objc_getAssociatedObject(self, &overviewKey);
}

- (void)onTap {
    void(^block)();
    block = [self block];
    block();
}

@end
