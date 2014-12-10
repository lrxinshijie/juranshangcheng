//
//  DemandEditTextViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DemandEditTextViewController.h"

@interface DemandEditTextViewController ()

@end

@implementation DemandEditTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSave) title:@"确认发布" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void)onSave{
    
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
