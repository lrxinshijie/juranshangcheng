//
//  ContractViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/2/26.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ContractViewController.h"
#import "JROrder.h"
#import "TextFieldCell.h"

@interface ContractViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSMutableDictionary *hiddenSectionDic;

@end

@implementation ContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"创建设计合同";
    self.keys = @[@[@"量房合同编号", @"合同金额（元）", @"量房日期", @"待支付首款", @"尾款", @"设计工作内容"]
                  , @[@"真实姓名", @"用户名", @"手机号", @"微信号", @"会员卡号", @"电子邮箱", @"户型", @"面积", @"装修地址", @"小区名称"]
                  , @[@"真实姓名", @"用户名", @"手机号", @"微信号", @"电子邮箱", @"", @""]];
    self.values = @[];
    self.hiddenSectionDic = [NSMutableDictionary dictionary];
    
    [self setupUI];
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target Action

- (void)onHiddenSection:(id)sender{
    UIButton *btn = (UIButton*)sender;
    if (_hiddenSectionDic[[NSString stringWithFormat:@"%d", btn.tag]]) {
        [_hiddenSectionDic removeObjectForKey:[NSString stringWithFormat:@"%d", btn.tag]];
    }else{
        [_hiddenSectionDic addEntriesFromDictionary:@{[NSString stringWithFormat:@"%d", btn.tag]:@""}];
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = _keys[section];
    if (_hiddenSectionDic[[NSString stringWithFormat:@"%d", section]]) {
        return 0;
    }
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 35)];
    view.backgroundColor = RGBColor(226, 226, 226);
    
    UIButton *btn = [view buttonWithFrame:view.bounds target:self action:@selector(onHiddenSection:) image:nil];
    btn.tag = section;
    [view addSubview:btn];
    
    UILabel *label = [view labelWithFrame:CGRectMake(10, 5, 100, 15) text:@"" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    [view addSubview:label];
    
    if (section == 0) {
        label.text = @"合同信息";
    }else if (section == 1){
        label.text = @"消费者（甲方）";
    }else if (section == 2){
        label.text = @"设计师（乙方）";
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_hiddenSectionDic[[NSString stringWithFormat:@"%d", section]]?@"arrow_up.png":@"arrow_down.png"]];
    imageView.center = CGPointMake(kWindowWidth - 10 - CGRectGetWidth(imageView.frame), CGRectGetHeight(view.frame)/2.f);
    [view addSubview:imageView];
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && (indexPath.row == 1)) || (indexPath.section == 1 && indexPath.row != 6 && indexPath.row != 8) || (indexPath.section == 2)) {
        static NSString *CellIdentifier = @"TextFieldCell";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (TextFieldCell *)[nibs firstObject];
        }
        
        cell.titleLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        CGPoint center = cell.titleLabel.center;
        center.y = 18;
        cell.titleLabel.center = center;
        center = cell.textField.center;
        center.y = 18;
        cell.textField.center = center;
        cell.textField.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textField.enabled = YES;
        cell.textField.delegate = self;
//        cell.textField.tag = [_tags[indexPath.section][indexPath.row] integerValue];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text =  _keys[indexPath.section][indexPath.row];
        cell.textField.placeholder = @"请输入";
//        cell.textField.text = _values[indexPath.section][indexPath.row];
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        
        if (indexPath.section == 2 && (indexPath.row == 0 || indexPath.row == 2)) {
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"ContractCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _keys[indexPath.section][indexPath.row];
        cell.detailTextLabel.text = @"请选择";
        return cell;
    }
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
