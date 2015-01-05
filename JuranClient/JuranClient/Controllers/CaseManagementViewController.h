//
//  CaseManagementViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/1/2.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@interface CaseManagementViewController : ALViewController

@property (nonatomic, strong) NSMutableArray *datas;

- (void)refreshView;

@end
