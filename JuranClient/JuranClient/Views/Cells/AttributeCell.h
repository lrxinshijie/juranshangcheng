//
//  AttributeCell.h
//  JuranClient
//
//  Created by 李 久龙 on 15/5/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributeCell : UITableViewCell

- (void)fillCellWithDict:(NSDictionary *)dict;
+ (CGFloat)cellHeight;

@end
