//
//  DesignerCell.h
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRDesigner;
@class JRDesignerFollowDto;

@interface DesignerCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *styleLabel;
@property (nonatomic, weak) IBOutlet UILabel *experienceLabel;
@property (nonatomic, weak) IBOutlet UILabel *productCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *readCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIView *sContentView;
@property (nonatomic, weak) IBOutlet UIImageView *isAuthImageView;
@property (nonatomic, strong) IBOutlet UIView *redPointView;

- (void)fillCellWithDesigner:(JRDesigner *)data;

@end
