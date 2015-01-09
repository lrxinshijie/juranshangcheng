//
//  StyleModifyViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/1/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRDesigner;

@interface StyleModifyViewController : ALViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) JRDesigner *designer;

@end
