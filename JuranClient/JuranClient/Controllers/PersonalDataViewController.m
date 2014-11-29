//
//  PersonalDataViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-27.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "PersonalDatasMoreViewController.h"
#import "SexySwitch.h"

@interface PersonalDataViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *valuesForSection1;
    NSArray *keysForSection1;
    NSArray *valuesForSection2;
    NSArray *keysForSection2;
    NSArray *valuesForSection3;
    NSArray *keysForSection3;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SexySwitch *sexySwitch;

@end

@implementation PersonalDataViewController

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
    
    self.navigationItem.title = @"个人资料";
    
    [self setupDatas];
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
//    _tableView.tableHeaderView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    _sexySwitch = [[SexySwitch alloc] init];
    _sexySwitch.selectedIndex = 1;
}

- (void)setupDatas{
    keysForSection1 = @[@"头像", @"用户名"];
    keysForSection2 = @[@"昵称", @"性别", @"生日", @"所在地", @"详细地址"];
    keysForSection3 = @[@"固定电话", @"证件信息", @"QQ", @"微信"];
    valuesForSection1 = @[@"头像", @"用户名"];
    valuesForSection2 = @[@"昵称", @"性别", @"生日", @"所在地", @"详细地址"];
    valuesForSection3 = @[@"从业经验", @"设计费用", @"量房费用", @"擅长风格"];
    
    /*
     *   设计师端个人资料
     *
     keysForSection1 = @[@"头像", @"用户名"];
     keysForSection2 = @[@"昵称", @"性别", @"生日", @"所在地"];
     keysForSection3 = @[@"从业经验", @"设计费用", @"量房费用", @"擅长风格", @"设计专长", @"毕业院校", @"自我介绍是老骥伏枥开离开就是离开对方极乐世界进口飞机来上课"];
     valuesForSection1 = @[@"头像", @"用户名"];
     valuesForSection1 = @[@"昵称", @"性别", @"生日", @"所在地"];
     valuesForSection1 = @[@"从业经验", @"设计费用", @"量房费用", @"擅长风格", @"设计专长", @"毕业院校", @"自我介绍"];
     */
    
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return keysForSection1.count;
    }else if (section == 1){
        return keysForSection2.count;
    }else if (section == 2){
        return keysForSection3.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 9;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     *  设计师端
     if (indexPath.section == 0 && indexPath.row == 0) {
     return 65;
     }else if (indexPath.section == 2 && indexPath.row == 6){
     return 70;
     }
     */
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"personalData";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize+2];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
    }
    cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 8, 16) image:[UIImage imageNamed:@"cellIndicator.png"]];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = keysForSection1[indexPath.row];
            
            CGRect frame = CGRectMake(0, 0, 100, 50);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            frame.origin = CGPointMake(frame.size.width - 8, (frame.size.height - 16)/2);
            frame.size = CGSizeMake(8, 16);
            UIImageView *arrowImageView = [cell imageViewWithFrame:frame image:[UIImage imageNamed:@"cellIndicator.png"]];
            [view addSubview:arrowImageView];
            
            frame.origin = CGPointMake(view.frame.size.width - frame.size.width - 10 -50, 0);
            frame.size = CGSizeMake(50, 50);
            
            UIImageView *iconImageView = [cell imageViewWithFrame:frame image:nil];
            iconImageView.backgroundColor = [UIColor redColor];
            iconImageView.layer.masksToBounds = YES;
            iconImageView.layer.cornerRadius = iconImageView.frame.size.height/2;
            [view addSubview:iconImageView];
            
            cell.accessoryView = view;
            
        }else{
            cell.textLabel.text = keysForSection1[indexPath.row];
            cell.detailTextLabel.text = valuesForSection1[indexPath.row];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            cell.textLabel.text = keysForSection2[indexPath.row];
            cell.detailTextLabel.text = @"";
            cell.accessoryView = _sexySwitch;
        }else{
            cell.textLabel.text = keysForSection2[indexPath.row];
            cell.detailTextLabel.text = valuesForSection2[indexPath.row];
        }
    }else if (indexPath.section == 2){
        /*
         *设计师端内容
         if (indexPath.row == keysForSection3.count - 1) {
         cell.textLabel.text = valuesForSection3[indexPath.row];
         cell.detailTextLabel.text = @"";
         CGRect frame = CGRectMake(0, 0, 210, 53);
         UIView *view = [[UIView alloc] initWithFrame:frame];
         frame.origin = CGPointMake(frame.size.width - 8, (frame.size.height - 16)/2);
         frame.size = CGSizeMake(8, 16);
         UIImageView *arrowImageView = [cell imageViewWithFrame:frame image:[UIImage imageNamed:@"cellIndicator.png"]];
         [view addSubview:arrowImageView];
         
         frame.origin = CGPointMake(view.frame.size.width - frame.size.width - 10 -190, 0);
         frame.size = CGSizeMake(190, 53);
         
         UILabel *label = [cell labelWithFrame:frame text:valuesForSection3[indexPath.row] textColor:cell.detailTextLabel.textColor textAlignment:NSTextAlignmentCenter font:cell.detailTextLabel.font];
         label.numberOfLines = 3;
         [view addSubview:label];
         
         cell.accessoryView = view;
         
         }else{
         cell.textLabel.text = keysForSection3[indexPath.row];
         cell.detailTextLabel.text = valuesForSection3[indexPath.row];
         }
         */
        cell.textLabel.text = keysForSection3[indexPath.row];
        cell.detailTextLabel.text = valuesForSection3[indexPath.row];
    }else{
        cell.textLabel.text = @"更多资料";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     *设计师端
     if (indexPath.section == 3) {
     PersonalDatasMoreViewController *vc = [[PersonalDatasMoreViewController alloc] init];
     [self.navigationController pushViewController:vc animated:YES];
     }
     */
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
