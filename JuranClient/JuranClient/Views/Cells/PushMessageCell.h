//
//  PushMessageCell.h
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRPushInfoMsg;
@class PushMessageCell;

@protocol PushMessageCellDelegate <NSObject>

- (void)changeCellExpand:(PushMessageCell*) cell;

@end

@interface PushMessageCell : UITableViewCell

@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, weak) id<PushMessageCellDelegate> delegate;

- (void)fillCellWithMsg:(JRPushInfoMsg*)msg;

@end
