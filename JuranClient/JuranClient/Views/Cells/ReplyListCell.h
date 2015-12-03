//
//  ReplyListCell.h
//  JuranClient
//
//  Created by 123 on 15/11/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRShopOrProduceComment.h"
#import "TTTAttributedLabel.h"

@protocol ReplyListCellDelegate <NSObject>

-(void)reply:(JRReplyModel *)model;

@end

@interface ReplyListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *labContent;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property(nonatomic,strong) JRReplyModel *model;
-(void)setData:(JRReplyModel *)model;
- (IBAction)btnReplyClick:(id)sender;

@property(nonatomic,weak) id<ReplyListCellDelegate> delegate;

@end
