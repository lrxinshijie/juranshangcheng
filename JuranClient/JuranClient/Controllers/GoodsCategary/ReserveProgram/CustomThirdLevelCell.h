//
//  CustomThirdLevelCell.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/21.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

#define CellHeight 31

@protocol CustomThirdLevelCellDelegate <NSObject>

- (void)thirdLevelItemDidSelectedWithCatCode:(NSString *)catCode CatName:(NSString *)catName ParentCode:(NSString *)parentCode UrlContent:(NSString *)urlContent;

@end

@interface CustomThirdLevelCell : UITableViewCell

@property (assign, nonatomic) id<CustomThirdLevelCellDelegate>delegate;

- (void)addLine;

- (void)dynamicCreateUIWithData:(NSArray *)arr;

@end
