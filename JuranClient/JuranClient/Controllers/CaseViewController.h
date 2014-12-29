//
//  CaseViewController.h
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@interface CaseViewController : ALViewController

@property (nonatomic, copy) NSString *searchKey;
@property (nonatomic, strong) NSMutableDictionary *filterData;
@property (nonatomic, assign) BOOL isHome;



@end
