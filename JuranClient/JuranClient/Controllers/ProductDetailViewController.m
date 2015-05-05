//
//  ProductDetailViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "JRSegmentControl.h"
#import "JRProduct.h"
#import "ALWebView.h"
#import "ProductCell.h"
#import "JRShop.h"
#import "ShopHomeViewController.h"
#import "LocationManager.h"
#import "ProductLetterViewController.h"
#import "JRStore.h"
#import "AppDelegate.h"
#import "UserLocation.h"
#import "NaviStoreInfoViewController.h"

@interface ProductDetailViewController () <UITableViewDelegate, UITableViewDataSource, JRSegmentControlDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *tipsView;
@property (nonatomic, strong) IBOutlet UIView *titleView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UIButton *favorityButton;
@property (nonatomic, strong) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;

@property (nonatomic, strong) IBOutlet UIImageView *shopLogoImageView;
@property (nonatomic, strong) IBOutlet UILabel *shopNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *shopScoreLabel;

@property (nonatomic, strong) IBOutlet UIView *navigationView;
@property (nonatomic, strong) IBOutlet UIView *locationView;
@property (nonatomic, strong) IBOutlet UILabel *storeNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *storeLocationLabel;

@property (nonatomic, strong) IBOutlet UIView *shopView;

@property (nonatomic, strong) UITableView *baseTableView;


@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) ALWebView *webView;
@property (nonatomic, strong) NSArray *products;

@property (nonatomic, strong) JRSegmentControl *segCtl;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navigationView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    [self setupUI];
    [self loadData];
}

- (void)setupUI{
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)*2);
    _scrollView.backgroundColor = RGBColor(237, 237, 237);
    _scrollView.delegate = self;

    _imageScrollView.delegate = self;
    _imageScrollView.pagingEnabled = YES;
    
    self.baseTableView = [self.scrollView tableViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame) - CGRectGetHeight(_tipsView.frame)) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.tableHeaderView = _titleView;
    [_scrollView addSubview:_baseTableView];
    [_scrollView addSubview:_tipsView];
    [self.view addSubview:_navigationView];
    
    CGRect frame = _tipsView.frame;
    frame.origin.y = CGRectGetMaxY(_baseTableView.frame);
    _tipsView.frame = frame;
    
    self.segCtl = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_scrollView.frame) + CGRectGetHeight(_navigationView.frame) + 1, CGRectGetWidth(_scrollView.frame), 44)];
    _segCtl.titleList = @[@"商品详情", @"商品参数", @"店铺推荐"];
    _segCtl.delegate = self;
    _segCtl.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_segCtl];
    
    self.webView = [[ALWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segCtl.frame), CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame) - CGRectGetHeight(_navigationView.frame) - 45)];
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_webView];
    
    self.detailTableView = [self.scrollView tableViewWithFrame:_webView.frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _detailTableView.backgroundColor = [UIColor clearColor];
}

- (void)loadData{
    
    [self showHUD];
    [_product loadInfo:^(BOOL result) {
        [self hideHUD];
        if (!result) {
            return ;
        }
        
        [self setupFavority];
        
        _nameLabel.text = _product.goodsName;
        CGRect frame = _nameLabel.frame;
        CGFloat height = [_nameLabel.text heightWithFont:_nameLabel.font constrainedToWidth:CGRectGetWidth(frame)];
        if (height >= 35) {
            height = 35;
        }
        frame.size.height = height;
        _nameLabel.frame = frame;
        
        _priceLabel.text = [NSString stringWithFormat:@"￥%@ ~ ￥%@", [@([_product.priceMin intValue]) decimalNumberFormatter], [@([_product.priceMax intValue]) decimalNumberFormatter]];
//        [_favorityButton setImage:[UIImage imageNamed:_product.type ? @"icon-star-active" : @"icon-star"] forState:UIControlStateNormal];
        
        [_imageScrollView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
            [subview removeFromSuperview];
        }];
        [_imageScrollView setContentOffset:CGPointZero];
        
        _imageScrollView.contentSize = CGSizeMake(CGRectGetWidth(_imageScrollView.frame) * _product.goodsImagesList.count, CGRectGetHeight(_imageScrollView.frame));
        _imageScrollView.backgroundColor = RGBColor(237, 237, 237);
        [_product.goodsImagesList enumerateObjectsUsingBlock:^(NSString *imageUrl, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_imageScrollView.frame)*idx, 0, CGRectGetWidth(_imageScrollView.frame), CGRectGetHeight(_imageScrollView.frame))];
            imageView.backgroundColor = RGBColor(237, 237, 237);
            [imageView setImageWithURLString:imageUrl];
            [_imageScrollView addSubview:imageView];
        }];
        
        _countLabel.text = [NSString stringWithFormat:@"1/%d", _product.goodsImagesList.count];
    }];
    
    [_product loadShop:^(BOOL result) {
        if (result) {
            [_shopLogoImageView setImageWithURLString:_product.shopLogo];
            _shopNameLabel.text = _product.shopName;
            _shopScoreLabel.text = [NSString stringWithFormat:@"店铺评分：%@", _product.score];
        }
    }];
    
    [_product loadStore:^(BOOL result) {
        if (result) {
            JRStore *store = [_product.stallInfoList firstObject];
            if (store) {
                _storeNameLabel.text = store.stallName;
                CLLocation *location = [[CLLocation alloc] initWithLatitude:store.latitude longitude:store.longitude];
                double distance = [ApplicationDelegate.gLocation.location distanceFromLocation:location];
                _storeLocationLabel.text = [NSString stringWithFormat:@"%.2fkm", distance/1000];
            }
        }
    }];
    
    [_product loadDesc:^(BOOL result) {
        if (result) {
            [_webView loadHTMLString:_product.pcDesc];
        }
    }];
}

