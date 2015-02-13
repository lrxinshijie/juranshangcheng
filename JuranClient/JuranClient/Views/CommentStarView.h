//
//  CommentStarView.h
//  JuranClient
//
//  Created by HuangKai on 15/2/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentStarView;

@protocol CommentStarViewDelegate <NSObject>

@optional

- (void)didSelectedStarView:(CommentStarView*)starView;

@end

@interface CommentStarView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<CommentStarViewDelegate> delegate;


- (void)setEnable:(BOOL)isEnadbel;

@end
