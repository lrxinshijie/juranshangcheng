//
//  ProductCategaryViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/5/7.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductCategaryViewController.h"
#import "ProductFilterData.h"

@interface ProductCategaryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableVIew;
@property (strong, nonatomic) NSMutableArray *fCatgatery;
@end

@implementation ProductCategaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableVIew.sectionHeaderHeight = 44;
    _tableVIew.sectionFooterHeight = 1;
    _fCatgatery = [self getCatgaryListByDepth:1];
    ProductCategory *all = [[ProductCategory alloc]init];
    all.name = @"全部";
    all.catName = @"全部";
    all.Id = -100;
    all.parentId = -99;
    all.shopId = _selectedFilter.shopId;
    all.depth = 0;
    all.catCode = @"all";
    all.parentCode = nil;
    all.urlContent = nil;
    [_fCatgatery insertObject:all atIndex:0];
    for (NSObject *obj in _fCatgatery) {
        ProductCategory *fCat = (ProductCategory *)obj;
        fCat.childList = [self getCatgaryListByParentId:fCat.Id];
        if (fCat.childList.count!=0) {
            for (NSObject *o in fCat.childList) {
                ProductCategory *sCat = (ProductCategory *)o;
                sCat.childList = [self getCatgaryListByParentId:sCat.Id];
            }
        }
    }
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

- (NSMutableArray *)getCatgaryListByDepth:(int)depth {
    NSMutableArray *relArry = [[NSMutableArray alloc]init];
    for (NSObject *obj in _filterData.categoryList) {
        ProductCategory *cat = (ProductCategory *)obj;
        if (cat.depth == depth) {
            [relArry addObject:cat];
        }
    }
    return relArry;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _fCatgatery.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    long parentId =[[_fCatgatery objectAtIndex:section] Id];
    int count = [[self getCatgaryListByParentId:parentId] count];
    ASLog(@"count=%d",count);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        long parentId =[[_fCatgatery objectAtIndex:indexPath.section] Id];
        ProductCategory *cat = [[self getCatgaryListByParentId:parentId] objectAtIndex:indexPath.row];
        if (_selectedFilter.isInShop) {
            cell.textLabel.text = cat.name;
        }else{
            cell.textLabel.text = cat.catName;
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 320, 44);
    btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    btn.tag = 2000+section;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    ProductCategory *cat = [_fCatgatery objectAtIndex:section];
    if (_selectedFilter.isInShop) {
        [btn setTitle:cat.name forState:UIControlStateNormal];
    }else {
        [btn setTitle:cat.catName forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(onHeader:) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5f)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [btn addSubview:lineView];
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5f, 320, 0.5f)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [btn addSubview:lineView];
    return btn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)onHeader:(id)sender {
    ASLog(@"Click");
}
@end
