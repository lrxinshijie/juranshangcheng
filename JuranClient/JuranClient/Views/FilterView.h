//
//  FilterView.h
//  JuranClient
//
//  Created by 李 久龙 on 14/12/7.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterView;

@protocol FilterViewDelegate <NSObject>

- (void)clickFilterView:(FilterView *)view actionType:(FilterViewAction)action returnData:(NSDictionary *)data;


@end

@interface FilterView : UIView

@property (nonatomic, assign) id<FilterViewDelegate> delegate;
@property (nonatomic, assign) BOOL isGrid;

-(id)initWithType:(FilterViewType)type defaultData:(NSDictionary *)defaultData;


- (void)showSort;
- (BOOL)isShow;

@end
