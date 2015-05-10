//
//  ProductCategaryViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/5/7.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductCategaryViewController.h"
#import "ProductFilterData.h"
#import "ProductCatgeryCell.h"

static NSString *CellIdentifier = @"ProductCatgeryCell";

@interface ProductCategaryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableVIew;
@property (strong, nonatomic) NSMutableArray *treeCatgatery;
@end

@implementation ProductCategaryViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"类目";
    _tableVIew.sectionHeaderHeight = 38;
    _tableVIew.sectionFooterHeight = 1;
    [_tableVIew registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    if (_selectedFilter.isInShop)
        _treeCatgatery = [self CreateCategoryTreeByParentId:-1];
    else
        _treeCatgatery = [self CreateCategoryTreeByParentCode:@"-1"];
    
    ProductCategory *all = [[ProductCategory alloc]init];
    all.name = @"全部";
    all.catName = @"全部";
    all.Id = -100;
    all.parentId = -99;
    all.shopId = _selectedFilter.shopId;
    all.depth = 0;
    all.catCode = nil;
    all.parentCode = nil;
    all.urlContent = nil;
    all.childList = [[NSMutableArray alloc]init];
    [_treeCatgatery insertObject:all atIndex:0];
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

- (ProductCategory *)CreateAllCat:(ProductCategory *)parentCat {
    ProductCategory *all = [[ProductCategory alloc]init];
    all.name = @"全部";
    all.catName = @"全部";
    all.Id = parentCat.Id;
    all.parentId = parentCat.parentId;
    all.shopId = _selectedFilter.shopId;
    all.depth = parentCat.depth;
    all.catCode = parentCat.catCode;
    all.parentCode = parentCat.parentCode;
    all.urlContent = parentCat.urlContent;
    all.childList = [[NSMutableArray alloc]init];
    return all;
}

- (NSMutableArray *)CreateCategoryTreeByParentCode:(NSString *)parentCode {
    NSMutableArray *relArry = [[NSMutableArray alloc]init];
    for (NSObject *obj in _filterData.categoryList) {
        ProductCategory *cat = (ProductCategory *)obj;
        if ([cat.parentCode isEqual:parentCode]) {
            [relArry addObject:cat];
            cat.childList = [self CreateCategoryTreeByParentCode:cat.catCode];
            if (cat.childList.count>0) {
                [cat.childList insertObject:[self CreateAllCat:cat] atIndex:0];
            }
        }
    }
    return relArry;
}

- (NSMutableArray *)CreateCategoryTreeByParentId:(long)parentId {
    NSMutableArray *relArry = [[NSMutableArray alloc]init];
    for (NSObject *obj in _filterData.categoryList) {
        ProductCategory *cat = (ProductCategory *)obj;
        if (cat.parentId == parentId) {
            [relArry addObject:cat];
            cat.childList = [self CreateCategoryTreeByParentId:cat.Id];
            if (cat.childList.count>0) {
                [cat.childList insertObject:[self CreateAllCat:cat] atIndex:0];
            }
        }
    }
    return relArry;
}

//- (NSMutableArray *)getCatgaryListByParentId:(long)parentId {
//    NSMutableArray *relArry = [[NSMutableArray alloc]init];
//    for (NSObject *obj in _filterData.categoryList) {
//        ProductCategory *cat = (ProductCategory *)obj;
//        if (cat.parentId == parentId) {
//            [relArry addObject:cat];
//        }
//    }
//    return relArry;
//}
//
//- (NSMutableArray *)getCatgaryListByParentCode:(NSString *)parentCode {
//    NSMutableArray *relArry = [[NSMutableArray alloc]init];
//    for (NSObject *obj in _filterData.categoryList) {
//        ProductCategory *cat = (ProductCategory *)obj;
//        if ([cat.parentCode isEqual:parentCode]) {
//            [relArry addObject:cat];
//        }
//    }
//    return relArry;
//}

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

- (ProductCategory *)getFstCat:(int)index {
    ProductCategory *fCat = _treeCatgatery[index];
    return fCat;
}

- (ProductCategory *)getSecCat:(int)index1 :(int)index2 {
    ProductCategory *fCat = _treeCatgatery[index1];
    ProductCategory *sCat = fCat.childList[index2];
    return sCat;
}

- (ProductCategory *)getTrdCat:(int)index1 :(int)index2 :(int)index3 {
    ProductCategory *fCat = _treeCatgatery[index1];
    ProductCategory *sCat = fCat.childList[index2];
    ProductCategory *tCat = sCat.childList[index3];
    return tCat;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _treeCatgatery.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *secList = [_treeCatgatery[section] childList] ;
    return [_treeCatgatery[section] isOpen] ? secList.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_treeCatgatery[indexPath.section] isOpen] && [[self getSecCat:indexPath.section :indexPath.row] isOpen]) {
        return 38 + (ceilf([[[self getSecCat:indexPath.section :indexPath.row] childList] count])+1)/3 * 35;
    }else
        return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //ProductCatgeryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ProductCatgeryCell *cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    cell.backgroundColor = RGBColor(247, 247, 247);
    ProductCategory *cat =[self getSecCat:indexPath.section :indexPath.row];
    if (_selectedFilter.isInShop) {
        cell.labelTitle.text = cat.name;
    }else{
        cell.labelTitle.text = cat.catName;
    }
    if (cat.isOpen) {
        cell.labelTitle.textColor = kBlueColor;
    }else {
        cell.labelTitle.textColor = [UIColor darkTextColor];
    }
    if([_treeCatgatery[indexPath.section] isOpen] && [[self getSecCat:indexPath.section :indexPath.row] isOpen]) {
        for (int i = 0; i<cat.childList.count; i++) {
            ProductCategory *trdCat = [self getTrdCat:indexPath.section :indexPath.row :i];
            CatButton *btn = [CatButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15+100*(i%3), 38+i/3*35, 90, 30);
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            if (_selectedFilter.isInShop) {
                [btn setTitle:trdCat.name forState:UIControlStateNormal];
            }else {
                [btn setTitle:trdCat.catName forState:UIControlStateNormal];
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            btn.category = trdCat;
            [btn addTarget:self action:@selector(onTrdCatgary:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 38+(ceilf([[[self getSecCat:indexPath.section :indexPath.row] childList] count])+1)/3 * 35-0.5, 290, 0.5f)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:lineView];
        }
    }else {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.bounds.size.height-0.5f, 290, 0.5f)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:lineView];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 320, 38);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = 2000+section;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    ProductCategory *cat = _treeCatgatery[section];
    if (cat.isOpen) {
        [btn setTitleColor:kBlueColor forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }
    if (_selectedFilter.isInShop) {
        [btn setTitle:cat.name forState:UIControlStateNormal];
    }else {
        [btn setTitle:cat.catName forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(onHeader:) forControlEvents:UIControlEventTouchUpInside];
    //    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5f)];
    //    lineView.backgroundColor = [UIColor lightGrayColor];
    //    [btn addSubview:lineView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 37.5f, 320, 0.5f)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [btn addSubview:lineView];
    return btn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductCategory *cat = [self getSecCat:indexPath.section :indexPath.row];
    
    if(cat.childList && cat.childList.count>0) {
        cat.isOpen = !cat.isOpen;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[tableView reloadData];
    }else {
        _selectedFilter.pCategory = cat;
        [self commit];
    }
}

- (void)onHeader:(id)sender {
    UIButton *btn = (UIButton *)sender;
    ProductCategory *cat = _treeCatgatery[btn.tag-2000];
    if (cat.childList && cat.childList.count>0) {
        cat.isOpen = !cat.isOpen;
        [_tableVIew reloadSections:[NSIndexSet indexSetWithIndex:btn.tag-2000] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)onTrdCatgary:(id)sender {
    CatButton *btn = (CatButton *)sender;
    _selectedFilter.pCategory = btn.category;
    [self commit];
}
@end

@implementation CatButton

@end
