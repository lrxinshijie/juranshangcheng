//
//  BidDesignerCell.h
//  JuranClient
//
//  Created by song.he on 14-12-13.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRBidInfo;
@class BidDesignerCell;

@protocol BidDesignerCellDelegate <NSObject>

- (void)rejectForBid:(BidDesignerCell*)cell andBidInfo:(JRBidInfo*)bidInfo;
- (void)takeMeasure:(BidDesignerCell*)cell andBidInfo:(JRBidInfo*)bidInfo;
- (void)privateLetter:(BidDesignerCell*)cell andBidInfo:(JRBidInfo*)bidInfo;

@end

@interface BidDesignerCell : UITableViewCell

@property (nonatomic, weak) id<BidDesignerCellDelegate> delegate;

- (void)fillCellWithJRBidInfo:(JRBidInfo*)bidInfo;
- (void)fillCellWithConfirmBidInfo:(JRBidInfo*)bidInfo;

@end
