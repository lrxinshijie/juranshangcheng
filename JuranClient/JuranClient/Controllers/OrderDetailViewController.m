//
//  OrderDetailViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/2/8.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *paymentInfoView;
@property (nonatomic, strong) IBOutlet UIView *deliveryInfoView;
@property (nonatomic, strong) IBOutlet UIView *consumerInfoView;
@property (nonatomic, strong) IBOutlet UIView *designerInfoView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"订单详情";
    
    self.keys = @[@[@"",@""], @[@"", @"手机号码", @"电子邮箱", @"微信号"], @[@"", @"手机号码", @"电子邮箱", @"会员卡号", @"微信号", @"户型", @"面积", @"装修地址"]];
    self.type = 1;
    [self resetValues];
    [self setupUI];
    [self reloadData];
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)reloadData{
    [self resetValues];
    [_tableView reloadData];
}

- (void)resetValues{
    self.values = @[@[@"",@""], @[@"", @"15812223444", @"sunyu528@qq.com", @"15812223444"], @[@"", @"15812223444", @"sunyu528@qq.com", @"34225352", @"15812223444", @"2室1厅1卫", @"78m2", @"北京市东城区东直门南大街甲三号XX小区XX楼301室"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource/UITableViewDelegate BEGIN

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = _keys[section];
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return _type == 0?75:185;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        return _type == 0?90:160;
    }else if (indexPath.row == 0 && (indexPath.section == 1 || indexPath.section == 2)){
        return 70;
    }else{
        return 40;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"personalData";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.clipsToBounds = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = @"";
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    UIView *view = [cell.contentView viewWithTag:5555];
    if (view) {
        [view removeFromSuperview];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell.contentView addSubview:_paymentInfoView];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        [cell.contentView addSubview:_deliveryInfoView];
    }else if (indexPath.row == 0 && indexPath.section == 1){
        [cell.contentView addSubview:_designerInfoView];
    }else if (indexPath.row == 0 && indexPath.section == 2){
        [cell.contentView addSubview:_consumerInfoView];
    }else{
        cell.textLabel.text = _keys[indexPath.section][indexPath.row];
        cell.detailTextLabel.text = _values[indexPath.section][indexPath.row];
    }
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


#pragma mark - UITableViewDataSource/UITableViewDelegate END

@end
