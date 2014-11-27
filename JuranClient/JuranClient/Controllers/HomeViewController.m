//
//  HomeViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [self configureLeftBarButtonItemImage:[UIImage imageNamed:@"icon-case-empty"] leftBarButtonItemAction:nil];
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-search"] rightBarButtonItemAction:@selector(onSearch)];
}

- (void)onSearch{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
