//
//  CommentCell.h
//  JuranClient
//
//  Created by 李 久龙 on 14/11/29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRComment;
@class CommentCell;

@protocol CommentCellDelegate <NSObject>

- (void)clickCellComment:(CommentCell *)cell;
- (void)clickCellUnfold:(CommentCell *)cell;

@end

@interface CommentCell : UITableViewCell

@property (nonatomic, assign) id <CommentCellDelegate> delegate;
@property (nonatomic, strong) JRComment *comment;

- (void)fillCellWithComment:(JRComment *)data;



@end
