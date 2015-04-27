//
//  ConfirmItemViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/4/23.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ConfirmItemViewController.h"
#import "ConstructPriceListCell.h"
#import "TTTAttributedLabel.h"

@interface ConfirmItemViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sections;

@property (nonatomic, strong) NSMutableDictionary *openDictionary;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *footerView;

@end

@implementation ConfirmItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"确认增减项";
    
    self.sections = @[@"拆除工程", @"墙面工程", @"门窗工程"];
    self.openDictionary = [NSMutableDictionary dictionary];
    [self setupUI];

}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = _footerView;
    _tableView.tableHeaderView = _headerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:_tableView];
}

- (void)reloadData{
    [_tableView reloadData];
}

- (void)onShow:(id)sender{
    UIButton *btn = (UIButton*)sender;
    BOOL flag = [_openDictionary getBoolValueForKey:[NSString stringWithFormat:@"%d", btn.tag - 1100] defaultValue:YES];
    [_openDictionary setValue:[NSString stringWithFormat:@"%d", !flag] forKey:[NSString stringWithFormat:@"%d", btn.tag - 1100]];
    [self reloadData];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 1;
    }else{
        if (![_openDictionary getBoolValueForKey:[NSString stringWithFormat:@"%d", section] defaultValue:YES]) {
            return 0;
        }
        return 3;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    headerView.backgroundColor = RGBColor(231, 231, 231);
    
    UIButton *btn = [headerView buttonWithFrame:headerView.bounds target:self action:@selector(onShow:) image:nil];
    btn.tag = 1100+section;
    [headerView addSubview:btn];
    
    UILabel *label = [headerView labelWithFrame:CGRectMake(15, 0, 80, 30) text:_sections[section] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    [headerView addSubview:label];
    label = [headerView labelWithFrame:CGRectMake(110, 0, 150, 30) text:@"小计：1000" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    [headerView addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_openDictionary getBoolValueForKey:[NSString stringWithFormat:@"%d", section] defaultValue:YES]?@"arrow_up.png":@"arrow_down.png"]];
    imageView.center = CGPointMake(kWindowWidth - 10 - CGRectGetWidth(imageView.frame), CGRectGetHeight(headerView.frame)/2.f);
    [headerView addSubview:imageView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
    }
    return [ConstructPriceListCell cellHeightWithValue:nil isHead:indexPath.row == 0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return .5f;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ConstructPriceListCell";
    ConstructPriceListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (ConstructPriceListCell*)objs.firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 3) {
    }else{
        [cell fillCellWithValue:nil isHead:indexPath.row == 0];
    }
    return cell;
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
