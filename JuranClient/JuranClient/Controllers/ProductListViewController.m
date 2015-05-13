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
#import "MJRefresh.h"
#import "ProductFilterView.h"
#import "ProductFilterViewController.h"
#import "CustomSearchBar.h"
#import "DesignerViewController.h"
#import "CaseViewController.h"
#import "QuestionViewController.h"
#import "ShopListViewController.h"
#import "UIViewController+Menu.h"

@interface ProductListViewController () <UITableViewDataSource, UITableViewDelegate, ProductFilterViewDelegate,CustomSearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) ProductFilterView *filterView;
@property (strong, nonatomic) CustomSearchBar *searchBar;
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
    [_tableView headerBeginRefreshing];
}

- (void)setupUI{
    self.searchBar = [[[NSBundle mainBundle] loadNibNamed:@"CustomSearchBar" owner:self options:nil] lastObject];
    [self.searchBar setSearchButtonType:SearchButtonType_Product];
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    [self.searchBar rightButtonChangeStyleWithKey:RightBtnStyle_More];
    self.searchBar.delegate = self;
    self.searchBar.parentVC = self;
    
    self.filterView = [[ProductFilterView alloc] initWithDefaultData:_filterData SeletedData:_selectedFilter];
    _filterView.delegate = self;
    CGRect frame = _filterView.frame;
    frame.origin.y = CGRectGetMaxY(_searchBar.frame);
    _filterView.frame = frame;
    //_filterView.frame = CGRectMake(0, 0, kWindowWidth, 44);
    [self.view addSubview:_filterView];
    
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, CGRectGetMaxY(_filterView.frame), kWindowWidth, kWindowHeight +20 - CGRectGetMaxY(_filterView.frame)) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [self.view addSubview:_tableView];
    [self.view addSubview:self.searchBar];
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
}

