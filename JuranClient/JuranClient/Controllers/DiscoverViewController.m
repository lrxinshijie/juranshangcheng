//
//  DiscoverViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "DiscoverViewController.h"
#import "JRSegmentControl.h"

@interface DiscoverViewController ()<JRSegmentControlDelegate>

@property (nonatomic, strong) IBOutlet JRSegmentControl *segment;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"发现";
    
    [self configureSearchAndMore];
    
    [self setupUI];
}

- (void)setupUI{
    [_segment setTitleList:@[@"专题", @"百科", @"问答", @"话题"]];
}

#pragma mark - JRSegmentControlDelegate

- (void)segmentControl:(JRSegmentControl *)segment changedSelectedIndex:(NSInteger)index{
    
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
