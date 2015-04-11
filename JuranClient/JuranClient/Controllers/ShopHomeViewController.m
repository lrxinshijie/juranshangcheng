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

@interface ShopHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIView *headerView;

@property (nonatomic, strong) IBOutlet UIImageView *shopLogoImageView;
@property (nonatomic, strong) UIImageView *indexShopLogoImageView;

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
}

- (void)loadData{
    NSDictionary *param = @{@"shopId": @"4"};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_SHOP_FIRSTPAGE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            self.shop = [[JRShop alloc] initWithDictionary:data];
            [self reloadData];
        }
    }];
}

- (void)reloadData{
    [self.shopLogoImageView setImageWithURLString:_shop.shopLogo];
    [self.indexShopLogoImageView setImageWithURLString:_shop.indexShopLogo];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ShopCell";
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
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

@end
