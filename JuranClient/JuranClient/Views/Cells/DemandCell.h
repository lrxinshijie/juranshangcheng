//
//  DemandCell.h
//  JuranClient
//
//  Created by song.he on 14-12-1.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JRDemand;

@interface DemandCell : UITableViewCell



- (void)fillCellWithDemand:(JRDemand*)demand;

@end
