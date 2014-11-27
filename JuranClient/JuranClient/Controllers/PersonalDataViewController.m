//
//  PersonalDataViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-27.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "PersonalDatasMoreViewController.h"

@interface PersonalDataViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titleForSection1;
    NSArray *keyForSection1;
    NSArray *titleForSection2;
    NSArray *keyForSection2;
    NSArray *titleForSection3;
    NSArray *keyForSection3;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

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
}

- (void)setupDatas{
    titleForSection1 = @[@"头像", @"用户名"];
    titleForSection2 = @[@"昵称", @"性别", @"生日", @"所在地"];
    titleForSection3 = @[@"从业经验", @"设计费用", @"量房费用", @"擅长风格", @"设计专长", @"毕业院校", @"自我介绍"];
    keyForSection1 = @[@"头像", @"用户名"];
    keyForSection2 = @[@"昵称", @"性别", @"生日", @"所在地"];
    keyForSection3 = @[@"从业经验", @"设计费用", @"量房费用", @"擅长风格", @"设计专长", @"毕业院校", @"自我介绍是老骥伏枥开离开就是离开对方极乐世界进口飞机来上课"];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 7;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65;
    }else if (indexPath.section == 2 && indexPath.row == 6){
        return 70;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"personalData";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
    }
    cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 8, 16) image:[UIImage imageNamed:@"cellIndicator.png"]];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = titleForSection1[indexPath.row];
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
            cell.textLabel.text = titleForSection1[indexPath.row];
            cell.detailTextLabel.text = keyForSection1[indexPath.row];
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = titleForSection2[indexPath.row];
        cell.detailTextLabel.text = keyForSection2[indexPath.row];
    }else if (indexPath.section == 2){
        if (indexPath.row == titleForSection3.count - 1) {
            cell.textLabel.text = titleForSection3[indexPath.row];
            cell.detailTextLabel.text = @"";
            CGRect frame = CGRectMake(0, 0, 210, 53);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            frame.origin = CGPointMake(frame.size.width - 8, (frame.size.height - 16)/2);
            frame.size = CGSizeMake(8, 16);
            UIImageView *arrowImageView = [cell imageViewWithFrame:frame image:[UIImage imageNamed:@"cellIndicator.png"]];
            [view addSubview:arrowImageView];
            
            frame.origin = CGPointMake(view.frame.size.width - frame.size.width - 10 -190, 0);
            frame.size = CGSizeMake(190, 53);
            
            UILabel *label = [cell labelWithFrame:frame text:keyForSection3[indexPath.row] textColor:cell.detailTextLabel.textColor textAlignment:NSTextAlignmentCenter font:cell.detailTextLabel.font];
            label.numberOfLines = 3;
            [view addSubview:label];
            
            cell.accessoryView = view;
            
        }else{
            cell.textLabel.text = titleForSection3[indexPath.row];
            cell.detailTextLabel.text = keyForSection3[indexPath.row];
        }
    }else{
        cell.textLabel.text = @"更多资料";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        PersonalDatasMoreViewController *vc = [[PersonalDatasMoreViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
