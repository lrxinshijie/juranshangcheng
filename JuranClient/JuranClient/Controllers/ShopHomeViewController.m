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
#import "ShopListViewController.h"

@interface ShopHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIView *headerView;

@property (nonatomic, strong) IBOutlet UIImageView *shopLogoImageView;
@property (nonatomic, strong) UIImageView *indexShopLogoImageView;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *gradeLabel;
- (IBAction)onClassification:(id)sender;




@end

@implementation ShopHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ShopCell" bundle:nil] forCellWithReuseIdentifier:@"ShopCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ShopHeadView"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:_collectionView.bounds];
    bgView.backgroundColor = RGBColor(241, 241, 241);
    self.indexShopLogoImageView = [[UIImageView alloc] initWithFrame:bgView.bounds];
    [bgView addSubview:_indexShopLogoImageView];
    _collectionView.backgroundView = bgView;
    
    [self loadData];
    [self loadRecommendData];
}

- (void)loadData{
    NSDictionary *param = @{@"shopId": @"5"};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_SHOP_FIRSTPAGE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            self.shop = [[JRShop alloc] initWithDictionary:data];
            [self reloadData];
        }
    }];
}

- (void)loadRecommendData{
    NSDictionary *param = @{@"shopId": @"6"};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_SHOP_RECOMMEND parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            id obj = data[@"recommendProductsList"];
            if ([obj isKindOfClass:[NSArray class]]) {
                self.datas = obj;
            }
            [self reloadData];
        }
    }];
}

- (void)reloadData{
    [self.shopLogoImageView setImageWithURLString:_shop.shopLogo];
    [self.indexShopLogoImageView setImageWithURLString:_shop.indexShopLogo];
    [_collectionView reloadData];
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
    NSDictionary *dic = _datas[indexPath.row];
    [cell fillCellWithValue:dic];
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
//    FilterInShopViewController *filter = [[FilterInShopViewController alloc]init];
//    [filter setFinishBlock:^(long catId) {
//        //获取分类后
//    }];
//    [self.navigationController pushViewController:filter animated:YES];
    ShopListViewController *vc = [[ShopListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
