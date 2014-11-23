//
//  COViewController.m
//  CarOnline
//
//  Created by Kowloon on 13-12-17.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import "ALViewController.h"

@interface ALViewController ()

@end

@implementation ALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureLeftBarButtonUniformly];
    self.view.backgroundColor = kViewBackgroundColor;
    
    if (SystemVersionGreaterThanOrEqualTo7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
//    
////    if (![[self.navigationController viewControllers] containsObject: self]){
////        
////    }
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        if ([self.navigationController.viewControllers count] == 2) {
//            self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        }
//    }
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
