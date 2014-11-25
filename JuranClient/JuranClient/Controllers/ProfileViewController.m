//
//  ProfileViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ProfileViewController.h"
#import "PersonalDataViewController.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titleArray;
}
@property (nonatomic, weak) IBOutlet UIView *buttonView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;

@end

@implementation ProfileViewController

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
    
    self.navigationItem.title = @"个人中心";
    
    [self setupView];
    [self setupData];
}


- (void)setupView{
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = _headerView;
    
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = _headerImageView.frame.size.width / 2.f;
    _headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerImageView.layer.borderWidth = 1.f;
}

- (void)setupData{
    titleArray = @[@"案例管理", @"个人主页", @"我的关注", @"我的收藏", @"订单管理", @"实名认证", @"账户管理", @"账户安全"];
}

#pragma mark - Target Action

- (IBAction)doTouchHeaderView:(id)sender{
    PersonalDataViewController *vc = [[PersonalDataViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 67;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_buttonView.superview) {
            [_buttonView removeFromSuperview];;
        }
        [cell.contentView addSubview:_buttonView];
    }else{
        static NSString *cellIdentifier = @"ProfileCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor colorWithRed:155/255.f green:155/255.f blue:155/255.f alpha:1.f];
            cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        }
        cell.textLabel.text = titleArray[indexPath.row - 1];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
