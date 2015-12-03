//
//  MyCommentCell.h
//  JuranClient
//
//  Created by 123 on 15/11/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentStarView.h"
#import "JRShopOrProduceComment.h"
@protocol MyCommentCellDelegate <NSObject>

-(void)setSelectedItem:(NSInteger) i;

@end

@interface MyCommentCell : UITableViewCell
@property(assign,nonatomic) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet CommentStarView *staticStarRatingView;

@property(nonatomic,assign) id<MyCommentCellDelegate> delegate;

@property(nonatomic,strong) JRShopOrProduceComment *model;
- (IBAction)btnSelectClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UIView *contentImageView;

@property (weak, nonatomic) IBOutlet UILabel *labName;

-(void)setData:(JRShopOrProduceComment *)model;

@end