- (void)loadData{
    
    //NSDictionary *param = nil;
    //NSString *url = @"";
    
    
    //    //TODO: 添加接口及参数
    //    if (_searchKey.length > 0) {
    //        //搜索
    //        param = @{@"sort": @(_selectedFilter.sort),
    //                  @"pageNo":@(_currentPage),
    //                  @"onePageCount":kOnePageCount
    //                  };
    //        url = JR_SEARCH_PRODUCT;
    //    }else if (_shop){
    //        //商家全部商品
    //        param = @{@"sort": @(_selectedFilter.sort),
    //                  @"pageNo":@(_currentPage),
    //                  @"onePageCount":kOnePageCount
    //                  };
    //    }else if (_brand){
    //        //品牌
    //    }
    NSString *url = nil;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"北京市" forKey:@"cityName"];
    [param setObject:@(_currentPage) forKey:@"pageNo"];
    [param setObject:kOnePageCount forKey:@"onePageCount"];
    [param setObject:@(_selectedFilter.sort) forKey:@"sort"];
    if (_selectedFilter.keyword && _selectedFilter.keyword.length>0) [param setObject:_selectedFilter.keyword forKey:@"keyword"];
    if (_selectedFilter.pMinPrice>0) [param setObject:[NSString stringWithFormat:@"%ld",_selectedFilter.pMinPrice<=_selectedFilter.pMinPrice?_selectedFilter.pMinPrice:_selectedFilter.pMaxPrice] forKey:@"priceMinYuan"];
    if (_selectedFilter.pMaxPrice>0) [param setObject:[NSString stringWithFormat:@"%ld",_selectedFilter.pMinPrice>_selectedFilter.pMinPrice?_selectedFilter.pMinPrice:_selectedFilter.pMaxPrice] forKey:@"priceMaxYuan"];
    if (_selectedFilter.pBrand) [param setObject:@(_selectedFilter.pBrand.brandId) forKey:@"brands"];
    if (_selectedFilter.pStore) [param setObject:_selectedFilter.pStore.storeCode forKey:@"storeCode"];
    if (_selectedFilter.pClass) [param setObject:_selectedFilter.pClass.classCode forKey:@"catCode"];
    if (_selectedFilter.pAttributeDict && _selectedFilter.pAttributeDict.count>0) {
        NSEnumerator * enumerator = [_selectedFilter.pAttributeDict keyEnumerator];
        id object;
        NSString *attrString = @"";
        while(object = [enumerator nextObject])
        {
            id objectValue = [_selectedFilter.pAttributeDict objectForKey:object];
            if(objectValue != nil)
            {
                if ([attrString isEqual:@""]) {
                    attrString = [attrString stringByAppendingString:[NSString stringWithFormat:@"%@:%@",object,objectValue]];
                }else {
                    attrString = [attrString stringByAppendingString:[NSString stringWithFormat:@";%@:%@",object,objectValue]];
                }
            }
        }
        //attrString = [NSString stringWithFormat:@"[%@]",attrString];
        [param setObject:attrString forKey:@"attributes"];
    }
    if(_selectedFilter.isInShop) {
        if (_selectedFilter.shopId!=0) [param setObject:[NSString stringWithFormat:@"%ld",_selectedFilter.shopId] forKey:@"shopId"];
        if (_selectedFilter.pCategory) [param setObject:@(_selectedFilter.pCategory.Id) forKey:@"shopCategories"];
        url = JR_SEARCH_PRODUCT_IN_SHOP;
    }else {
        if (_selectedFilter.pCategory && _selectedFilter.pCategory.urlContent) [param setObject:_selectedFilter.pCategory.urlContent forKey:@"urlContent"];
        url = JR_SEARCH_PRODUCT;
    }
    
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"No"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            
            //TODO: 接口返回值处理
            //if (_selectedFilter.keyword.length > 0) {
            NSArray *recommendProductsList = [data objectForKey:@"emallGoodsInfoList"];
            NSMutableArray *products = [JRProduct buildUpWithValueForList:recommendProductsList];
            if (_currentPage == 1) {
                self.products = products;
                
                _filterData.attributeList = [ProductAttribute buildUpWithValueForList:[data objectForKey:@"showAttributesList"]];
                if (_selectedFilter.isInShop) {
                    _filterData.categoryList = [ProductCategory buildUpWithValueForList:[data objectForKey:@"appShopCatList"]];
                }else {
                    _filterData.categoryList = [ProductCategory buildUpWithValueForList:[data objectForKey:@"appOperatingCatList"]];
                }
                _filterData.brandList = [ProductBrand buildUpWithValueForList:[data objectForKey:@"sortBrandList"]];
                _filterData.storeList = [ProductStore buildUpWithValueForList:[data objectForKey:@"appStoreInfoList"]];
                _filterData.classList = [ProductClass buildUpWithValueForList:[data objectForKey:@"appManagementCategoryList"]];
            }else{
                [_products addObjectsFromArray:products];
            }
            //}
            //            }else if (_shop){
            //
            //            }else if (_brand){
            //
            //            }
            [_emptyView removeFromSuperview];
            [_tableView reloadData];
            if(_products.count == 0) {
                _emptyView.center = CGPointMake(_tableView.center.x, 200);
                [_tableView addSubview:_emptyView];
            }
        }
        
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (void)clickProductFilterView:(ProductFilterView *)view returnData:(ProductSelectedFilter *)data IsGrid:(BOOL)isGrid IsFilter:(BOOL)isFilter{
    if (isFilter) {
        ProductFilterViewController *vc = [[ProductFilterViewController alloc]init];
        _selectedFilter = data;
        vc.selectedFilter = data;
        vc.filterData = _filterData;
        [vc setBlock:^(ProductSelectedFilter *filter) {
            _selectedFilter = filter;
            [_tableView headerBeginRefreshing];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(isGrid){
        
    }else {
        _selectedFilter = data;
        [_tableView headerBeginRefreshing];
    }
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

- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.clipsToBounds = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[self.searchBar removeFromSuperview];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navigationController.navigationBarHidden = NO;
    if ([_filterView isShow]) {
        [_filterView showSort];
    }
}

- (void)showMenuList
{
    [self showAppMenu:nil];
}

- (void)goBackButtonDidSelect
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startSearchWithKeyWord:(NSString *)keyWord index:(int)index {
    if (index == 0){
        CaseViewController *vc = [[CaseViewController alloc] init];
        vc.searchKey = keyWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1){
        //ProductListViewController *vc = [[ProductListViewController alloc]init];
        _selectedFilter.keyword = keyWord;
        [_tableView headerBeginRefreshing];
        //[self.navigationController pushViewController:vc animated:YES];
    }else if (index == 2){
//        _selectedFilter.keyword = keyWord;
//        [_tableView headerBeginRefreshing];
        ShopListViewController * vc = [[ShopListViewController alloc] init];
        vc.keyword = keyWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 3) {
        DesignerViewController *vc = [[DesignerViewController alloc] init];
        vc.searchKeyWord = keyWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 4){
        QuestionViewController *vc = [[QuestionViewController alloc] init];
        vc.searchKeyWord = keyWord;
        vc.isSearchResult = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
