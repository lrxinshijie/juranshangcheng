//
//  ProductFilterViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/5/6.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductFilterViewController.h"
#import "ProductFilterData.h"
#import "ProductCategaryViewController.h"
#import "ProductBrandViewController.h"
#import "ProductClassViewController.h"
#import "ProductAttributeViewController.h"

@interface ProductFilterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *conditionArray;
@property (nonatomic, strong) NSMutableArray *detailArray;
@end

@implementation ProductFilterViewController

- (instancetype)initWithKeyword:(NSString *)keyword
                           Sort:(int)sort
                          Store:(ProductStore *)store
                       IsInShop:(BOOL)isInShop
{
    self = [super init];
    if (self) {
        self.selectedFilter = [[ProductSelectedFilter alloc]init];
        self.selectedFilter.keyword = keyword;
        self.selectedFilter.isInShop = isInShop;
        self.selectedFilter.sort = sort;
        self.selectedFilter.pStore = store;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"筛选";
    _tableView.tableFooterView = [[UIView alloc]init];
    _filterData = [[ProductFilterData alloc]init];
    [self loadData];
}

- (void)loadData {
    [self showHUD];
    _selectedFilter.shopId = 17;
    [_filterData loadFilterDataWithFilter:_selectedFilter Handler:^(BOOL result) {
        [self hideHUD];
        if (result) {
            if (_filterData.categoryList && _filterData.categoryList.count>0) {
                self.conditionArray = [NSMutableArray arrayWithArray:@[@"类目"]];
                if (_selectedFilter.isInShop) {
                    self.detailArray = [NSMutableArray arrayWithArray:@[_selectedFilter.pCategory ? _selectedFilter.pCategory.name:@""]];
                }else {
                    self.detailArray = [NSMutableArray arrayWithArray:@[_selectedFilter.pCategory ? _selectedFilter.pCategory.catName:@""]];
                }
            }else {
                _selectedFilter.pCategory = nil;
            }
            
            if (_filterData.classList && _filterData.classList.count>0) {
                [_conditionArray addObject:@"类别"];
                [_detailArray addObject:_selectedFilter.pClass ? _selectedFilter.pClass.className:@""];
            }else {
                _selectedFilter.pClass = nil;
            }
            
            if (_filterData.brandList && _filterData.brandList.count>0) {
                [_conditionArray addObject:@"品牌"];
                [_detailArray addObject:_selectedFilter.pBrand ? _selectedFilter.pBrand.brandName:@""];
            }else {
                _selectedFilter.pBrand=nil;
            }
            
            if (_filterData.attributeList && _filterData.attributeList.count>0) {
                for (NSObject *obj in _filterData.attributeList) {
                    ProductAttribute *attr = (ProductAttribute *)obj;
                    [_conditionArray addObject:attr.attName];
                    [_detailArray addObject:_selectedFilter.pAttributeDict.count>0 ? [_selectedFilter.pAttributeDict objectForKey:attr.attId]:@""];
                }
            }else {
                _selectedFilter.pAttributeDict = [[NSMutableDictionary alloc]init];
            }
            [_tableView reloadData];
        }
    }];
}

- (void)relaodVIew {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _conditionArray.count;
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
    NSString *filterName = [_conditionArray objectAtIndex:indexPath.row];
    if ([filterName  isEqual: @"价格"]) {
        cell.textLabel.text = filterName;
    }else {
        cell.textLabel.text = filterName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.text = _detailArray[indexPath.row] ? _detailArray[indexPath.row]:@"";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_conditionArray[indexPath.row] isEqual:@"类目"]) {
        ProductCategaryViewController *vc = [[ProductCategaryViewController alloc]init];
        vc.navigationItem.title = [NSString stringWithFormat:@"%@",[_conditionArray objectAtIndex:[indexPath row]]];
        vc.filterData = _filterData;
        vc.selectedFilter = _selectedFilter;
        [vc setBlock:^(ProductSelectedFilter *filter) {
            [self loadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([_conditionArray[indexPath.row] isEqual:@"品牌"]) {
        ProductBrandViewController *vc = [[ProductBrandViewController alloc]init];
        vc.navigationItem.title = [NSString stringWithFormat:@"%@",[_conditionArray objectAtIndex:[indexPath row]]];
        vc.filterData = _filterData;
        vc.selectedFilter = _selectedFilter;
        [vc setBlock:^(ProductSelectedFilter *filter) {
            [self loadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([_conditionArray[indexPath.row] isEqual:@"类别"]) {
        ProductClassViewController *vc = [[ProductClassViewController alloc]init];
        vc.navigationItem.title = [NSString stringWithFormat:@"%@",[_conditionArray objectAtIndex:[indexPath row]]];
        vc.filterData = _filterData;
        vc.selectedFilter = _selectedFilter;
        [vc setBlock:^(ProductSelectedFilter *filter) {
            [self loadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        for (NSObject *obj in _filterData.attributeList) {
            ProductAttribute *attr = (ProductAttribute *)obj;
            if ([_conditionArray[indexPath.row] isEqual:attr.attName]) {
                ProductAttributeViewController *vc = [[ProductAttributeViewController alloc]init];
                vc.navigationItem.title = attr.attName;
                vc.currentAttr = attr;
                vc.filterData = _filterData;
                vc.selectedFilter = _selectedFilter;
                [vc setBlock:^(ProductSelectedFilter *filter) {
                    [self loadData];
                }];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            
        }
    }
}
@end

@implementation ProductSelectedFilter
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pAttributeDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}
@end
