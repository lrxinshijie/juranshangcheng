//
//  FilterViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/7.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sections;

- (IBAction)onDone:(id)sender;

@end

@implementation FilterViewController

- (void)dealloc{
    _tableView.delegate = nil; _tableView.dataSource = nil; _tableView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"筛选";
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 50, 30) target:self action:@selector(onCancel) title:@"取消" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
//    _tableView.backgroundColor = RGBColor(202, 202, 202);
    _tableView.bounces = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    view.backgroundColor = RGBColor(202, 202, 202);
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *k = _sections[section][@"v"];
    NSArray *rows = [[DefaultData sharedData] objectForKey:k];
    return [rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    headerView.backgroundColor = RGBColor(202, 202, 202);
    UILabel *titleLabel = [headerView labelWithFrame:CGRectMake(10, 0, 300, 30) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    titleLabel.text = [self.sections[section] objectForKey:@"k"];
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
    NSString *k = _sections[indexPath.section][@"v"];
    NSArray *rows = [[DefaultData sharedData] objectForKey:k];
    cell.textLabel.text = rows[indexPath.row][@"k"];

    NSString *v = [_selecteds objectForKey:k];
    if ([v isEqualToString:rows[indexPath.row][@"v"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == [_sections count] - 1) {
//        return 20;
//    }
//    
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *k = self.sections[indexPath.section][@"v"];
    NSArray *rows = [[DefaultData sharedData] objectForKey:k];
    NSString *v = rows[indexPath.row][@"v"];

    if ([v isEqualToString:[_selecteds objectForKey:k]]) {
        v = @"";
    }
    
    [_selecteds setObject:v forKey:k];
    [_tableView reloadData];
}

- (void)onCancel{
    [super back:nil];
}

- (IBAction)onDone:(id)sender{
    
    if ([_delegate respondsToSelector:@selector(clickFilterViewReturnData:)]) {
        [_delegate clickFilterViewReturnData:_selecteds];
    }
    
    [super back:nil];
}

#pragma mark - DataSource
- (NSArray *)sections{
    if (!_sections) {
        switch (_type) {
            case FilterViewTypeCase:
                _sections = [[DefaultData sharedData] objectForKey:@"caseSection"];
                break;
            case FilterViewTypeCaseSearch:
                _sections = [[DefaultData sharedData] objectForKey:@"caseSearchSection"];
                break;
            case FilterViewTypeDesigner:
                _sections = [[DefaultData sharedData] objectForKey:@"designerSection"];
                break;
            case FilterViewTypeDesignerSearch:
                _sections = [[DefaultData sharedData] objectForKey:@"designerSearchSection"];
                break;
            default:
                break;
        }
    }
    
    return _sections;
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
