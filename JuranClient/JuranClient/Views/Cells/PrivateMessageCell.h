//
//  PrivateMessageCell.h
//  JuranClient
//
//  Created by Kowloon on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrivateMessage;
@interface PrivateMessageCell : UITableViewCell

- (void)fillCellWithData:(PrivateMessage *)message;

@end
