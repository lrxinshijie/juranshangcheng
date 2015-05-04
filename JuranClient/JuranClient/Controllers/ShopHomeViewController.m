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

@interface ShopHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

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

- (IBAction)onClassification:(id)sender;


@end

@implementation ShopHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-dot"] rightBarButtonItemAction:NULL];

    
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
    [self loadRecommendData];
}

- (void)loadData{
    NSDictionary *param = @{@"shopId": [NSString stringWithFormat:@"%d", _shop.shopId]};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_SHOP_FIRSTPAGE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_shop buildUpWithDictionary:data];
            [self reloadData];
        }
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
    NSDictionary *param = @{@"shopId": [NSString stringWithFormat:@"%d", _shop.shopId]};
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
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onSearchProduct:(id)sender{
    ProductListViewController *vc = [[ProductListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onLocation:(id)sender{
    
    
}

- (IBAction)onPrivateLetter:(id)sender{
    
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
    vc.product = p;
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
    [filter setFinishBlock:^(long catId) {
        //获取分类后处理
    }];
    [self.navigationController pushViewController:filter animated:YES];
}
@end
