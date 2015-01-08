//
//  DemandCell.h
//  JuranClient
//
//  Created by song.he on 14-12-1.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JRDemand;
@class DemandCell;

@protocol DemandCellDelegate <NSObject>

- (void)editRemark:(DemandCell*) cell AndDemand:(JRDemand*)demand;

@end

@interface DemandCell : UITableViewCell

@property (nonatomic, weak) id<DemandCellDelegate> delegate;

- (void)fillCellWithDemand:(JRDemand*)demand;

@end
