//
//  ProductPhotoBrowserViewController.h
//  JuranClient
//
//  Created by 李 久龙 on 15/5/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "MWPhotoBrowser.h"

@interface ProductPhotoBrowserViewController : MWPhotoBrowser

- (id)initWithPhotos:(NSArray*)photosArray andStartWithPhotoAtIndex:(NSUInteger)index;

@end
