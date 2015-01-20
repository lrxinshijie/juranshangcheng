//
//  CaseImagePreviewViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/1/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CaseImagePreviewViewController.h"
#import "JRCaseImage.h"
#import "CaseEditStyleViewController.h"
#import "ALGetPhoto.h"

@interface CaseImagePreviewViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *coverButton;

@end

@implementation CaseImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    if (_caseImage.image) {
        _imageView.image = _caseImage.image;
    }else if (_caseImage.imageUrl.length > 0){
        [_imageView setImageWithURLString:_caseImage.imageUrl];
    }
    
    
    if (_caseImage.frontFlag) {
        [_coverButton setImage:[UIImage imageNamed:@"case_edit_replace"] forState:UIControlStateNormal];
        [_coverButton setTitle:@"更换" forState:UIControlStateNormal];
    }else{
        [_coverButton setImage:[UIImage imageNamed:@"case_edit_cover"] forState:UIControlStateNormal];
        [_coverButton setTitle:@"设为封面" forState:UIControlStateNormal];
    }
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//}

- (IBAction)onBack:(id)sender{
    if (_block) {
        _block(_caseImage, CaseImageEventChange);
    }
    [super back:sender];
}

- (IBAction)onDelete:(id)sender{
    if (_block) {
        _block(_caseImage, CaseImageEventDelete);
    }
    [self onBack:sender];
}

- (IBAction)onCover:(id)sender{
    if (_caseImage.frontFlag) {
        [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
            UIImage *image = [images firstObject];
            _caseImage.image = image;
            _imageView.image = image;
        }];
    }else{
        if (_block) {
            _block(_caseImage, CaseImageEventCover);
        }
        [self onBack:sender];
    }
    
}

- (IBAction)onStyle:(id)sender{
    CaseEditStyleViewController *es = [[CaseEditStyleViewController alloc] init];
    es.caseImage = _caseImage;
    
    UINavigationController *nav = [Public navigationControllerFromRootViewController:es];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
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
