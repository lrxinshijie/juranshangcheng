//
//  WikiCell.h
//  JuranClient
//
//  Created by HuangKai on 15/1/17.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRWiki;

@interface WikiCell : UITableViewCell

- (void)fillCellWithWiki:(JRWiki*)wiki;

@end
