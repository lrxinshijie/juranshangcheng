//
//  CaseImageManagemanetViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/1/3.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
#import "JRCase.h"
#import "JRCaseImage.h"

@interface CaseImageManagemanetViewController : ALViewController

@property (nonatomic, strong) UIImage *roomTypeImage;
@property (nonatomic, strong) NSMutableArray *caseImages;
@property (nonatomic, strong) JRCase *jrCase;

@end
