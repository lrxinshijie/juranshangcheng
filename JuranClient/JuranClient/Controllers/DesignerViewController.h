//
//  DesignerViewController.h
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@interface DesignerViewController : ALViewController

@property (nonatomic, copy) NSString *searchKeyWord;
@property (nonatomic, assign) BOOL isHome;
@property (nonatomic, strong) NSMutableDictionary *filterData;

@end