- (IBAction)onBack:(id)sender{
    [super back:sender];
}

- (IBAction)onMore:(id)sender{
}

- (IBAction)onShop:(id)sender{
    ShopHomeViewController *sv = [[ShopHomeViewController alloc] init];
    JRShop *shop = [[JRShop alloc] init];
    shop.shopId = _product.shopId;
    sv.shop = shop;
    [self.navigationController pushViewController:sv animated:YES];
}

- (IBAction)onPrivate:(id)sender{
    ProductLetterViewController *pl = [[ProductLetterViewController alloc] init];
    pl.product = _product;
    [self.navigationController pushViewController:pl animated:YES];
}

- (IBAction)onFavority:(id)sender{
    [_product favority:^(BOOL result) {
        if (result) {
            [self setupFavority];
        }
    }];
}

- (void)setupFavority{
    [_favorityButton setImage:[UIImage imageNamed:_product.type ? @"icon-collection-active" : @"icon-collection"] forState:UIControlStateNormal];
    [_favorityButton setTitle:_product.type ? @"已收藏" : @"收藏" forState:UIControlStateNormal];
    _favorityButton.titleEdgeInsets = UIEdgeInsetsMake(30, -20, 0, 0);
    _favorityButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 20, 0);
}

- (void)segmentControl:(JRSegmentControl *)segment changedSelectedIndex:(NSInteger)index{
    [_webView removeFromSuperview];
    [_detailTableView removeFromSuperview];
    
    if (segment.selectedIndex == 0) {
        [_scrollView addSubview:_webView];
    }else{
        [_scrollView addSubview:_detailTableView];
        [_detailTableView reloadData];
    }
    
    if (segment.selectedIndex == 1 && !_product.goodsAttributesInfoList) {
        [self showHUD];
        [_product loadAttribute:^(BOOL result) {
            [self hideHUD];
            if (result) {
                [_detailTableView reloadData];
            }
        }];
    }else if (segment.selectedIndex == 2 && _products == nil){
        NSDictionary *param = @{@"shopId": @(_product.shopId)};
        [self showHUD];
        [[ALEngine shareEngine] pathURL:JR_SHOP_RECOMMEND parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
            [self hideHUD];
            if (!error) {
                NSArray *recommendProductsList = [data objectForKey:@"recommendProductsList"];
                self.products = [JRProduct buildUpWithValueForList:recommendProductsList];
                [_detailTableView reloadData];
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:_baseTableView]) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if ([tableView isEqual:_baseTableView]) {
        if (section == 0) {
            count = 2;
        }else{
            count = 1;
        }
    }else if ([tableView isEqual:_detailTableView]){
        if (_segCtl.selectedIndex == 1) {
            count = _product.goodsAttributesInfoList.count;
        }else{
            count = _products.count;
        }
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:_baseTableView]) {
        if (section == 0) {
            return 1;
        }
        return 10;
    }else{
        if (_segCtl.selectedIndex == 1) {
            return 10;
        }
        
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat heigth = 44;
    if ([tableView isEqual:_baseTableView] && indexPath.section == 1) {
        heigth = CGRectGetHeight(_shopView.frame);
    }else if ([tableView isEqual:_detailTableView] && _segCtl.selectedIndex == 2){
        heigth = 100;
    }
    return heigth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_detailTableView] && _segCtl.selectedIndex == 2) {
        static NSString *CellIdentifier = @"ProductCell";
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (ProductCell *)[nibs firstObject];
        }
        
        JRProduct *product = _products[indexPath.row];
        [cell fillCellWithProduct:product];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        
        if ([tableView isEqual:_baseTableView]) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"查看颜色/尺寸";
                }else if (indexPath.row == 1){
                    cell.textLabel.text = @"可售门店";
                    _locationView.backgroundColor = [UIColor clearColor];
                    [_locationView removeFromSuperview];
                    [cell addSubview:_locationView];
                }
            }else if (indexPath.section == 1){
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [_shopView removeFromSuperview];
                [cell addSubview:_shopView];
            }
        }else{
            if (_segCtl.selectedIndex == 1) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSDictionary *dict = _product.goodsAttributesInfoList[indexPath.row];
                cell.textLabel.text = dict[@"attributeKey"];
                cell.detailTextLabel.text = dict[@"attributeValue"];
            }
        }
        
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_detailTableView] && _segCtl.selectedIndex == 2) {
        ProductDetailViewController *pd = [[ProductDetailViewController alloc] init];
        pd.product = _products[indexPath.row];
        [self.navigationController pushViewController:pd animated:YES];
    }else if ([tableView isEqual:_baseTableView]){
        if (indexPath.section == 0 && indexPath.row == 0) {
            if (_product.attributeList) {
                
            }else{
                [_product loadAttributeList:^(BOOL result) {
                    
                }];
            }
            
        }else if (indexPath.section == 0 && indexPath.row == 1){
            JRStore *store = [_product.stallInfoList firstObject];
            if (store) {
                NaviStoreInfoViewController *st = [[NaviStoreInfoViewController alloc] init];
                st.store = store;
                st.naviType = NaviTypeStall;
                [self.navigationController pushViewController:st animated:YES];
            }
            
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_scrollView]) {
        _navigationView.backgroundColor = [UIColor colorWithWhite:1 alpha: (scrollView.contentOffset.y >= 320 ? 1 : 0)];
    }
//    else if ([scrollView isEqual:_baseTableView]){
//        _navigationView.backgroundColor = [UIColor colorWithWhite:1 alpha:_baseTableView.contentOffset.y/320.0];
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_imageScrollView]) {
        _countLabel.text = [NSString stringWithFormat:@"%d/%d", (NSInteger)(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame) + 1), _product.goodsImagesList.count];
    }
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
