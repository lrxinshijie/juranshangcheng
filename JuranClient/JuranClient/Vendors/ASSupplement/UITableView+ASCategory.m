//
//  UITableView+ASCategory.m
//  PhoneOnline
//
//  Created by Kowloon on 12-8-3.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "UITableView+ASCategory.h"

@implementation UITableView (ASCategory)

- (void)scrollToBottom
{
    CGFloat result = self.contentSize.height - self.frame.size.height;
    if (result > 0) {
        CGPoint offset = CGPointMake(0, result);
        [self setContentOffset:offset animated:YES];
    }
}

- (void)hideEmptyCells
{
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)scrollToTop{
    [self setContentOffset:CGPointZero];
}

- (void)scrollToTopAndReload{
    [self scrollToTop];
    [self reloadData];
}

@end
