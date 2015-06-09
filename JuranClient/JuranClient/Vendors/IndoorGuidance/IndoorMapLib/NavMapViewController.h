//
//  NIMapViewController.h
//  IndoorMapDemo
//
//  Created by Kevin Chou on 15/5/27.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndoorMapViewControllerDelegate.h"

@interface NavMapViewController : UINavigationController

@property(nonatomic, assign) id<IndoorMapViewControllerDelegate> IMDelegate;

// 居然提供的城市ID(暂时未用，保留)
@property(nonatomic, strong)NSString *CityId;

// 居然提供的楼层ID(暂时未用，保留)
@property(nonatomic, strong)NSString *FloorId;

@property(nonatomic, strong)NSString *storeCode;

@property(nonatomic, strong)NSString *stallCode;

@property(nonatomic, strong)NSString *Type;

- (id)initWithStoreCode:(NSString *)storeCode stallCode:(NSString*)stallCode Type:(NSString *)Type;

@end
