//
//  DesignerCell.h
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRDesigner;

@interface DesignerCell : UITableViewCell

- (void)fillCellWithDesigner:(JRDesigner *)data;

@end
