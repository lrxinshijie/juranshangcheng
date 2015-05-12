//
//  MapScrollView.m
//  JuranClient
//
//  Created by 彭川 on 15/5/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "MapScrollView.h"
#import <BaiduMapAPI/BMapKit.h>

@implementation MapScrollView
//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView* result = [super hitTest:point withEvent:event];
//    UIView* map = [result.viewController.view viewWithTag:1101];
//    if (map && [map isKindOfClass:[BMKMapView class]]) {
//        if (map.frame.size.height - map.frame.origin.y - point.y) {
//            return map;
//        }else{
//            return result;
//        }
//    }
//    return result;
//}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *result = [super hitTest:point withEvent:event];
//    CGPoint buttonPoint = [underButton convertPoint:point fromView:self];
//    if ([underButton pointInside:buttonPoint withEvent:event]) {
//        return underButton;
//    }
//    return result;
//}
@end