//
//  CommentListCell.h
//  JuranClient
//
//  Created by 123 on 15/11/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRShopOrProduceComment.h"
#import "CommentStarView.h"

@class CommentListCell;

@protocol CommentListCellDelegate <NSObject>
- (void)clickCellComment:(CommentListCell *)cell;
- (void)clickVote:(CommentListCell *)cell;

@end

@interface CommentListCell : UITableViewCell


@property(strong,nonatomic) JRShopOrProduceComment *model;


@property(nonatomic,weak) id<CommentListCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UIImageView *imageHeader;
//@property (weak, nonatomic) IBOutlet UILabel *labPraise;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet CommentStarView *staticStarRatingView;
@property (weak, nonatomic) IBOutlet UIView *contentImageView;
- (IBAction)btnCommentClick:(id)sender;
- (IBAction)btnPraiseClick:(id)sender;
//@property (weak, nonatomic) IBOutlet UILabel *labReplyCount;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnPraise;

-(void)setData:(JRShopOrProduceComment *)model;
@end
