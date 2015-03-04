//
//  OrderFilterViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/2/23.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderFilterViewController.h"

@interface OrderFilterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *orderStatuses;
@property (nonatomic, strong) NSArray *orderTimes;

@end

@implementation OrderFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"筛选";
    
    self.orderStatuses = [[DefaultData sharedData] objectForKey:_isDesigner ? @"orderDesignerStatus" : @"orderStatus"];
    self.orderTimes = [[DefaultData sharedData] objectForKey:@"orderTime"];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [self.view addSubview:_tableView];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 50, 30) target:self action:@selector(back:) title:@"取消" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_orderStatuses count];
    }
    
    return [_orderTimes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    headerView.backgroundColor = RGBColor(202, 202, 202);
    UILabel *titleLabel = [headerView labelWithFrame:CGRectMake(10, 0, 300, 30) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    titleLabel.text = section == 0 ? @"订单状态" : @"创建订单时间";
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _orderStatuses[indexPath.row][@"k"];
    }else if (indexPath.section == 1){
        cell.textLabel.text = _orderTimes[indexPath.row][@"k"];
    }
    
    if ((indexPath.section == 0 && indexPath.row == [[_selecteds objectAtTheIndex:0] integerValue]) || (indexPath.section == 1 && indexPath.row == [[_selecteds objectAtTheIndex:1] integerValue])) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_selecteds replaceObjectAtIndex:indexPath.section withObject:@(indexPath.row)];
    [_tableView reloadData];
}

- (IBAction)onDone:(id)sender{
    if ([_delegate respondsToSelector:@selector(clickOrderFilterViewReturnData:)]) {
        [_delegate clickOrderFilterViewReturnData:_selecteds];
    }
    
    [super back:sender];
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
