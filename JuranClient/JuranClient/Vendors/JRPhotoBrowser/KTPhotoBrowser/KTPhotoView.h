//
//  KTPhotoView.h
//  Sample
//
//  Created by Kirby Turner on 2/24/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTPhotoScrollViewController;


@interface KTPhotoView : UIScrollView <UIScrollViewDelegate>
{
   UIImageView *imageView_;
   KTPhotoScrollViewController *scroller_;
   NSInteger index_;
    UIActivityIndicatorView *indicatorView_;
    
}

@property (nonatomic, assign) KTPhotoScrollViewController *scroller;
@property (nonatomic, assign) NSInteger index;

- (void)setImage:(UIImage *)newImage;
- (void)turnOffZoom;
- (UIImage *)image;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

- (void)startActivity;
- (void)stopActivity;
- (UIImageView *)imageView;
@end
