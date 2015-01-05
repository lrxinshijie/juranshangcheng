//
//  CreateCaseSuccessViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/1/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CreateCaseSuccessViewController.h"
#import "CaseManagementViewController.h"

@interface CreateCaseSuccessViewController ()

@end

@implementation CreateCaseSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"提交成功";
}

- (void)back:(id)sender{
    CaseManagementViewController *cm = (CaseManagementViewController *)[self.navigationController.viewControllers objectAtTheIndex:1];
    if (cm && [cm isKindOfClass:[CaseManagementViewController class]]) {
        [cm refreshView];
        [self.navigationController popToViewController:cm animated:YES];
    }
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
