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
@property (strong, nonatomic) NSMutableArray *dataList;
@end

@implementation ProductClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"类别";
    _tableView.tableFooterView = [[UIView alloc]init];
    _dataList = [NSMutableArray arrayWithArray:_filterData.classList];
    ProductClass *all = [[ProductClass alloc]init];
    all.classCode = @"-100";
    all.className = @"全部";
    [_dataList insertObject:all atIndex:0];
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
    return _dataList.count;
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
    cell.textLabel.text = [_dataList[indexPath.row] className];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[_dataList[indexPath.row] classCode] isEqual:@"-100"]) {
        _selectedFilter.pClass = nil;
    }else {
        _selectedFilter.pClass = _dataList[indexPath.row];
    }
    [self commit];
}
@end