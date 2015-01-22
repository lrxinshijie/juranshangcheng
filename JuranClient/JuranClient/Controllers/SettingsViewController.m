//
//  SettingsViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SettingsViewController.h"
#import "VersionInfoViewController.h"
#import "FeedBackViewController.h"
#import "APPRecommendViewController.h"

#import "AppDelegate.h"
#import "SDImageCache.h"
#import "GuideViewController.h"

#import "UIAlertView+Blocks.h"
#import "JRServiceViewController.h"

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *keysForImageSet;
    NSArray *keysForOthers;
    NSNumber *imageQuality;
    NSNumber *intelligentMode;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) UISwitch *intelligentModeSwitch;
@property (nonatomic, strong) IBOutlet UIButton *exitLoginButton;

@end

@implementation SettingsViewController

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
    
    self.navigationItem.title = @"设置";
    
    keysForImageSet = @[@"智能模式", @"高质量（适合WIFI环境）", @"普通（适合2G或3G模式）"];
    
    
#ifdef kJuranDesigner
    keysForOthers = @[@"问题反馈", @"版本信息"
                                            , @"给我打分"
//                      , @"其他APP推荐"
                      , @"居然服务"
                      ];
#else
    keysForOthers = @[@"问题反馈"
                      , @"版本信息"
                      , @"给我打分"
//                      , @"其他APP推荐"
                      ];
#endif
    
    intelligentMode = [Public intelligentModeForImageQuality];
    imageQuality = [DefaultData sharedData].imageQuality;
    
    _intelligentModeSwitch = [[UISwitch alloc] init];
    _intelligentModeSwitch.on = intelligentMode.integerValue;
    [_intelligentModeSwitch addTarget:self action:@selector(changeIntelligentMode:) forControlEvents:UIControlEventValueChanged];
    _exitLoginButton.layer.cornerRadius = 2.0f;
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = _footerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogout:(id)sender{
    [[JRUser currentUser] logout];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeIntelligentMode:(id)sender{
    intelligentMode = @(_intelligentModeSwitch.on);
    [Public setIntelligentModeForImageQuality:intelligentMode];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource/Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] init];
    v.frame = CGRectMake(0, 0, kWindowWidth, 30);
    v.backgroundColor = RGBColor(232, 232, 232);
    UILabel *label = [v labelWithFrame:CGRectMake(15, 0, 200, 30) text:@"" textColor:RGBColor(102, 102, 102) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    [v addSubview:label];
    if (section == 0) {
        label.text = @"图片质量";
    }else if (section == 2) {
        label.text = @"其他";
    }else if (section == 1){
        v.backgroundColor = RGBColor(241, 241, 241);
    }
    return v;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] init];
    v.frame = CGRectMake(0, 0, kWindowWidth, 30);
    v.backgroundColor = RGBColor(241, 241, 241);
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return keysForImageSet.count;
    }else if (section == 1){
        return 1;
    }else{
        return keysForOthers.count;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize+2];
        cell.detailTextLabel.textColor = RGBColor(143, 143, 143);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textColor = RGBColor(79, 79, 79);
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellIndicator.png"]];
    cell.detailTextLabel.text = @"";
    if (indexPath.section == 0) {
        cell.textLabel.text = keysForImageSet[indexPath.row];
        if (indexPath.row == 0) {
            cell.accessoryView = _intelligentModeSwitch;
        }else if (indexPath.row == 1){
            cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 23, 23) image:[UIImage imageNamed:intelligentMode.integerValue?(imageQuality.integerValue?@"image_quality_selected_disabled":@"image_quality_unselected_disabled"):(imageQuality.integerValue?@"image_quality_selected":@"image_quality_unselected")]];
            if (intelligentMode.integerValue) {
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
        }else{
            cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 23, 23) image:[UIImage imageNamed:intelligentMode.integerValue?(imageQuality.integerValue?@"image_quality_unselected_disabled":@"image_quality_selected_disabled"):(imageQuality.integerValue?@"image_quality_unselected":@"image_quality_selected")]];
            if (intelligentMode.integerValue) {
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"清除缓存";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f M", [[SDImageCache sharedImageCache] getSize]/1024.f/1024.f];
    }else{
        cell.textLabel.text = keysForOthers[indexPath.row];
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = [Public versionString];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (intelligentMode.integerValue) {
            return;
        }
        if (indexPath.row == 1) {
            imageQuality = @1;
        }else if (indexPath.row == 2){
            imageQuality = @0;
        }
        [[DefaultData sharedData] setImageQuality:imageQuality];
        [_tableView reloadData];
    }else if (indexPath.section == 1) {
        [UIAlertView showWithTitle:@"提示" message:@"确定清除缓存!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"清除"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[SDImageCache sharedImageCache] clearDisk];
                [_tableView reloadData];
            }
        }];
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            FeedBackViewController *vc = [[FeedBackViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            VersionInfoViewController *vc = [[VersionInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/app/id%d?mt=8", kAppleID]]];
        }else if (indexPath.row == 13){
            //其他APP推荐
            APPRecommendViewController *vc = [[APPRecommendViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3){
            //居然服务
            JRServiceViewController *vc = [[JRServiceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
