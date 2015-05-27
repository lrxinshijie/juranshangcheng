//
//  ShopHomeViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ShopHomeViewController.h"
#import "JRShop.h"
#import "ShopCell.h"
#import "FilterInShopViewController.h"
#import "JRWebViewController.h"
#import "JRProduct.h"
#import "ProductDetailViewController.h"
#import "ProductListViewController.h"
#import "JRStore.h"
#import "NaviStoreListViewController.h"
#import "AppDelegate.h"
#import "UserLocation.h"
#import "ProductLetterViewController.h"
#import "UIViewController+Menu.h"
#import "CustomSearchBar.h"
#import "ProductFilterData.h"
#import "DesignerViewController.h"
#import "CaseViewController.h"
#import "QuestionViewController.h"
#import "ShopListViewController.h"
#import "ProductSeletedFilter.h"


@interface ShopHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,CustomSearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIView *headerView;

@property (nonatomic, strong) IBOutlet UIImageView *shopLogoImageView;
@property (nonatomic, strong) UIImageView *indexShopLogoImageView;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *gradeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *gradeImageView;

@property (nonatomic, strong) IBOutlet UIImageView *collectionImageView;
@property (nonatomic, strong) IBOutlet UILabel *collectionLabel;
@property (nonatomic, strong) IBOutlet UIView *searchView;
@property (nonatomic, strong) IBOutlet UIView *searchTextField;

@property (strong, nonatomic) CustomSearchBar *searchBar;
@property (nonatomic, strong) NSArray *storeList;

- (IBAction)onClassification:(id)sender;


@end

@implementation ShopHomeViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = @"shop";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-dot"] rightBarButtonItemAction:@selector(onMenu)];
    ///////////////
    self.searchBar = [[[NSBundle mainBundle] loadNibNamed:@"CustomSearchBar" owner:self options:nil] lastObject];
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    [self.searchBar rightButtonChangeStyleWithKey:RightBtnStyle_More];
    self.searchBar.delegate = self;
    self.searchBar.parentVC = self;
    [self.searchBar setSearchButtonType:SearchButtonType_Product];
    [self.searchBar setEnabled:NO];
    self.searchBar.inputTextField.placeholder = @"      搜索店铺内的商品";
    [self.view addSubview:self.searchBar];
    ////////////////
    [_collectionView registerNib:[UINib nibWithNibName:@"ShopCell" bundle:nil] forCellWithReuseIdentifier:@"ShopCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ShopHeadView"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:_collectionView.bounds];
    bgView.backgroundColor = RGBColor(241, 241, 241);
    self.indexShopLogoImageView = [[UIImageView alloc] initWithFrame:bgView.bounds];
    [bgView addSubview:_indexShopLogoImageView];
    _collectionView.backgroundView = bgView;
    
    _searchView.layer.cornerRadius = 2.f;
    self.navigationItem.titleView = self.searchView;
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.clipsToBounds = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.searchBar removeFromSuperview];
    //self.navigationController.navigationBar.clipsToBounds = YES;
    self.navigationController.navigationBarHidden = NO;
}


- (void)loadData{
    NSDictionary *param = @{@"shopId": [NSString stringWithFormat:@"%d", _shop.shopId],
                            @"minisite": _shop.minisite ? _shop.minisite : @"",
                            @"flag": _type ? _type : @""};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_SHOP_FIRSTPAGE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_shop buildUpWithDictionary:data];
            [self reloadData];
        }
        [self loadRecommendData];
        [self loadStoreData];
    }];
}

- (void)loadRecommendData{
    NSDictionary *param = @{@"shopId": [NSString stringWithFormat:@"%d", _shop.shopId]};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_SHOP_RECOMMEND parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *items = data[@"recommendProductsList"];
            self.datas = [JRProduct buildUpWithValueForList:items];
            [self reloadData];
        }
    }];
}

