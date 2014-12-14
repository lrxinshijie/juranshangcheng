//
//  CanRemoveImageView.h
//  JuranClient
//
//  Created by song.he on 14-12-14.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CanRemoveImageView;

@protocol CanRemoveImageViewDelegate <NSObject>

- (void)deleteCanRemoveImageView:(CanRemoveImageView*)view;

@end

@interface CanRemoveImageView : UIView

@property (nonatomic, weak) id<CanRemoveImageViewDelegate> delegate;

- (void)setImage:(UIImage*)image;

@end
