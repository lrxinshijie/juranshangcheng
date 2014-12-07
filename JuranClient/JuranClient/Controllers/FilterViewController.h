//
//  FilterViewController.h
//  JuranClient
//
//  Created by 李 久龙 on 14/12/7.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)clickFilterViewReturnData:(NSDictionary *)data;

@end

@interface FilterViewController : ALViewController

@property (nonatomic, assign) id<FilterViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDictionary *defaultData;
@property (nonatomic, strong) NSMutableDictionary *selecteds;
@property (nonatomic, assign) FilterViewType type;

@end
