//
//  CanRemoveImageView.m
//  JuranClient
//
//  Created by song.he on 14-12-14.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "CanRemoveImageView.h"

#define kMargin 15

@interface CanRemoveImageView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation CanRemoveImageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y - kMargin, CGRectGetWidth(frame) + kMargin, CGRectGetHeight(frame) + kMargin)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMargin, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"delete_image.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(onDeleteImage:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.frame = CGRectMake(0, 0, 22, 22);
        _deleteButton.center = CGPointMake(CGRectGetWidth(frame), kMargin);
        [self addSubview:_deleteButton];
        
    }
    return self;
}

- (void)onDeleteImage:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteCanRemoveImageView:)]) {
        [_delegate deleteCanRemoveImageView:self];
    }
    [self removeFromSuperview];
}


- (void)setImage:(UIImage*)image{
    _imageView.image = image;
}

- (void)setImageViewContentMode:(UIViewContentMode)mode{
    _imageView.contentMode = mode;
}

- (void)setImageViewBackgroundColor:(UIColor*)color{
    _imageView.backgroundColor = color;
}


@end
