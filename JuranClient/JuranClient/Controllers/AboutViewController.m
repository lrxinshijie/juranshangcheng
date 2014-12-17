//
//  AboutViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-14.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic, strong) IBOutlet UIView *footerView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"关于";
    
    UILabel *label = [self.view labelWithFrame:CGRectMake(20, 10, 280, 20) text:@"居然在线简介" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:17]];
    [self.view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 1)];
    line.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:line];
    
    UITextView *textView = [self.view textViewWithFrame:CGRectMake(20, 45, 280, kWindowHeightWithoutNavigationBarAndTabbar - 45) backgroundColor:[UIColor clearColor] text:@"快点快点开快点快点开快点快点快点快点快点开快点快点快点快点快点快点快点开快点打快点开快点快点快点开快点快点快点快点快点快点看看结束了肯定就发了卡就是的考虑放假快乐撒记得来开房记录卡就是对方考虑接受了卡机的罚款了技术可垃圾的疯狂邻居快乐撒娇的" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    textView.editable = NO;
    [self.view addSubview:textView];
    
    _footerView.frame = CGRectMake(0, kWindowHeightWithoutNavigationBarAndTabbar, CGRectGetWidth(_footerView.frame), CGRectGetHeight(_footerView.frame));
    [self.view addSubview:_footerView];
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
