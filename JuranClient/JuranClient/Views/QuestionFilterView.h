//
//  QuestionFilterView.h
//  JuranClient
//
//  Created by song.he on 14-12-19.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionFilterView;

@protocol QuestionFilterViewDelegate <NSObject>

- (void)clickQuestionFilterView:(QuestionFilterView *)view returnData:(NSDictionary *)data;

@end

@interface QuestionFilterView : UIView

@property (nonatomic, assign) id<QuestionFilterViewDelegate> delegate;

-(id)initWithDefaultData:(NSDictionary *)defaultData;

- (void)showSort;
- (BOOL)isShow;

@end
