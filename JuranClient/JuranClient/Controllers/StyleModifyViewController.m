//
//  StyleModifyViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "StyleModifyViewController.h"
#import "JRDesigner.h"

@interface StyleModifyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) NSArray *styles;
@property (nonatomic, strong) NSMutableArray *selectedDic;

@end

@implementation StyleModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSave) title:@"保存" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    NSString *style = @"";
    self.selectedDic = [NSMutableArray array];
    if (_type == 0) {
        self.navigationItem.title = @"擅长风格";
        self.styles = [[DefaultData sharedData] objectForKey:@"style"];
        style = _designer.style;
    }else if (_type == 1){
        self.navigationItem.title = @"设计专长";
        self.styles = [[DefaultData sharedData] special];
        style = _designer.special;
    }
    
    NSArray *arr = [style componentsSeparatedByString:@","];
    for (NSString *str in arr) {
        if (str.length > 0) {
            for (NSDictionary *dic in _styles) {
                if ([str isEqualToString:dic[@"v"]]) {
                    [_selectedDic addObject:dic];
                }
            }
        }
    }
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableHeaderView = _tableHeaderView;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)onSave{
    NSString *style = @"";
    NSInteger i = 0;
    for (NSDictionary *dic in _selectedDic) {
        if (i == 0) {
            style = dic[@"v"];
        }else{
            style = [NSString stringWithFormat:@"%@,%@", style, dic[@"v"]];
        }
        i++;
    }
    if (_type == 0) {
        _designer.style = style;
    }else if (_type == 1){
        _designer.special = style;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _styles.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"personalDataMore";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _styles[indexPath.row];
    cell.textLabel.text = dic[@"k"];
    cell.textLabel.textColor = [UIColor blackColor];
    if ([_selectedDic containsObject:dic]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (_selectedDic.count == 5) {
            cell.textLabel.textColor = RGBColor(165, 165, 165);
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _styles[indexPath.row];
    if ([_selectedDic containsObject:dic]) {
        [_selectedDic removeObject:dic];
    }else{
        if (_selectedDic.count < 5) {
            [_selectedDic addObject:dic];
        }
    }
    [_tableView reloadData];
}

@end
