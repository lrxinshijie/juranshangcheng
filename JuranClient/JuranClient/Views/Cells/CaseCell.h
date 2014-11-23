//
//  CaseCell.h
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRCase;

@interface CaseCell : UITableViewCell

- (void)fillCellWithCase:(JRCase *)data;

@end
