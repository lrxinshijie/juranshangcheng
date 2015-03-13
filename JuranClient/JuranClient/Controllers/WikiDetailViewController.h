//
//  WikiDetailViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/3/12.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRWiki;
@interface WikiDetailViewController : ALViewController

@property (nonatomic, strong) JRWiki *wiki;
@property (nonatomic, copy) NSString *wikiId;
@property (nonatomic, copy) NSString *urlString;

@end
