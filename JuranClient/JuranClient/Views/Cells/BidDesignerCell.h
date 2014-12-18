//
//  BidDesignerCell.h
//  JuranClient
//
//  Created by song.he on 14-12-13.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRDesigner;
@class BidDesignerCell;

@protocol BidDesignerCellDelegate <NSObject>

- (void)rejectForBid:(BidDesignerCell*)cell andDesigner:(JRDesigner*)designer;
- (void)takeMeasure:(BidDesignerCell*)cell andDesigner:(JRDesigner*)designer;
- (void)privateLetter:(BidDesignerCell*)cell andDesigner:(JRDesigner*)designer;

@end

@interface BidDesignerCell : UITableViewCell

@property (nonatomic, weak) id<BidDesignerCellDelegate> delegate;

- (void)fillCellWithDesigner:(JRDesigner*)designer;

@end
