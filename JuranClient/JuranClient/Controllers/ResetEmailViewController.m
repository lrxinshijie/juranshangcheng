//
//  ResetEmailViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ResetEmailViewController.h"

@interface ResetEmailViewController ()

- (IBAction)onBack:(id)sender;
- (IBAction)onBackHome:(id)sender;

@end

@implementation ResetEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
}

- (IBAction)onBack:(id)sender{
    [super back:sender];
}

- (IBAction)onBackHome:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
