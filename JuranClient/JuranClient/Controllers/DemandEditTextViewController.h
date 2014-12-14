//
//  DemandEditTextViewController.h
//  JuranClient
//
//  Created by 李 久龙 on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

typedef enum : NSUInteger {
    DemandEditContactsName = 0,
    DemandEditContactsMobile = 1,
    DemandEditBudget = 3,
    DemandEditNeighbourhoods = 7,
    DemandEditHouseArea = 4
} DemandEdit;

@class JRDemand;
@interface DemandEditTextViewController : ALViewController

@property (nonatomic, assign) DemandEdit editType;
@property (nonatomic, strong) JRDemand *demand;

@end
