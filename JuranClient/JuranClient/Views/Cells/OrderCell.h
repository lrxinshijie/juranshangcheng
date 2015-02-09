//
//  OrderCell.h
//  JuranClient
//
//  Created by Kowloon on 15/2/7.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JROrder;
@interface OrderCell : UITableViewCell

- (void)fillCellWithOrder:(JROrder *)order;

+ (CGFloat)cellHeight:(JROrder *)order;

@end
