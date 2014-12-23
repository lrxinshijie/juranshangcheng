//
//  ALGetPhoto.h
//  AMOA
//
//  Created by Kowloon on 14-11-11.
//  Copyright (c) 2014年 kowloon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImagesBlock)(NSArray *images);

@interface ALGetPhoto : NSObject

+ (ALGetPhoto *)sharedPhoto;

- (void)showInViewController:(UIViewController *)viewController sourceType:(UIImagePickerControllerSourceType)sourceType allowsEditing:(BOOL)editing MaxNumber:(NSInteger)maxNumber  Handler:(ImagesBlock)block;
- (void)showInViewController:(UIViewController *)viewController allowsEditing:(BOOL)editing MaxNumber:(NSInteger)maxNumber Handler:(ImagesBlock)block;

@end
