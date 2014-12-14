//
//  AnswerDetailCell.h
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRAnswer.h"
@class AnswerDetailCell;


@protocol AnswerDetailCellDelegate <NSObject>

- (void)answerDetailCell:(AnswerDetailCell*) cell adoptAnswer:(JRAnswer*) answer;

@end

@interface AnswerDetailCell : UITableViewCell

@property (nonatomic, weak) id<AnswerDetailCellDelegate> delegate;

- (void)fillCellWithAnswer:(JRAnswer*) answer type:(NSInteger)type;


@end
