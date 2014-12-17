//
//  CanRemoveImageView.m
//  JuranClient
//
//  Created by song.he on 14-12-14.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "CanRemoveImageView.h"

@interface CanRemoveImageView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation CanRemoveImageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"delete_image.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(onDeleteImage:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.frame = CGRectMake(0, 0, 22, 22);
        _deleteButton.center = CGPointMake(CGRectGetWidth(frame), 0);
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

@end