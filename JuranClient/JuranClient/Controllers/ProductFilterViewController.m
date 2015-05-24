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
#import "AppDelegate.h"
#import "UserLocation.h"
#import "ProductSeletedFilter.h"

@interface ProductFilterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *priceCell;
@property (strong, nonatomic) IBOutlet UITextField *textFieldMinPrice;
@property (strong, nonatomic) IBOutlet UITextField *textFieldMaxPrice;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (nonatomic, strong) NSMutableArray *conditionArray;
@property (nonatomic, strong) NSMutableArray *detailArray;
- (IBAction)onClear:(id)sender;
@end

@implementation ProductFilterViewController {
    NSString *catTreeString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"筛选";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onDone:)];
    [right setTintColor:[UIColor darkTextColor]];
    self.navigationItem.rightBarButtonItem = right;
    //_tableView.tableFooterView = [[UIView alloc]init];
    _clearButton.layer.borderWidth = 0.5f;
    _clearButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _clearButton.layer.cornerRadius = 1;
    _tableView.tableFooterView = _footerView;
    _filterData = [[ProductFilterData alloc]init];
    [self loadData];
}

- (void)loadData {
    [self showHUD];
    [_filterData loadFilterDataWithFilter:_selectedFilter
                                  Handler:^(BOOL result) {
                                      [self hideHUD];
                                      if (result) {
                                          [self reloadView];
                                      }
                                  }];
}

- (void)reloadView {
    if (_filterData.categoryList && _filterData.categoryList.count>0) {
        self.conditionArray = [NSMutableArray arrayWithArray:@[@"类目"]];
        if (_selectedFilter.isInShop) {
            catTreeString = _selectedFilter.pCategory.name;
        }else {
            catTreeString = _selectedFilter.pCategory.catName;
        }
        [self getParentCatTreeString:_selectedFilter.pCategory];
        self.detailArray = [NSMutableArray arrayWithArray:@[_selectedFilter.pCategory ? catTreeString:@""]];
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
    
    if (_selectedFilter.pCategory && ApplicationDelegate.gLocation.isSuccessLocation) {
        [_conditionArray addObject:@"价格(元)"];
        [_detailArray addObject:@""];
    }else {
        //_selectedFilter.pBrand=nil;
        _selectedFilter.pMinPrice = 0;
        _selectedFilter.pMaxPrice = 0;
    }
    
    if (_filterData.attributeList && _filterData.attributeList.count>0) {
        for (NSObject *obj in _filterData.attributeList) {
            ProductAttribute *attr = (ProductAttribute *)obj;
            [_conditionArray addObject:attr.attName];
            [_detailArray addObject:[_selectedFilter.pAttributeDict objectForKey:attr.attId] ? [_selectedFilter.pAttributeDict objectForKey:attr.attId]:@""];
        }
    }else {
        _selectedFilter.pAttributeDict = [[NSMutableDictionary alloc]init];
    }
    [_tableView reloadData];
}

- (void)getParentCatTreeString:(ProductCategory *)category {
    for (NSObject *obj in _filterData.categoryList) {
        ProductCategory *cat = (ProductCategory *)obj;
        if(_selectedFilter.isInShop) {
            if(category.parentId == cat.Id) {
                catTreeString = [NSString stringWithFormat:@"%@ %@",cat.name,catTreeString];
                [self getParentCatTreeString:cat];
            }
        }else {
            if ([category.parentCode isEqual:cat.catCode]) {
                catTreeString = [NSString stringWithFormat:@"%@ %@",cat.catName,catTreeString];
                [self getParentCatTreeString:cat];
            }
        }
    }
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
    if ([filterName  isEqual: @"价格(元)"]) {
        cell = _priceCell;
        cell.textLabel.text = filterName;
        _textFieldMinPrice.text =_selectedFilter.pMinPrice>0 ? [NSString stringWithFormat:@"%ld",_selectedFilter.pMinPrice] : @"";
        _textFieldMaxPrice.text =_selectedFilter.pMaxPrice>0 ? [NSString stringWithFormat:@"%ld",_selectedFilter.pMaxPrice] : @"";
    }else {
        cell.textLabel.text = filterName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.text = _detailArray[indexPath.row] ? _detailArray[indexPath.row]:@"";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 60;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    _clearButton.layer.borderWidth = 0.5f;
//    _clearButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    _clearButton.layer.cornerRadius = 1;
//    return _footerView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                    [self reloadView];
                }];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            
        }
    }
}


- (void)onDone:(id)sender {
    _selectedFilter.pMinPrice = _textFieldMinPrice.text.integerValue;
    _selectedFilter.pMaxPrice = _textFieldMaxPrice.text.integerValue;
    [self commit];
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

- (IBAction)onClear:(id)sender {
    _selectedFilter.pCategory = nil;
    _selectedFilter.pClass = nil;
    _selectedFilter.pBrand = nil;
    _selectedFilter.pMinPrice = 0;
    _selectedFilter.pMaxPrice = 0;
    _selectedFilter.pAttributeDict = [[NSMutableDictionary alloc]init];
    [self loadData];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end

//@implementation ProductSelectedFilter
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _pAttributeDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    }
//    return self;
//}
//@end
