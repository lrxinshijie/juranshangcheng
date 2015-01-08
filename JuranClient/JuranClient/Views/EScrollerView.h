//
//  EScrollerView.h
//  JuranClient
//
//  Created by 李 久龙 on 14/11/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PageControlAligmentLeft,
    PageControlAligmentRight,
    PageControlAligmentCenter,
} PageControlAligment;

@protocol EScrollerViewDelegate <NSObject>

@optional
-(void)EScrollerViewDidClicked:(NSUInteger)index;

@end

@interface EScrollerView : UIView

@property (nonatomic, assign) id<EScrollerViewDelegate> delegate;

- (id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr Aligment:(PageControlAligment)aligment;

@end
