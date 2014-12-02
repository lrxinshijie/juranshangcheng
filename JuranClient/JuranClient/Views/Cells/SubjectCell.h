//
//  SubjectCell.h
//  JuranClient
//
//  Created by Kowloon on 14/12/2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRSubject;
@interface SubjectCell : UITableViewCell

- (void)fillCellWithSubject:(JRSubject *)subject;

@end
