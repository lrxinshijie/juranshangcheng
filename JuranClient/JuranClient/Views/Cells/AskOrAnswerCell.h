//
//  AskOrAnswerCell.h
//  JuranClient
//
//  Created by song.he on 14-12-1.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRAnswer;
@class JRQuestion;

@interface AskOrAnswerCell : UITableViewCell

- (void)fillCellWithAnswer:(JRAnswer *)data;
- (void)fillCellWithQuestion:(JRQuestion *)data;

@end
