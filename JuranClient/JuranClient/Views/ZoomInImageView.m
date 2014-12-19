//
//  ZoomInImageView.m
//  VertigoSample
//
//  Created by song.he on 14-12-20.
//  Copyright (c) 2014年 Guillermo Gonzalez. All rights reserved.
//

#import "ZoomInImageView.h"
#import "GlobalPopupAlert.h"
#import "DDHPreviewViewController.h"

@interface ZoomInImageView()<UIViewControllerTransitioningDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSString *url;

@end

@implementation ZoomInImageView

- (id)init{
    self = [super init];
    if (self) {
        [self configureImageView];
    }
    return self;
}

- (void)setImageWithURLString:(NSString *)url{
    _url = url;
    [super setImageWithURLString:url];
}

- (void)awakeFromNib{
    [self configureImageView];
}

- (void)configureImageView{
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
}

- (void)handleTap:(UIGestureRecognizer*)gesture{
    if (!(_url && _url.length > 0)) {
        return;
    }
    DDHPreviewViewController *viewController = [[DDHPreviewViewController alloc] init];
    viewController.url = _url;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.f;
    [viewController.view addGestureRecognizer:longPress];
    
    UIViewController *vc = [self viewController];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [vc presentViewController:viewController animated:YES completion:nil];
}

- (void)handleLongPress:(UIGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
        [actionSheet showInView:gesture.view];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum([self image], self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [self showTip:@"图片保存成功"];
    }else{
        [self showTip:[NSString stringWithFormat:@"图片保存失败!%@", error.localizedFailureReason]];
    }
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)showTip:(NSString *)tip{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [GlobalPopupAlert show:tip andFadeOutAfter:1.5];
    });
}

@end
