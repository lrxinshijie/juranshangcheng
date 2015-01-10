//
//  CaseEditStyleViewController.h
//  JuranClient
//
//  Created by Kowloon on 15/1/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRCaseImage;
typedef void (^CaseImageSelected)(JRCaseImage *image);

@interface CaseEditStyleViewController : ALViewController

@property (nonatomic, copy) CaseImageSelected block;
@property (nonatomic, strong) JRCaseImage *caseImage;

@end
