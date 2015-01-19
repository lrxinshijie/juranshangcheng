//
//  VersionInfoViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-13.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "VersionInfoViewController.h"
#import "GuideViewController.h"

@interface VersionInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSString *downLoadUrl;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

@end

@implementation VersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"版本信息";
    
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 15.f;
    
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

- (void)checkUpdate{
#ifdef kJuranDesigner
    NSString *scope = @"2";
#else
    NSString *scope = @"1";
#endif
    NSDictionary *param = @{@"type": @"IOS",
                            @"versionNo":[Public versionString],
                            @"appScope":scope};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_VERSION parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSString *version = [data getStringValueForKey:@"versionNo" defaultValue:@""];
            if (![Public versionEqualString:[Public versionString] NewVersion:version]) {
                [self showTip:@"已经是最新版本"];
            }else{
                downLoadUrl = [data getStringValueForKey:@"downLoadUrl" defaultValue:nil];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:[data getStringValueForKey:@"versionContent" defaultValue:@""] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                [alertView show];
            }
        }
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self checkUpdate];
    }else if (indexPath.row == 1) {
        GuideViewController *gv = [[GuideViewController alloc] init];
        gv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
#ifndef kJuranDesigner
        [self.tabBarController presentViewController:gv animated:YES completion:NULL];
#else
        [self presentViewController:gv animated:YES completion:NULL];
#endif
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (downLoadUrl && downLoadUrl.length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downLoadUrl]];
        }
    }
}

@end
