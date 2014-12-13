//
//  BidDesignerCell.h
//  JuranClient
//
//  Created by song.he on 14-12-13.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRDesigner;

@interface BidDesignerCell : UITableViewCell

- (void)fillCellWithDesigner:(JRDesigner*)designer;

@end
