//
//  CustomThirdLevelCell.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/21.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CellHeight 31

@protocol CustomThirdLevelCellDelegate <NSObject>

- (void)thirdLevelItemDidSelectedWithMessage:(NSString *)msg;

@end

@interface CustomThirdLevelCell : UITableViewCell

@property (assign, nonatomic) id<CustomThirdLevelCellDelegate>delegate;

- (void)addLine;

- (void)dynamicCreateUIWithData:(NSArray *)arr;

@end
