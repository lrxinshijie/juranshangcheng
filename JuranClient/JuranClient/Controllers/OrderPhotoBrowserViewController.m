//
//  OrderPhotoBrowserViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/2/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderPhotoBrowserViewController.h"

@interface OrderPhotoBrowserViewController ()<MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *photoArray;

@end

@implementation OrderPhotoBrowserViewController

- (id)initWithPhotos:(NSArray *)photosArray andStartWithPhotoAtIndex:(NSUInteger)index{
    self = [self initWithDelegate:self];
    if (self) {
        self.photoArray = photosArray;
        [self setCurrentPhotoIndex:index];
        self.scrollNotHiddenControlEnable = YES;
        self.isNotAutoHiddenControl = YES;
        self.displayActionButton = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImageWithColor:RGBAColor(1, 1, 1, .5f)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
#ifndef kJuranDesigner
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [ALTheme sharedTheme].navigationTitleColor}];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
#ifdef kJuranDesigner
    [self.navigationController.navigationBar setBackgroundImageWithColor:[UIColor blackColor]];
#else
    [self.navigationController.navigationBar setBackgroundImageWithColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self.view buttonWithFrame:CGRectZero target:self action:@selector(back:) image:[UIImage imageNamed:@"nav_backbtn_white"]]];
    
//    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)]){
//        [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]];
//    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.f;
    [self.view addGestureRecognizer:longPress];
    
}

- (void)handleLongPress:(UIGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSURL *url = [Public imageURL:[_photoArray objectAtIndex:self.currentIndex] Width:512];
        NSLog(@"%@",url);
        MWPhoto *photo = [self currentPhoto];
        if ([photo underlyingImage]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
            [actionSheet showInView:self.view];
        }
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        MWPhoto *photo = [self currentPhoto];
        UIImageWriteToSavedPhotosAlbum([photo underlyingImage], self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [self showTip:@"图片保存成功"];
    }else{
        [self showTip:[NSString stringWithFormat:@"图片保存失败!%@", error.localizedFailureReason]];
    }
}



#pragma mark - MWPhotoBrowserDelegate

- (NSString*)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    return [NSString stringWithFormat:@"%d/%d", index + 1, _photoArray.count];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photoArray.count){
        NSURL *url = [Public imageURL:[_photoArray objectAtIndex:index] Width:512];
        NSLog(@"%@",url);
        return [MWPhoto photoWithURL:url];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
