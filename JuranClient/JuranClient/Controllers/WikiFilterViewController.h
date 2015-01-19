//
//  WikiFilterViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/1/17.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class WikiFilterViewController;

@protocol WikiFilterViewControllerDelegate <NSObject>

- (void)clickWikiFilterViewReturnData:(NSDictionary *)data;

@end

@interface WikiFilterViewController : ALViewController

@property (nonatomic, assign) id<WikiFilterViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDictionary *defaultData;

@end
