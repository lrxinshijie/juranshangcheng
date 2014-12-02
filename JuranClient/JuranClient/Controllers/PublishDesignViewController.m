//
//  PublishDesignViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PublishDesignViewController.h"

@interface PublishDesignViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel1;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel2;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel3;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel4;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel5;
@property (nonatomic, strong) IBOutlet UIView *headerView;


@end

@implementation PublishDesignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"需求发布";
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSubmit) title:@"确认发布" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(225, 12, 60, 45)];
    _photoImageView.image = [UIImage imageNamed:@"publish_image_default"];
    
    self.keys = @[@"姓名",@"联系电话",@"户型",@"装修预算",@"房屋面积",@"风格",@"项目地址",@"小区名称",@"户型",@"户型图上传"];
    self.values = @[@"请填写您的姓名",@"必须是11位数字",@"两居室", @"必须是整数",@"必须是数字(平方米)",@"地中海",@"石家庄",@"2-32个汉字",@"三室一厅一卫",@"可选"];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = _headerView;
    
    _titleLabel1.transform = CGAffineTransformMakeRotation(-M_PI/3.2);
    _titleLabel2.transform = CGAffineTransformMakeRotation(-M_PI/3.2);
    _titleLabel3.transform = CGAffineTransformMakeRotation(-M_PI/3.2);
    _titleLabel4.transform = CGAffineTransformMakeRotation(-M_PI/3.2);
    _titleLabel5.transform = CGAffineTransformMakeRotation(-M_PI/3.2);
}

- (void)onSubmit{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_keys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 9) {
        return 70;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = [_keys objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_values objectAtIndex:indexPath.row];
    if (indexPath.row == 9) {
//        cell.detailTextLabel.text = @"可选";
        [_photoImageView removeFromSuperview];
        [cell addSubview:_photoImageView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
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
