//
//  NewestBidInfoCell.h
//  JuranClient
//
//  Created by HuangKai on 14/12/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JRDemand;

@interface NewestBidInfoCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *bgView;

- (void)fillCellWithData:(JRDemand*)data;

@end
