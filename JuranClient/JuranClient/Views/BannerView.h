//
//  BannerView.h
//  JuranClient
//
//  Created by 李 久龙 on 14/11/30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerView;

@protocol BannerViewDelegate <NSObject>

- (NSInteger)numberInBannerView:(BannerView *)bannerView;

@end

@interface BannerView : UIView

@property (nonatomic, assign) id<BannerViewDelegate> delegate;

@end
