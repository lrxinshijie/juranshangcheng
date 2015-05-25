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
#import "ProductSeletedFilter.h"
#import "MJRefresh.h"
#import "ProductFilterView.h"
#import "ProductFilterViewController.h"
#import "CustomSearchBar.h"
#import "DesignerViewController.h"
#import "CaseViewController.h"
#import "QuestionViewController.h"
#import "ShopListViewController.h"
#import "UIViewController+Menu.h"
#import "ProductGridCell.h"
#import "UIAlertView+Blocks.h"
#import "AppDelegate.h"
#import "UserLocation.h"

@interface ProductListViewController () <UITableViewDataSource, UITableViewDelegate, ProductFilterViewDelegate,CustomSearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    BOOL _isCollection;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) ProductFilterView *filterView;
@property (strong, nonatomic) CustomSearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *footerView;
- (IBAction)onSetLoction:(id)sender;
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureMore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMoreMenu) name:kNotificationNameMsgCenterReloadData object:nil];
    [self setupUI];
    [_tableView headerBeginRefreshing];
}



- (void)setupUI{
    [self configureGoBackPre];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 220, 30)];
    textField.placeholder = @"请输入搜索关键词";
    textField.background = [UIImage imageNamed:@"search_bar_bg_image"];
    textField.font = [UIFont systemFontOfSize:14];
    textField.text = _selectedFilter.keyword;
    textField.textColor = [UIColor darkGrayColor];
    self.navigationItem.titleView = textField;
    CGRect frame = textField.frame;
    frame.size.width  = 30;
    UIImageView *leftView = [[UIImageView alloc]imageViewWithFrame:frame image:[UIImage imageNamed:@"search_magnifying_glass"]];
    leftView.contentMode = UIViewContentModeCenter;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    [textField addTarget:self action:@selector(textFieldClick:) forControlEvents:UIControlEventEditingDidBegin];

//    self.searchBar = [[[NSBundle mainBundle] loadNibNamed:@"CustomSearchBar" owner:self options:nil] lastObject];
//    [self.searchBar setSearchButtonType:SearchButtonType_Product];
//    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
//    [self.searchBar rightButtonChangeStyleWithKey:RightBtnStyle_More];
//    self.searchBar.delegate = self;
//    self.searchBar.parentVC = self;
//    [self.searchBar setSearchButtonType:SearchButtonType_Product];
//    [self.searchBar setEnabled:NO];
    
    
    self.filterView = [[ProductFilterView alloc] initWithDefaultData:_filterData SeletedData:_selectedFilter];
    
    _filterView.delegate = self;
