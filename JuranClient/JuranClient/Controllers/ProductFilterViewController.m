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

@interface ProductFilterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ProductFilterData *filterData;
@property (nonatomic, strong) ProductSelectedFilter *selectedFilter;
@property (nonatomic, strong) NSMutableArray *conditionArray;
@end

@implementation ProductFilterViewController

- (instancetype)initWithKeyword:(NSString *)keyword
                       IsInShop:(BOOL)isInShop
{
    self = [super init];
    if (self) {
        self.selectedFilter.keyword = keyword;
        self.selectedFilter.isInShop = isInShop;
        self.selectedFilter.sort = 9;
        self.conditionArray = [NSMutableArray arrayWithArray:@[@"类目"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"筛选";
    _filterData = [[ProductFilterData alloc]init];
}

- (void)loadData {
    [self showHUD];
    [_filterData loadFilterDataWithFilter:_selectedFilter Handler:^(BOOL result) {
        [self hideHUD];
        if (result) {
            self.conditionArray = [NSMutableArray arrayWithArray:@[@"类目"]];
            if (_selectedFilter.pCategory && _selectedFilter.pCategory.depth==1) {
                [_conditionArray addObject:@[@"价格"]];
            }else if (_selectedFilter.pCategory && _selectedFilter.pCategory.depth==2) {
                [_conditionArray addObject:@[@"品牌"]];
                [_conditionArray addObject:@[@"价格"]];
            }else if (_selectedFilter.pCategory && _selectedFilter.pCategory.depth==3) {
                [_conditionArray addObject:@[@"品牌"]];
                [_conditionArray addObject:@[@"价格"]];
                [_conditionArray addObject:@[@"类别"]];
            }
            if (_selectedFilter.pClass && _selectedFilter.pClass.classCode && ![_selectedFilter.pClass.classCode isEqual:@""]) {
                for (NSObject *obj in _selectedFilter.attributeList) {
                    ProductAttribute *attr = (ProductAttribute *)obj;
                    [_conditionArray addObject:@[attr.attName]];
                }
            }
            [self relaodVIew];
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
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSString *filterName = [_conditionArray objectAtIndex:indexPath.row];
        if ([filterName  isEqual: @"价格"]) {
            cell.textLabel.text = filterName;
        }else {
            cell.textLabel.text = filterName;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ProductCategaryViewController *vc = [[ProductCategaryViewController alloc]init];
    vc.navigationItem.title = cell.textLabel.text;
    vc.filterData = _filterData;
    vc.selectedFilter = _selectedFilter;
    //cell
}
@end

@interface ProductSelectedFilter()

@end

@implementation ProductSelectedFilter

@end
