//
//  AttributeCell.h
//  JuranClient
//
//  Created by 李 久龙 on 15/5/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRProduct.h"

@class ProductDetailViewController;
@interface AttributeCell : UITableViewCell

@property (nonatomic, assign) ProductDetailViewController *viewController;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)fillCellWithDict:(NSDictionary *)dict;
+ (CGFloat)cellHeight;

@end
