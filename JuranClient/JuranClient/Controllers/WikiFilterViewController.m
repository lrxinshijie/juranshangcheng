//
//  WikiFilterViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/17.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "WikiFilterViewController.h"

@interface WikiFilterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSDictionary *selected;
@property (nonatomic, strong) NSMutableDictionary *openDic;

- (IBAction)onDone:(id)sender;

@end

@implementation WikiFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"筛选";
    
    self.openDic = [NSMutableDictionary dictionary];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 50, 30) target:self action:@selector(onCancel) title:@"取消" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    //    _tableView.backgroundColor = RGBColor(202, 202, 202);
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
//    view.backgroundColor = RGBColor(202, 202, 202);
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    [_tableView headerBeginRefreshing];
}


- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": kOnePageCount};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_CATEGORE_LISTREQ parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSMutableArray *rows = nil;
            if ([data[@"categoryList"] isKindOfClass:[NSArray class]]) {
                rows = [NSMutableArray arrayWithArray:data[@"categoryList"]];
            }
            
            if (_currentPage > 1) {
                [_sections addObjectsFromArray:rows];
            }else{
                self.sections = rows;
                NSDictionary *dic = rows[0];
                [self.sections addObjectsFromArray:dic[@"children"]];
            }
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = _sections[section];
    if ([_openDic objectForKey:dic[@"catId"]]) {
        NSArray *rows = dic[@"children"];
        return [rows count];
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    headerView.backgroundColor = RGBColor(202, 202, 202);
    UILabel *titleLabel = [headerView labelWithFrame:CGRectMake(10, 0, 300, 30) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    NSDictionary *dic = _sections[section];
    titleLabel.text = dic[@"catName"];
    [headerView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, kWindowWidth, 0.5)];
    line.backgroundColor = RGBColor(243, 243, 243);
    [headerView addSubview:line];
    
    UIButton *btn = [headerView buttonWithFrame:headerView.bounds target:self action:@selector(onSeleted:) image:nil];
    btn.tag = section;
    [headerView addSubview:btn];
    
    if (_selected) {
        if ([_selected[@"type"] isEqualToString:dic[@"catCode"]]) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_filter_selected.png"]];
            imageView.center = CGPointMake(CGRectGetWidth(headerView.frame) - CGRectGetWidth(imageView.frame)/2 - 15, headerView.center.y);
            [headerView addSubview:imageView];
        }
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.accessoryView = nil;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    NSDictionary *dic = _sections[indexPath.section];
    NSArray *rows = dic[@"children"];
    NSDictionary *childDic = rows[indexPath.row];
    cell.textLabel.text = childDic[@"catName"];
    
    if (_selected) {
        if ([_selected[@"type"] isEqualToString:childDic[@"catCode"]]) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_filter_selected.png"]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = _sections[indexPath.section];
    NSArray *rows = dic[@"children"];
    NSDictionary *childDic = rows[indexPath.row];
    if ([_selected[@"type"] isEqualToString:childDic[@"catCode"]]) {
        _selected = nil;
    }else{
        _selected = @{@"type":childDic[@"catCode"]};
    }
    [_tableView reloadData];
}

- (void)onCancel{
    [super back:nil];
}

- (IBAction)onDone:(id)sender{
    
    if ([_delegate respondsToSelector:@selector(clickWikiFilterViewReturnData:)]) {
        [_delegate clickWikiFilterViewReturnData:_selected];
    }
    
    [super back:nil];
}

- (void)onSeleted:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dic = _sections[btn.tag];
    NSArray *rows = dic[@"children"];

    if (![rows isKindOfClass:[NSNull class]] && rows.count > 0){
        if ([_openDic objectForKey:dic[@"catId"]]) {
            [_openDic removeObjectForKey:dic[@"catId"]];
        }else{
            [_openDic addEntriesFromDictionary:@{dic[@"catId"]:@""}];
        }
    }
    /*else{
        if ([_selected[@"type"] isEqualToString:dic[@"catCode"]]) {
            _selected = nil;
        }else{
            _selected = @{@"type":dic[@"catCode"]};
        }
    }*/
    [_tableView reloadData];
}

@end
