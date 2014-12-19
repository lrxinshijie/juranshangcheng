//
//  TATopicCell.h
//  JuranClient
//
//  Created by song.he on 14-11-24.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRTopic;

@interface TATopicCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *topicLabel;
@property (nonatomic, weak) IBOutlet UILabel *topicContentLabel;
@property (nonatomic, weak) IBOutlet UILabel *ideaLabel;
@property (nonatomic, weak) IBOutlet UILabel *ideaContentLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UIImageView *relateImageView;

@property (nonatomic, strong) JRTopic *topic;

- (void)fillCellWithTopic:(JRTopic *)data;


@end
