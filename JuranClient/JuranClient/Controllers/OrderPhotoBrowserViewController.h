//
//  OrderPhotoBrowserViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/2/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
#import "MWPhotoBrowser.h"

@interface OrderPhotoBrowserViewController : MWPhotoBrowser

- (id)initWithPhotos:(NSArray*)photosArray andStartWithPhotoAtIndex:(NSUInteger)index;

@end
