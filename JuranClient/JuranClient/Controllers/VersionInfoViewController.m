//
//  VersionInfoViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-13.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "VersionInfoViewController.h"

@interface VersionInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;

@end

@implementation VersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"版本信息";
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableHeaderView = _tableHeaderView;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _versionLabel.text = [NSString stringWithFormat:@"V %@", [Public versionString]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellIndicator.png"]];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"检查更新";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"欢迎页";
    }
    return cell;
}

@end
