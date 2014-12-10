//
//  DemandEditTextViewController.h
//  JuranClient
//
//  Created by 李 久龙 on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

typedef enum : NSUInteger {
    DemandEditContactsName,
    DemandEditContactsMobile,
    DemandEditBudget,
    DemandEditNeighbourhoods,
} DemandEdit;

@class JRDemand;
@interface DemandEditTextViewController : ALViewController

@property (nonatomic, assign) DemandEdit editType;
@property (nonatomic, strong) JRDemand *demand;

@end
