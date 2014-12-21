//
//  DemandDetailViewController.h
//  JuranClient
//
//  Created by song.he on 14-12-10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"
@class DemandDetailViewController;
@class JRDemand;

@protocol DemandDetailViewControllerDelegate <NSObject>

- (void)valueChangedWithDemandDetailVC:(DemandDetailViewController*)vc;

@end

@interface DemandDetailViewController : ALViewController

@property (nonatomic, strong) JRDemand *demand;
@property (nonatomic, weak) id<DemandDetailViewControllerDelegate> delegate;

@end
