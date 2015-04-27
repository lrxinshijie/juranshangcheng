//
//  MallViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "MallViewController.h"
#import "ShopHomeViewController.h"
#import "FilterInShopViewController.h"
#import "NaviStoreInfoViewController.h"
#import "JRAdInfo.h"
#import "EScrollerView.h"
#import "TopProductCell.h"
#import "TopShopCell.h"
#import "ProductListViewController.h"
#import "ProductDetailViewController.h"
#import "ShopHomeViewController.h"
#import "JRProduct.h"
#import "JRShop.h"

@interface MallViewController () <UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIButton *cityButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSMutableArray *adInfos;
@property (nonatomic, strong) EScrollerView *bannerView;

@property (nonatomic, strong) IBOutlet UIView *shopView;
@property (nonatomic, strong) IBOutlet UICollectionView *shopCollectionView;

@property (nonatomic, strong) NSArray *shops;

@property (nonatomic, strong) IBOutlet UIView *productView;
@property (nonatomic, strong) IBOutlet UICollectionView *productCollectionView;
@property (nonatomic, strong) NSArray *products;

@end

@implementation MallViewController

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureCityTitle:@"请选择"];
    [self configureScan];
    [self configureSearchAndMore];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    _tableView.tableHeaderView = _headerView;
    _tableView.backgroundColor = RGBColor(237, 237, 237);
    [self.view addSubview:_tableView];
    
    [_shopCollectionView registerNib:[UINib nibWithNibName:@"TopShopCell" bundle:nil] forCellWithReuseIdentifier:@"TopShopCell"];
    [_productCollectionView registerNib:[UINib nibWithNibName:@"TopProductCell" bundle:nil] forCellWithReuseIdentifier:@"TopProductCell"];
    
    _shopCollectionView.backgroundColor = [UIColor clearColor];
    _productCollectionView.backgroundColor = [UIColor clearColor];
    
    [self loadAd];
}

- (void)loadData{
    NSDictionary *param = @{@"cityName": [Public defaultCityName]};
    [[ALEngine shareEngine] pathURL:JR_MALL_ACTIVITY_SHOP parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (error || ![data isKindOfClass:[NSDictionary class]]) {
            [self hideHUD];
            return;
        }
        
        NSArray *activeShopList = [data getArrayValueForKey:@"activeShopList" defaultValue:nil];
        
        self.shops = [JRShop buildUpWithValueForList:activeShopList];
        [_shopCollectionView reloadData];
        
        
        [[ALEngine shareEngine] pathURL:JR_MALL_ACTIVITY_PRODUCT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
            [self hideHUD];
            if (!error && [data isKindOfClass:[NSDictionary class]]) {
                NSArray *activeGoodsList = [data getArrayValueForKey:@"activeGoodsList" defaultValue:nil];
                
                self.products = [JRProduct buildUpWithValueForList:activeGoodsList];
                [_productCollectionView reloadData];
            }
        }];
    }];
}

- (void)loadAd{
    NSDictionary *param = @{@"adCode": @"app_designer_index_roll",
                            @"areaCode": @"110000",
                            @"type": @(8)};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_GET_BANNER_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (error) {
            [self hideHUD];
            return;
        }
        
        NSArray *bannerList = [data objectForKey:@"bannerList"];
        if (bannerList.count > 0) {
            self.adInfos = [JRAdInfo buildUpWithValue:bannerList];
            self.bannerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, kWindowWidth, 165) ImageArray:_adInfos Aligment:PageControlAligmentRight];
            _bannerView.delegate = self;
            [_headerView addSubview:_bannerView];
        }
        [self loadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:_shopCollectionView]) {
        return [_shops count];
    }
    
    return [_products count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:_shopCollectionView]) {
        TopShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopShopCell" forIndexPath:indexPath];
        [cell fillCellWithData:_shops[indexPath.row]];
        return cell;
    }else{
        TopProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopProductCell" forIndexPath:indexPath];
        [cell fillCellWithData:_products[indexPath.row]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:_shopCollectionView]) {
        ShopHomeViewController *sv = [[ShopHomeViewController alloc] init];
        sv.shop = _shops[indexPath.row];;
        sv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sv animated:YES];
    }else{
        ProductDetailViewController *pd = [[ProductDetailViewController alloc] init];
        pd.product = _products[indexPath.row];
        pd.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pd animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGRectGetHeight(_shopView.frame);
    }
    
    return CGRectGetHeight(_productView.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        [_shopView removeFromSuperview];
        [cell addSubview:_shopView];
    }else{
        [_productView removeFromSuperview];
        [cell addSubview:_productView];
    }
    
    return cell;
}

//- (void)onCity:(UIButton *)sender{
//    ProductListViewController *pl = [[ProductListViewController alloc] init];
//    pl.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:pl animated:YES];
//}

- (IBAction)onShop:(id)sender{
//    ShopHomeViewController *vc = [[ShopHomeViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    FilterInShopViewController *vc = [[FilterInShopViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    NaviStoreListViewController *vc = [[NaviStoreListViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    NaviStoreInfoViewController *vc = [[NaviStoreInfoViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
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
