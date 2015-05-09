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
@property (strong, nonatomic) NSMutableArray *topCatgatery;
//@property (strong, nonatomic) NSMutableArray *openStatusList;
@end

@implementation ProductCategaryViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableVIew.sectionHeaderHeight = 44;
    _tableVIew.sectionFooterHeight = 1;
    [_tableVIew registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    if (_selectedFilter.isInShop) {
        _topCatgatery = [self getCatgaryListByDepth:1];
    }else {
        _topCatgatery = [self getCatgaryListByParentCode:@"-1"];
    }
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
    [_topCatgatery insertObject:all atIndex:0];
    
    for (NSObject *obj in _topCatgatery) {
        ProductCategory *fCat = (ProductCategory *)obj;
        if (_selectedFilter.isInShop) {
            fCat.childList = [self getCatgaryListByParentId:fCat.Id];
        }else {
            fCat.childList = [self getCatgaryListByParentCode:fCat.catCode];
        }
        
        
        for (NSObject *o in fCat.childList) {
            ProductCategory *sCat = (ProductCategory *)o;
            sCat.childList = [self getCatgaryListByParentCode:sCat.catCode];
        }
        
    }
    
    for (NSObject *obj in _topCatgatery) {
        ProductCategory *fCat =(ProductCategory *)obj;
        if (fCat.childList && fCat.childList.count>0) {
            all = [[ProductCategory alloc]init];
            all.name = @"全部";
            all.catName = @"全部";
            all.Id = fCat.Id;
            all.parentId = fCat.parentId;
            all.shopId = _selectedFilter.shopId;
            all.depth = fCat.depth;
            all.catCode = fCat.catCode;
            all.parentCode = fCat.parentCode;
            all.urlContent = fCat.urlContent;
            [fCat.childList insertObject:all atIndex:0];
        }
        for (NSObject *o in fCat.childList) {
            ProductCategory *sCat =(ProductCategory *)o;
            if (sCat.childList && sCat.childList.count>0) {
                all = [[ProductCategory alloc]init];
                all.name = @"全部";
                all.catName = @"全部";
                all.Id = sCat.Id;
                all.parentId = sCat.parentId;
                all.shopId = _selectedFilter.shopId;
                all.depth = sCat.depth;
                all.catCode = sCat.catCode;
                all.parentCode = sCat.parentCode;
                all.urlContent = sCat.urlContent;
                [sCat.childList insertObject:all atIndex:0];
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

- (NSMutableArray *)getCatgaryListByParentCode:(NSString *)parentCode {
    NSMutableArray *relArry = [[NSMutableArray alloc]init];
    for (NSObject *obj in _filterData.categoryList) {
        ProductCategory *cat = (ProductCategory *)obj;
        if ([cat.parentCode isEqual:parentCode]) {
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
    return _topCatgatery.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [[_topCatgatery[section] childList] count];
    return [_topCatgatery[section] isOpen] ? count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_topCatgatery[indexPath.section] isOpen] && [[_topCatgatery[indexPath.section] childList][indexPath.row] isOpen]) {
        return 100;
    }else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //ProductCatgeryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ProductCatgeryCell *cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    
    ProductCategory *cat =[[_topCatgatery[indexPath.section] childList] objectAtIndex:indexPath.row];
    if (_selectedFilter.isInShop) {
        cell.labelTitle.text = cat.name;
    }else{
        cell.labelTitle.text = cat.catName;
    }
    if([_topCatgatery[indexPath.section] isOpen] && [[_topCatgatery[indexPath.section] childList][indexPath.row] isOpen]) {
        for (int i = 0; i<cat.childList.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15+100*(i%3), 50+i/3*5, 90, 30);
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            if (_selectedFilter.isInShop) {
                [btn setTitle:[cat.childList[indexPath.row] name] forState:UIControlStateNormal];
            }else {
                [btn setTitle:[cat.childList[indexPath.row] catName] forState:UIControlStateNormal];
            }
            [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [cell addSubview:btn];
        }
    }else {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5f, 320, 0.5f)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:lineView];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 320, 44);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = 2000+section;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    ProductCategory *cat = [_topCatgatery objectAtIndex:section];
    if (_selectedFilter.isInShop) {
        [btn setTitle:cat.name forState:UIControlStateNormal];
    }else {
        [btn setTitle:cat.catName forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(onHeader:) forControlEvents:UIControlEventTouchUpInside];
    //    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5f)];
    //    lineView.backgroundColor = [UIColor lightGrayColor];
    //    [btn addSubview:lineView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5f, 320, 0.5f)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [btn addSubview:lineView];
    return btn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductCategory *cat = [_topCatgatery[indexPath.section] childList][indexPath.row];
    
    if(cat.childList && cat.childList.count>0) {
        cat.isOpen = !cat.isOpen;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        //[tableView reloadData];
    }
}

- (void)onHeader:(id)sender {
    UIButton *btn = (UIButton *)sender;
    ProductCategory *cat = _topCatgatery[btn.tag-2000];
    cat.isOpen = !cat.isOpen;
    [_tableVIew reloadSections:[NSIndexSet indexSetWithIndex:btn.tag-2000] withRowAnimation:UITableViewRowAnimationFade];
}
@end

@implementation CellOpenStatus : NSObject
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOpen = NO;
        self.childList = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
