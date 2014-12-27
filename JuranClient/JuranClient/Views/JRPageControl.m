//
//  JRPageControl.m
//  JuranClient
//
//  Created by Kowloon on 14/12/27.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRPageControl.h"

@interface JRPageControl (){
    UIImage*_activeImage;
    UIImage*_inactiveImage;
}

@end

@implementation JRPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _activeImage = [UIImage imageNamed:@"ad_page_action"];
        _inactiveImage = [UIImage imageNamed:@"ad_page_inactive"];
    }
    return self;
}

- (void)updateDots
{
    
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* dotView = [self.subviews objectAtIndex:i];
        UIImageView* dot = nil;
        
        for (UIView* subview in dotView.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView*)subview;
                break;
            }
        }
        
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dotView.frame.size.width, dotView.frame.size.height)];
            [dotView addSubview:dot];
        }
        
        if (i == self.currentPage){
                dot.image = _activeImage;
        }else{
                dot.image = _inactiveImage;
        }
    }
    
//    for(int i = 0; i< [self.subviews count]; i++) {
//        UIImageView *dot = [self.subviews objectAtIndex:i];
//        
//        if(i == self.currentPage){
//            dot.image = _activeImage;
//        }else{
//            dot.image= _inactiveImage;
//        }
//    }
}

- (void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

@end
