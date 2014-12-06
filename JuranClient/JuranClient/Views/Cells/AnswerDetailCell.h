//
//  AnswerDetailCell.h
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRAnswer;

@interface AnswerDetailCell : UITableViewCell


- (void)fillCellWithAnswer:(JRAnswer*) answer;

@end