//    CGRect frame = _filterView.frame;
//    frame.origin.y = CGRectGetMaxY(_searchBar.frame);
//    _filterView.frame = frame;
    //_filterView.frame = CGRectMake(0, 0, kWindowWidth, 44);
    [self.view addSubview:_filterView];
    
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, CGRectGetMaxY(_filterView.frame), kWindowWidth, kWindowHeight - 44) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.itemSize = CGSizeMake(144, 217);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:_tableView.frame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ProductGridCell" bundle:nil] forCellWithReuseIdentifier:@"ProductGridCell"];
    
    //        __weak typeof(self) weakSelf = self;
    [_collectionView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_collectionView addFooterWithCallback:^{
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
    [param setObject:@(_selectedFilter.pSort.sort) forKey:@"sort"];
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
            
//            [_emptyView removeFromSuperview];
//            [_tableView reloadData];
//            if(_products.count == 0) {
//                _emptyView.center = CGPointMake(_tableView.center.x, 200);
//                [_tableView addSubview:_emptyView];
//            }
        }
        
        [self reloadData];
        [_collectionView headerEndRefreshing];
        [_collectionView footerEndRefreshing];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (void)reloadData{
    [_emptyView removeFromSuperview];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    if (_products.count == 0) {
        if (_tableView.superview) {
//            CGRect frame = CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBar - 40);
//            frame.size.height -= CGRectGetHeight(_tableView.tableHeaderView.frame);
//            UIView *view = [[UIView alloc] initWithFrame:frame];
            _emptyView.center = _tableView.center;
            [self.view addSubview:_emptyView];
//            _tableView.tableFooterView = view;
        }else if (_collectionView.superview){
            _emptyView.center = _collectionView.center;
            [self.view addSubview:_emptyView];
        }
    }
    if (!ApplicationDelegate.gLocation.isSuccessLocation) {
        [_footerView removeFromSuperview];
        _footerView.frame = CGRectMake(0, kWindowHeightWithoutNavigationBar-25, kWindowWidth, 25);
        [self.view addSubview:_footerView];
    }
    [_tableView reloadData];
    [_collectionView reloadData];
}

- (void)clickProductFilterView:(ProductFilterView *)view returnData:(ProductSelectedFilter *)data IsGrid:(BOOL)isGrid IsFilter:(BOOL)isFilter actionType:(FilterViewAction)action{
    _selectedFilter.pSort = data.pSort;
    _selectedFilter.pStore = data.pStore;
    if (isFilter) {
        ProductFilterViewController *vc = [[ProductFilterViewController alloc]init];
        vc.selectedFilter = _selectedFilter.copy;
        vc.filterData = _filterData;
        [vc setBlock:^(ProductSelectedFilter *filter) {
            _selectedFilter = filter;
            [_tableView headerBeginRefreshing];
            [_collectionView headerBeginRefreshing];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(action == FilterViewActionGrid){
        if ([_collectionView superview]) {
            
            _isCollection = NO;
            
            [_collectionView removeFromSuperview];
            
            //[self.view addSubview:_tableView];
            [self.view insertSubview:_tableView atIndex:1];
        } else {
            
            _isCollection = YES;
            
            [_tableView removeFromSuperview];
            //[self.view addSubview:_collectionView];
            [self.view insertSubview:_collectionView atIndex:1];
        }
        [self reloadData];
    }else {
//        if (data) {
//            _selectedFilter = data;
//        }
        [_tableView headerBeginRefreshing];
        [_collectionView headerBeginRefreshing];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_products count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 119;
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_products count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ProductGridCell";
    ProductGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    JRProduct *cs = [_products objectAtIndex:indexPath.row];
    [cell fillCellWithProduct:cs];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductDetailViewController *pd = [[ProductDetailViewController alloc] init];
    pd.product = _products[indexPath.row];
    [self.navigationController pushViewController:pd animated:YES];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.searchBar removeFromSuperview];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    //self.navigationController.navigationBarHidden = NO;
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

- (void)customSearchStartWork {
    if (_filterView.isShow)
        [_filterView showSort];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)textFieldClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pointY;
    CGRect tableFrame;
    CGRect filterViewFrame = _filterView.frame;
    
    if (_isCollection) {
        pointY = [scrollView.panGestureRecognizer translationInView:_collectionView].y;
        tableFrame =  _collectionView.frame;
    }else {
        pointY = [scrollView.panGestureRecognizer translationInView:_tableView].y;
        tableFrame =  _tableView.frame;
    }

    if (pointY < 0) {
        //隐藏
        if (filterViewFrame.origin.y <= -44) {
            
            filterViewFrame.origin.y = -44;
            tableFrame.origin.y = 0;
            tableFrame.size.height = kWindowHeightWithoutNavigationBarAndTabbar+44;
            
        }else {
            
            filterViewFrame.origin.y -= changeHeight;
            tableFrame.origin.y -= changeHeight;
            tableFrame.size.height += changeHeight;
        }
        
    }else {
        //显示
        if (filterViewFrame.origin.y >= 0) {
            
            filterViewFrame.origin.y = 0;
            tableFrame.origin.y = CGRectGetMaxY(_filterView.frame);
            tableFrame.size.height = kWindowHeightWithoutNavigationBarAndTabbar;
            
        }else {
            
            filterViewFrame.origin.y += changeHeight;
            tableFrame.origin.y += changeHeight;
            tableFrame.size.height -= changeHeight;
            
        }
    }
    
    _filterView.frame = filterViewFrame;
    if (_isCollection) {
        _collectionView.frame = tableFrame;
    }else {
        _tableView.frame = tableFrame;
    }
}

- (IBAction)onSetLoction:(id)sender {
    if(!ApplicationDelegate.gLocation.isSuccessLocation) {
        [UIAlertView showWithTitle:@"提示" message:@"访问此类别需要开启定位服务，请在“设置->隐私->定位服务”中开启居然在线的定位~" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return;
            }else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
    }

}

@end
