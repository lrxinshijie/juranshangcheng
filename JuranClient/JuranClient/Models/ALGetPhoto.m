//
//  ALGetPhoto.m
//  AMOA
//
//  Created by Kowloon on 14-11-11.
//  Copyright (c) 2014年 kowloon. All rights reserved.
//

#import "ALGetPhoto.h"
#import "UIActionSheet+Blocks.h"
#import "ZYQAssetPickerController.h"

@interface ALGetPhoto () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate>

@property (nonatomic, assign) UIViewController *viewController;
@property (nonatomic, strong) ImagesBlock block;
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, assign) BOOL maxNumber;
@end

@implementation ALGetPhoto

+ (ALGetPhoto *)sharedPhoto{
    static ALGetPhoto *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)showInViewController:(UIViewController *)viewController allowsEditing:(BOOL)editing MaxNumber:(NSInteger)maxNumber Handler:(ImagesBlock)block{
    self.viewController = viewController;
    self.block = block;
    self.allowsEditing = editing;
    self.maxNumber = maxNumber;
    
    [UIActionSheet showInView:[UIApplication sharedApplication].keyWindow withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍摄",@"从相册中选择"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == [actionSheet cancelButtonIndex]) {
            return ;
        }
        
        [self showImagePickerForSourceType:buttonIndex == 0 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary];
    }];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary && !_allowsEditing) {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = _maxNumber;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.delegate = self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        if (_viewController.tabBarController) {
            [_viewController.tabBarController presentViewController:picker animated:YES completion:NULL];
        }else{
            [_viewController presentViewController:picker animated:YES completion:NULL];
        }
        
    }else{
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = _allowsEditing;
        
        if (sourceType == UIImagePickerControllerSourceTypeCamera){
            imagePickerController.showsCameraControls = YES;
        }
        
        if (_viewController.tabBarController) {
            [_viewController.tabBarController presentViewController:imagePickerController animated:YES completion:NULL];
        }else{
            [_viewController presentViewController:imagePickerController animated:YES completion:NULL];
        }
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:_allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    image = [UIImage image:[UIImage rotateImage:image] fitInSize:CGSizeMake(800, (800/image.size.width)*image.size.height)];
    
    _block(@[image]);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_viewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        image = [UIImage image:[UIImage rotateImage:image] fitInSize:CGSizeMake(800, (800/image.size.width)*image.size.height)];
        
        [images addObject:image];
    }
    
    _block(images);
}



@end
