//
//  ProductClassViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/5/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductClassViewController.h"
#import "ProductFilterData.h"

@interface ProductClassViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ProductClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"类别";
    _tableView.tableFooterView = [[UIView alloc]init];
    //[_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBlock:(FilterSelected)block {
    _block = block;
}

- (void)commit {
    if (_block) {
        _block(_selectedFilter);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _filterData.classList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_filterData.classList[indexPath.row] className];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedFilter.pClass = _filterData.classList[indexPath.row];
    [self commit];
}
@end
