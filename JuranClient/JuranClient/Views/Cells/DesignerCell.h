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

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *styleLabel;
@property (nonatomic, weak) IBOutlet UILabel *experienceLabel;
@property (nonatomic, weak) IBOutlet UIButton *productCountButton;
@property (nonatomic, weak) IBOutlet UIButton *readCountButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

- (void)fillCellWithDesigner:(JRDesigner *)data;

@end
