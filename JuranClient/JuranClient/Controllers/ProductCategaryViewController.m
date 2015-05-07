//
//  ProductCategaryViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/5/7.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductCategaryViewController.h"
#import "ProductFilterData.h"

@interface ProductCategaryViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableVIew;
@end

@implementation ProductCategaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)getCatgaryListByParentId:(long)parentId {
    NSMutableArray *relArry = [[NSMutableArray alloc]init];
    for (NSObject *obj in _filterData.categoryList) {
        ProductCategory *cat = (ProductCategory *)obj;
        if (cat.parentId == parentId) {
            [relArry addObject:cat];
        }
    }
    return relArry;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self getCatgaryListByParentId:-1] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self getCatgaryListByParentId:_selectedFilter.pCategory.parentId] count];
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
    ProductCategory *cat = [[self getCatgaryListByParentId:-1] objectAtIndex:indexPath.row];
    cell.textLabel.text = cat.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ProductCategaryViewController *vc = [[ProductCategaryViewController alloc]init];
    vc.navigationItem.title = cell.textLabel.text;
    
    //cell
}
@end
