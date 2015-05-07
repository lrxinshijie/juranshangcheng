//
//  ProductFilterViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/5/6.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductFilterViewController.h"
#import "ProductFilterData.h"

@interface ProductFilterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ProductFilterData *filterData;
@end

@implementation ProductFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _filterData = [[ProductFilterData alloc]init];
    [_filterData loadFilterDataWithIsInShop:NO Sort:9 Keyword:@"" MinPrice:0 MaxPrice:0 Brands:nil Attributes:nil StoreCode:nil ShopId:0 ShopCategory:0 Handler:^(BOOL result) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    return cell;
}
@end
