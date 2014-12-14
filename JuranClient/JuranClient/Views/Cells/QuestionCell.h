//
//  QuestionCell.h
//  JuranClient
//
//  Created by song.he on 14-12-10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JRQuestion;

@interface QuestionCell : UITableViewCell

- (void)fillCellWithQuestion:(JRQuestion *)data;


@end
