//
//  COViewController.m
//  CarOnline
//
//  Created by Kowloon on 13-12-17.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import "ALViewController.h"
#import "MobClick.h"

@interface ALViewController ()

@end

@implementation ALViewController

- (void)dealloc{
    [ALEngine cancelOperationsWithClass:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureLeftBarButtonUniformly];
    self.view.backgroundColor = kViewBackgroundColor;
    
#ifdef kJuranDesigner
    if (SystemVersionGreaterThanOrEqualTo7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    //[self configureMore];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
