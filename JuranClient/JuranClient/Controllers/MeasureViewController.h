//
//  MeasureViewController.h
//  JuranClient
//
//  Created by Kowloon on 14/12/19.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRDesigner;
@class JRDemand;
@interface MeasureViewController : ALViewController

@property (nonatomic, strong) JRDesigner *designer;
@property (nonatomic, strong) NSString *bidId;
@property (nonatomic, strong) JRDemand *demand;

@end
