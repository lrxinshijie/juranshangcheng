//
//  JRServiceViewController.m
//  JuranClient
//
//  Created by HuangKai on 14-12-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRServiceViewController.h"

@interface JRServiceViewController ()

@end

@implementation JRServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"关于";
    [self setUI];
    
}

- (void)setUI{
    
}

- (IBAction)onDetail:(id)sender{
    
    
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
