//
//  ConstructPriceListCell.h
//  JuranClient
//
//  Created by HuangKai on 15/4/21.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConstructPriceListCell : UITableViewCell

- (void)fillCellWithValue:(id)value isHead:(BOOL)flag;
+ (CGFloat)cellHeightWithValue:(id)value isHead:(BOOL)flag;

@end
