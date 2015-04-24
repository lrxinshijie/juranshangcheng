//
//  CategaryTableViewCell.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/24.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategaryTableViewCellItem.h"

@interface CategaryTableViewCell : UITableViewCell

@property (strong, nonatomic)NSString * cell_id;

- (void)configCellUIWithItem:(CategaryTableViewCellItem *)item;
- (void)setCellTitleSelect;
- (void)setCellTitleNormal;

@end
