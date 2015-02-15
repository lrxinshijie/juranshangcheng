//
//  OrderCommentCell.h
//  JuranClient
//
//  Created by HuangKai on 15/2/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JRDesignCreditDto;

@interface OrderCommentCell : UITableViewCell

- (void)fillCellWithDesigneCreditDto:(JRDesignCreditDto *)dto;

@end
