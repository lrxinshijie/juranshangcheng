//
//  IndoorMapViewControllerDelegate.h
//  IndoorMapLib
//
//  Created by Kevin Chou on 15/5/29.
//  Copyright (c) 2015年 nv. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IndoorMapViewControllerDelegate <NSObject>

/**
 *	@brief  显示详情页面
 *
 *  param
 *        info      门店ID&摊位ID
 *
 *	@return
 */
-(void)showStallCodeDetail:(NSString*)info;

@end
