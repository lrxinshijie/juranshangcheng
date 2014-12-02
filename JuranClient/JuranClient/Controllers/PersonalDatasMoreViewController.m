//
//  PersonalDatasMoreViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-27.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PersonalDatasMoreViewController.h"

@interface PersonalDatasMoreViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *values;
    NSArray *keys;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation PersonalDatasMoreViewController

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
    
    self.navigationItem.title = @"更多资料";
    [self setupDatas];
    [self setupUI];
}

- (void)setupDatas{
    values = @[@"生日", @"详细地址", @"固定电话", @"证件信息", @"QQ", @"微信", @"所学专业", @"专业类型", @"证书与奖项"];
    keys = @[@"生日", @"详细地址", @"固定电话", @"证件信息", @"QQ", @"微信", @"所学专业", @"专业类型", @"证书与奖项"];
}

- (void)setupUI{
    _tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return keys.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"personalDataMore";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = keys[indexPath.row];
    cell.detailTextLabel.text = values[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
