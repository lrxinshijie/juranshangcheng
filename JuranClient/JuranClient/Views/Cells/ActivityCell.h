//
//  ActivityCell.h
//  JuranClient
//
//  Created by HuangKai on 15/1/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRActivity;
@interface ActivityCell : UITableViewCell

- (void)fillCellWithActivity:(JRActivity*)activity;

@end


