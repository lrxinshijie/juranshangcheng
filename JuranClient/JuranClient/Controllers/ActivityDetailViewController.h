//
//  ActivityDetailViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/1/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@interface ActivityDetailViewController : ALViewController

@property (nonatomic, copy) NSString *urlString;

- (void)setShareTitle:(NSString *)title Content:(NSString*)content ImagePath:(NSString*) imagePath;

@end
