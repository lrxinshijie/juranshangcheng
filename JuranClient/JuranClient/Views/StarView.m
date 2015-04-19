//
//  StarView.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/16.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "StarView.h"

@implementation StarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithPoint:(CGPoint)point{
    if (self = [super initWithFrame:CGRectMake(point.x, point.y, 125, 16)]) {
        self.backgroundColor = [UIColor clearColor];
        for (int i = 0; i<5; i++) {
            UIImage *image = [UIImage imageNamed:@"product-icon-star"];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(10+image.size.width), 0, image.size.width, image.size.height)];
            imageView.image = image;
            imageView.tag = 0;
            [self addSubview:imageView];
        }
    }
    return self;
}

@end
