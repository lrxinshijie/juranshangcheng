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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
