//
//  CaseImagePreviewViewController.h
//  JuranClient
//
//  Created by Kowloon on 15/1/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRCaseImage;

typedef enum : NSUInteger {
    CaseImageEventCover,
    CaseImageEventDelete,
    CaseImageEventChange,
} CaseImageEvent;

typedef void(^CaseImageBlock)(JRCaseImage *image, CaseImageEvent event);

@interface CaseImagePreviewViewController : ALViewController

@property (nonatomic, strong) JRCaseImage *caseImage;

@property (nonatomic, copy) CaseImageBlock block;

@end
