//
//  AnswerCell.h
//  JuranClient
//
//  Created by song.he on 14-12-11.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JRAnswer;

@interface AnswerCell : UITableViewCell

- (void)fillCellWithAnswer:(JRAnswer*)answer anIsAdoptedAnswer:(BOOL)flag;

@end
