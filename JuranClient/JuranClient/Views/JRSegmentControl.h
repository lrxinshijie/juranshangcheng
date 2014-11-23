//
//  JRSegmentControl.h
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JRSegmentControlDelegate;

@interface JRSegmentControl : UIView

@property (nonatomic, weak) id<JRSegmentControlDelegate> delegate;
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@protocol JRSegmentControlDelegate <NSObject>


@end