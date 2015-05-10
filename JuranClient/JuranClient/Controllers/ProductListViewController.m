//
//  ProductListViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductListViewController.h"
#import "JRProduct.h"
#import "ProductCell.h"
#import "ProductDetailViewController.h"
#import "ProductFilterData.h"

@interface ProductListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *products;
@end

@implementation ProductListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _filterData = [[ProductFilterData alloc]init];
        _selectedFilter = [[ProductSelectedFilter alloc]init];
    }
    return self;
}

- (void)dealloc{
    _tableView.delegate = nil; _tableView.dataSource = nil;
}

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self loadData];
}

- (void)setupUI{
    self.tableView =
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [self.view addSubview:_tableView];
}

- (void)loadData{
    
    NSDictionary *param = @{@"sort": @(_selectedFilter.sort),
                            @"pageNo":@(1),
                            @"onePageCount":kOnePageCount
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SEARCH_PRODUCT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"No"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *recommendProductsList = [data objectForKey:@"emallGoodsInfoList"];
            self.products = [JRProduct buildUpWithValueForList:recommendProductsList];
            
            _filterData.attributeList = [ProductAttribute buildUpWithValueForList:[data objectForKey:@"showAttributesList"]];
            if (_selectedFilter.isInShop) {
                _filterData.categoryList = [ProductCategory buildUpWithValueForList:[data objectForKey:@"appShopCatList"]];
            }else {
                _filterData.categoryList = [ProductCategory buildUpWithValueForList:[data objectForKey:@"appOperatingCatList"]];
            }
            _filterData.brandList = [ProductBrand buildUpWithValueForList:[data objectForKey:@"sortBrandList"]];
            _filterData.storeList = [ProductStore buildUpWithValueForList:[data objectForKey:@"appStoreInfoList"]];
            _filterData.classList = [ProductClass buildUpWithValueForList:[data objectForKey:@"appManagementCategoryList"]];
            [_tableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_products count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ProductCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (ProductCell *)[nibs firstObject];
    }
    
    JRProduct *product = _products[indexPath.row];
    [cell fillCellWithProduct:product];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductDetailViewController *pd = [[ProductDetailViewController alloc] init];
    pd.product = _products[indexPath.row];
    [self.navigationController pushViewController:pd animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