- (void)reloadData{
    [self.shopLogoImageView setImageWithURLString:_shop.shopLogo];
    [self.indexShopLogoImageView setImageWithURLString:_shop.indexShopLogo];
    _gradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-grade-%@.png", _shop.grade.integerValue?@"1":@"2"]];
    _gradeLabel.text = [NSString stringWithFormat:@"店铺评分：%@", _shop.shopDsr];
    _nameLabel.text = _shop.shopName;
    _collectionImageView.image = [UIImage imageNamed:_shop.isStored?@"icon-collection-active.png":@"icon-collection.png"];
    _collectionLabel.text = _shop.isStored?@"已收藏":@"收藏";
    [_collectionView reloadData];
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
        ProductListViewController *vc = [[ProductListViewController alloc]init];
        vc.selectedFilter.keyword = keyWord;
        vc.selectedFilter.isInShop = YES;
        vc.selectedFilter.shopId = _shop.shopId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 2){
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

#pragma mark - Target Action

- (void)onMenu{
    [self showAppMenu:nil];
}

- (IBAction)onCollection:(id)sender{
    if ([self checkLogin:^{
        [_shop collectionWithViewCotnroller:self finishBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        }];
    }]) {
        [_shop collectionWithViewCotnroller:self finishBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        }];
    }
}

- (IBAction)onIntroduce:(id)sender{
    NSDictionary *param = @{@"shopId": [NSString stringWithFormat:@"%d", _shop.shopId]
                            };
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_SHOP_INTRODUCE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                JRWebViewController *vc = [[JRWebViewController alloc] init];
                vc.title = @"店铺介绍";
                vc.htmlString = [data getStringValueForKey:@"shopDesc" defaultValue:@""];
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
    }];
}

- (IBAction)onAllProduct:(id)sender{
    ProductListViewController *vc = [[ProductListViewController alloc] init];
    vc.selectedFilter.isInShop = YES;
    vc.selectedFilter.shopId = _shop.shopId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onSearchProduct:(id)sender{
    ProductListViewController *vc = [[ProductListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadStoreData{
#ifndef kJuranDesigner
    NSDictionary *param = @{@"shopId": @(_shop.shopId),@"cityName":ApplicationDelegate.gLocation.cityName};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SHOP_LOCATION parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if (data!=[NSNull null]) {
                _storeList = [JRStore buildUpWithValueForList:[data objectForKey:@"stallInfoList"]];
            }
            
        }
    }];
#endif
}


- (IBAction)onLocation:(id)sender{
    if (_storeList.count>0) {
        NaviStoreListViewController *navi = [[NaviStoreListViewController alloc]init];
        navi.naviType = NaviTypeStall;
        navi.shopId = _shop.shopId;
        [self.navigationController pushViewController:navi animated:YES];
    }else {
        [self showTip:@"该店铺没有关联实体店"];
    }
}

- (IBAction)onPrivateLetter:(id)sender{
    if ([self checkLogin:^{
        [[JRUser currentUser] postPrivateLetterWithUserId:_shop.shopId Target:_shop VC:self];
    }]) {
        [[JRUser currentUser] postPrivateLetterWithUserId:_shop.shopId Target:_shop VC:self];
    }
    //    ProductLetterViewController *pv = [[ProductLetterViewController alloc] init];
    //    pv.shop = _shop;
    //    [self.navigationController pushViewController:pv animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ShopCell";
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    JRProduct *p = _datas[indexPath.row];
    [cell fillCellWithValue:p];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    static NSString *headerIdentifier = @"ShopHeadView";
    UICollectionReusableView *header = nil;
    if([kind isEqual:UICollectionElementKindSectionHeader]){
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            [header addSubview:self.headerView];
        }
    }
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JRProduct *p = _datas[indexPath.row];
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
    vc.product = [[JRProduct alloc]init];
    vc.product.linkProductId = p.linkProductId;
    vc.product.shopId = p.shopId;
    [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)onClassification:(id)sender {
    FilterInShopViewController *filter = [[FilterInShopViewController alloc]init];
    filter.shopId = _shop.shopId;
    [filter setFinishBlock:^(ProductSelectedFilter *filter) {
        //获取分类后处理
        ProductListViewController *vc = [[ProductListViewController alloc] init];
        vc.selectedFilter = filter;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.navigationController pushViewController:filter animated:YES];
}
@end
