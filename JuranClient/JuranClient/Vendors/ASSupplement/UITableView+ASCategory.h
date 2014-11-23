//
//  UITableView+ASCategory.h
//  PhoneOnline
//
//  Created by Kowloon on 12-8-3.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ASCategory)

- (void)scrollToBottom;
- (void)hideEmptyCells;

- (void)scrollToTop;
- (void)scrollToTopAndReload;

@end
