//
//  NavIndoorMapViewController.h
//  BaiLian_Map
//
//  Created by navinfoaec on 15/3/18.
//  Copyright (c) 2015年 sw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IndoorMapViewControllerDelegate.h"


@interface NavIndoorMapViewController : UIViewController

@property(nonatomic, assign)id<IndoorMapViewControllerDelegate> IMDelegate;

// 居然提供的城市ID(暂时未用，保留)
@property(nonatomic, strong)NSString *CityId;

// 居然提供的楼层ID（可选）
@property(nonatomic, strong)NSString *FloorId;

// 新接口
@property(nonatomic, strong)NSString *storeCode;

@property(nonatomic, strong)NSString *stallCode;

@property(nonatomic, strong)NSString *Type;

/// 计算导航路径
-(void)autoComputeRoute;

- (void)BackToPreView;

-(void)releaseResource;

@end
