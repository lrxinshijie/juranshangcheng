//
//  UploadCardImageViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/1/2.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class UploadCardImageViewController;

@protocol UploadCardImageViewControllerDelegate <NSObject>

- (void)uploadCardImageWithImages:(NSArray*)images andType:(NSInteger)type;

@end

@interface UploadCardImageViewController : ALViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, weak) id<UploadCardImageViewControllerDelegate> delegate;

@end
