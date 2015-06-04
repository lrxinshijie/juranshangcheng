//
//  MallViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "MallViewController.h"
#import "ShopHomeViewController.h"
#import "JRAdInfo.h"
#import "EScrollerView.h"
#import "TopProductCell.h"
#import "TopShopCell.h"
#import "ProductListViewController.h"
#import "ProductDetailViewController.h"
#import "ShopHomeViewController.h"
#import "JRProduct.h"
#import "JRShop.h"
#import "GoodsCategaryViewController.h"

@interface MallViewController () <UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIButton *cityButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSMutableArray *adInfos;
@property (nonatomic, strong) EScrollerView *bannerView;
@property (nonatomic, strong) IBOutlet UIView *menuView;

@property (nonatomic, strong) IBOutlet UIView *shopView;
@property (nonatomic, strong) IBOutlet UICollectionView *shopCollectionView;

@property (nonatomic, strong) NSArray *shops;

@property (nonatomic, strong) IBOutlet UIView *productView;
@property (nonatomic, strong) IBOutlet UICollectionView *productCollectionView;
@property (nonatomic, strong) NSArray *products;
@property (strong, nonatomic) IBOutlet UILabel *shopTitle;
@property (strong, nonatomic) IBOutlet UILabel *goodsTitle;

@end

@implementation MallViewController
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureCityTitle:@"请选择"];
    [self configureScan];
    [self configureSearchAndMore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMoreMenu) name:kNotificationNameMsgCenterReloadData object:nil];
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
        _shopTitle.text = [data getStringValueForKey:@"shopTitle" defaultValue:@""];
        NSArray *activeShopList = [data getArrayValueForKey:@"activeShopList" defaultValue:nil];
        
        self.shops = [JRShop buildUpWithValueForList:activeShopList];
        [_shopCollectionView reloadData];
        
        
        [[ALEngine shareEngine] pathURL:JR_MALL_ACTIVITY_PRODUCT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
            [self hideHUD];
            if (!error && [data isKindOfClass:[NSDictionary class]]) {
                _goodsTitle.text = [data getStringValueForKey:@"goodsTitle" defaultValue:@""];
                NSArray *activeGoodsList = [data getArrayValueForKey:@"activeGoodsList" defaultValue:nil];
                
                self.products = [JRProduct buildUpWithValueForList:activeGoodsList];
                [_productCollectionView reloadData];
            }
        }];
    }];
}

- (void)loadAd{
    NSDictionary *param = @{@"adCode": @"app_consumer_mall_index_roll",
                            @"areaCode": @"110000",
                            @"type": @(7)};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_GET_BANNER_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (error) {
            [self hideHUD];
            return;
        }
        
        NSArray *bannerList = [data objectForKey:@"bannerList"];
        self.adInfos = [JRAdInfo buildUpWithValue:bannerList];
        [self reSetAdView];
//        if (bannerList.count > 0) {    
//            self.bannerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, kWindowWidth, 165) ImageArray:_adInfos Aligment:PageControlAligmentRight];
//            _bannerView.delegate = self;
//            [_headerView addSubview:_bannerView];
//        }
        [self loadData];
    }];
}

- (void)reSetAdView{
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
    
    if (self.adInfos.count > 0) {
        self.bannerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, kWindowWidth, 165) ImageArray:_adInfos Aligment:PageControlAligmentRight];
        _bannerView.delegate = self;
        [_headerView addSubview:_bannerView];
        
        _menuView.frame = CGRectMake(0, CGRectGetMaxY(_bannerView.frame),  CGRectGetWidth(_menuView.frame), CGRectGetHeight(_menuView.frame));
    }else{
        _menuView.frame = CGRectMake(0, 0, CGRectGetWidth(_menuView.frame), CGRectGetHeight(_menuView.frame));
    }
    _headerView.frame = CGRectMake(0, 0, CGRectGetWidth(_headerView.frame), CGRectGetMaxY(_menuView.frame));
    _tableView.tableHeaderView = _headerView;
}

- (void)EScrollerViewDidClicked:(NSUInteger)index{
    JRAdInfo *ad = [_adInfos objectAtIndex:index];
    ASLog(@"index:%d,%@",index,ad.link);
    [Public jumpFromLink:ad.link];
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

- (IBAction)onBrandList:(id)sender{
    GoodsCategaryViewController * good = [[GoodsCategaryViewController alloc] initWithNibName:@"GoodsCategaryViewController" bundle:nil isPopNavHide:NO style:CategaryStyle_Shop];
    [self.navigationController pushViewController:good animated:YES];
}

- (IBAction)onGoodsList:(id)sender{
    GoodsCategaryViewController * good = [[GoodsCategaryViewController alloc] initWithNibName:@"GoodsCategaryViewController" bundle:nil isPopNavHide:NO style:CategaryStyle_Goods];
    [self.navigationController pushViewController:good animated:YES];
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
