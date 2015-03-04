//
//  OrderFilterViewController.h
//  JuranClient
//
//  Created by 李 久龙 on 15/2/23.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALViewController.h"

@class OrderFilterViewController;

@protocol OrderFilterViewControllerDelegate <NSObject>

- (void)clickOrderFilterViewReturnData:(NSMutableArray *)selecteds;

@end

@interface OrderFilterViewController : ALViewController

@property (nonatomic, assign) BOOL isDesigner;
@property (nonatomic, strong) NSMutableArray *selecteds;
@property (nonatomic, assign) id<OrderFilterViewControllerDelegate> delegate;

@end
