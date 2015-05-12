//
//  MapScrollView.h
//  JuranClient
//
//  Created by 彭川 on 15/5/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMKMapView;
@interface MapScrollView : UIScrollView
@property (nonatomic,strong) BMKMapView *map;
@end
