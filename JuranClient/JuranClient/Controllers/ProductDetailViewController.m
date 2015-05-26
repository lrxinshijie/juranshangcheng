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
#import "AttributeCell.h"
#import "UIViewController+Menu.h"
#import "ShareView.h"
#import "UIImageView+Block.h"
#import "ProductPhotoBrowserViewController.h"

@interface ProductDetailViewController () <UITableViewDelegate, UITableViewDataSource, JRSegmentControlDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *baseTopView;
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

@property (nonatomic, strong) IBOutlet UIView *attributePopView;
@property (nonatomic, strong) IBOutlet UITableView *attributeTableView;
@property (nonatomic, strong) IBOutlet UIView *attributeHeaderView;
@property (nonatomic, strong) IBOutlet UIView *attributeFooterView;
@property (nonatomic, strong) IBOutlet UIImageView *attributeImageView;
@property (nonatomic, strong) IBOutlet UILabel *attributeNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *attributePriceLabel;

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) ALWebView *webView;
@property (nonatomic, strong) NSArray *products;

@property (nonatomic, strong) JRSegmentControl *segCtl;

@end

@implementation ProductDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _baseTableView.delegate = nil; _baseTableView.dataSource = nil;
    _attributeTableView.delegate = nil; _attributeTableView.dataSource = nil;
    _detailTableView.delegate = nil; _detailTableView.dataSource = nil;
    _webView.delegate = nil;
    _imageScrollView.delegate = nil;
    _scrollView.delegate = nil;
    _segCtl.delegate = nil;
}

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [super viewDidLoad];
    _fromRow = -1;
    // Do any additional setup after loading the view from its nib.
//    _navigationView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAttributeRow:) name:kNotificationNameAttributeRowReload object:nil];
    [self setupUI];

    [self loadData];
}

- (void)reloadAttributeRow:(NSNotification *)noti{
    if ([noti.object isKindOfClass:[NSIndexPath class]]) {
//        NSIndexPath *indexPath = noti.object;
//        ASLog(@"%d,%d",indexPath.section, indexPath.row);
        [_attributeTableView reloadRowsAtIndexPaths:@[noti.object] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)reloadPrice:(NSInteger)fromRow{
    self.fromRow = fromRow;
    
    NSMutableArray *attributeList = [NSMutableArray array];
    [_product.attributeList enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        NSString *attValue = [dict[@"attrList"] objectAtTheIndex:[_attributeSelected[idx] intValue]];
        NSInteger attrId = [dict[@"attrId"] integerValue];
        
        if (attValue.length > 0) {
            NSDictionary *row = @{@"attId": @(attrId),
                                  @"attValue": attValue ? attValue : @""};
            [attributeList addObject:row];
        }
        
    }];
    
    if (attributeList.count != [_attributeSelected count]) {
        [_attributeTableView reloadData];
        return;
    }
    
    [self showHUD];
    NSDictionary *param = @{@"linkProductId": @(_product.linkProductId),
                            @"attributeList": attributeList};
    [[ALEngine shareEngine] pathURL:JR_PRODUCT_CHANGE_PRICE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSString *price = [data getStringValueForKey:@"goodsprice" defaultValue:@""];
            _attributePriceLabel.text = [price isEqual:@""]?_product.priceString:[NSString stringWithFormat:@"￥%@",  price];
//            NSString *goodsImage = [data getStringValueForKey:@"goodsImage" defaultValue:@""];
//            goodsImage = [goodsImage isEqual:@""] ? _product.goodsImagesList[0]:goodsImage;
            [_attributeImageView setImageWithURLString:data[@"goodsImage"] Editing:YES];
        }
        [_attributeTableView reloadData];
    }];
}

- (void)setupUI{
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)*2);
    _scrollView.backgroundColor = RGBColor(237, 237, 237);
    _scrollView.delegate = self;

    _imageScrollView.delegate = self;
    _imageScrollView.pagingEnabled = YES;
    
    self.baseTableView = [self.scrollView tableViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.tableHeaderView = _titleView;
    _baseTableView.tableFooterView = _tipsView;
    [_scrollView addSubview:_baseTableView];
    [_scrollView addSubview:_baseTopView];
//    [_scrollView addSubview:_tipsView];
    
//    CGRect frame = _tipsView.frame;
//    frame.origin.y = CGRectGetMaxY(_baseTableView.frame);
//    _tipsView.frame = frame;
    
    CGRect frame = _navigationView.frame;
    frame.origin.y = CGRectGetHeight(_scrollView.frame);
    _navigationView.frame = frame;
    [_scrollView addSubview:_navigationView];
    
    self.segCtl = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_scrollView.frame) + CGRectGetHeight(_navigationView.frame) + 1, CGRectGetWidth(_scrollView.frame), 44)];
    _segCtl.titleList = @[@"商品详情", @"商品参数", @"店铺推荐"];
    _segCtl.delegate = self;
    _segCtl.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_segCtl];
    
    self.webView = [[ALWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segCtl.frame), CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame) - CGRectGetHeight(_navigationView.frame) - 45)];
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_webView];
    //[self.webView setScalesPageToFit:YES];
    self.detailTableView = [self.scrollView tableViewWithFrame:_webView.frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _detailTableView.backgroundColor = [UIColor clearColor];
    
    _attributePriceLabel.hidden = ![JRProduct isShowPrice];
    _priceLabel.hidden = ![JRProduct isShowPrice];
}

- (void)loadData{
    
    [self showHUD];
    
    [_product loadInfo:^(BOOL result) {
        
        [self hideHUD];
        [self setupAttributeView];
        if (!result) {
            return ;
        }
        
        [self setupFavority];
        
        [_shopLogoImageView setImageWithURLString:_product.shopLogo];
        _shopNameLabel.text = _product.shopName;
        _shopScoreLabel.text = [NSString stringWithFormat:@"店铺评分：%@", _product.score];

        _nameLabel.text = _product.goodsName;
        CGRect frame = _nameLabel.frame;
        CGFloat height = [_nameLabel.text heightWithFont:_nameLabel.font constrainedToWidth:CGRectGetWidth(frame)];
        if (height >= 35) {
            height = 35;
        }
        frame.size.height = height;
        _nameLabel.frame = frame;
        
        _priceLabel.text = _product.priceString;
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
            [imageView setImageWithURLString:imageUrl placeholderImage:nil editing:YES];
            __weak typeof(self) weakSelf = self;
            [imageView setOnTap:^{
                ProductPhotoBrowserViewController *vc = [[ProductPhotoBrowserViewController alloc] initWithPhotos:weakSelf.product.goodsImagesList andStartWithPhotoAtIndex:idx];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            [_imageScrollView addSubview:imageView];
        }];
        
        _countLabel.text = [NSString stringWithFormat:@"1/%d", _product.goodsImagesList.count];
    }];
    
    [_product loadStore:^(BOOL result) {
        if (result) {
            JRStore *store = [_product.stallInfoList firstObject];
            if (store) {
                _storeNameLabel.text = store.stallName;
                CLLocation *location = [[CLLocation alloc] initWithLatitude:store.latitude longitude:store.longitude];
#ifndef kJuranDesigner
                double distance = [ApplicationDelegate.gLocation.location distanceFromLocation:location];
                _storeLocationLabel.text = [NSString stringWithFormat:@"%.2fkm", distance/1000];
                _storeLocationLabel.adjustsFontSizeToFitWidth = YES;
#endif
                [_baseTableView reloadData];
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

- (IBAction)onSearch:(id)sender{
    [super onSearch];
}

- (IBAction)onMore:(id)sender{
    [self showAppMenu:^{
        NSString *content = self.product.goodsName;
//        if (content.length == 0) {
//            content = @"商品分享测试";
//        }
        [[ShareView sharedView] showWithContent:content image:[Public imageURLString:self.product.goodsImagesList[0]] title:@"居然有这么好的商品，大家快来看看~" url:self.shareURL];
    }];
}

- (NSString *)shareURL{
    return [NSString stringWithFormat:@"http://mall.juran.cn/product/%d.htm",self.product.linkProductId];
}

- (IBAction)onShop:(id)sender{
    ShopHomeViewController *sv = [[ShopHomeViewController alloc] init];
    JRShop *shop = [[JRShop alloc] init];
    shop.shopId = _product.shopId;
    sv.shop = shop;
    [self.navigationController pushViewController:sv animated:YES];
}

- (IBAction)onPrivate:(id)sender{
    if ([self checkLogin:^{
        [[JRUser currentUser] postPrivateLetterWithUserId:_product.shopId Target:_product VC:self];
    }]) {
        [[JRUser currentUser] postPrivateLetterWithUserId:_product.shopId Target:_product VC:self];
    }
}

- (IBAction)onFavority:(id)sender{
    [_product favority:^(BOOL result) {
        if (result) {
            [self setupFavority];
        }
    }];
}

- (void)setupFavority{
    [_favorityButton setImage:[UIImage imageNamed:_product.type ? @"icon-collection-active" : @"icon-collection1"] forState:UIControlStateNormal];
    [_favorityButton setTitle:_product.type ? @"已收藏" : @"收藏" forState:UIControlStateNormal];
    _favorityButton.titleEdgeInsets = UIEdgeInsetsMake(30, -20, 0, 0);
    _favorityButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 20, 0);
}

- (void)setupAttributeView{
    _attributeNameLabel.text = _product.goodsName;
    [_attributeImageView setImageWithURLString:_product.goodsImagesList[0]];
    _attributePriceLabel.text = _product.priceString;
//    _attributePriceLabel.text = [NSString stringWithFormat:@"￥%@", [@([_product.onSaleMinPrice intValue]) decimalNumberFormatter]];
    
    CGRect frame = _attributeNameLabel.frame;
    frame.size.height = [_attributeNameLabel.text heightWithFont:_attributeNameLabel.font constrainedToWidth:CGRectGetWidth(frame)];
    _attributeNameLabel.frame = frame;
    frame = _attributePriceLabel.frame;
    frame.origin.y = CGRectGetMaxY(_attributeNameLabel.frame) + 3;
    _attributePriceLabel.frame = frame;
    
//    frame = _attributePopView.frame;
//    frame = _scrollView.bounds;
    _attributePopView.frame = _scrollView.bounds;
    
//    _attributeTableView.tableHeaderView = _attributeHeaderView;
    _attributeTableView.tableFooterView = [[UIView alloc] init];
    _attributeTableView.bounces = NO;
    
    frame = _attributeTableView.frame;
    frame.size.height = 351;
    frame.origin.y = CGRectGetHeight(_attributePopView.frame) - CGRectGetHeight(frame);
    _attributeTableView.frame = frame;
}

- (void)showAttributeView{
    [self.view addSubview:_attributePopView];
}

- (IBAction)hideAttributeView:(id)sender{
    [_attributePopView removeFromSuperview];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:_attributeTableView]) {
        return _attributeHeaderView;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if ([tableView isEqual:_baseTableView]) {
        if (section == 0) {
            if (_product.stallInfoList.count > 0)
                count = 2;
            else
                count = 1;
        }else{
            count = 1;
        }
    }else if ([tableView isEqual:_detailTableView]){
        if (_segCtl.selectedIndex == 1) {
            count = _product.goodsAttributesInfoList.count;
        }else{
            count = _products.count;
        }
    }else if ([tableView isEqual:_attributeTableView]){
        count = _product.attributeList.count;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:_baseTableView]) {
        if (section == 0) {
            return 1;
        }
        return 10;
    }else if ([tableView isEqual:_attributeTableView]) {
        return CGRectGetHeight(_attributeHeaderView.frame);
    }else {
        if (_segCtl.selectedIndex == 1) {
            return 10;
        }
        
        return 1;
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat heigth = 44;
    if ([tableView isEqual:_baseTableView] && indexPath.section == 1) {
        heigth = CGRectGetHeight(_shopView.frame);
    }else if ([tableView isEqual:_detailTableView] && _segCtl.selectedIndex == 2){
        heigth = 100;
    }else if ([tableView isEqual:_attributeTableView]){
        heigth = [_attributeHeights[indexPath.row] floatValue];
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
    }else if ([tableView isEqual:_attributeTableView]){
        static NSString *CellIdentifier = @"AttributeCell";
        AttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (AttributeCell *)[nibs firstObject];
        }
        cell.viewController = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        NSDictionary *dict = _product.attributeList[indexPath.row];
        [cell fillCellWithDict:dict];
        
        return cell;
    }else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        
        if ([tableView isEqual:_baseTableView]) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"查看 颜色/尺寸";
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
        }else {
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
                if (!_attributeSelected) {
                    self.attributeSelected = [NSMutableArray array];
                    self.attributeHeights = [NSMutableArray array];
                    [_product.attributeList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [_attributeSelected addObject:@(-1)];
                        [_attributeHeights addObject:@([AttributeCell cellHeight])];
                    }];
                    [_attributeTableView reloadData];
                }
                
//                CGRect frame = _attributeTableView.frame;
//                frame.size.height = _product.attributeList.count * [AttributeCell cellHeight] + CGRectGetHeight(_attributeHeaderView.frame) + 1;
//                frame.origin.y = CGRectGetHeight(_attributePopView.frame) - CGRectGetHeight(frame);
//                _attributeTableView.frame = frame;
                
                [self showAttributeView];
            }else{
                [self showHUD];
                [_product loadAttributeList:^(BOOL result) {
                    [self hideHUD];
                    if (result) {
                        self.attributeSelected = [NSMutableArray array];
                        self.attributeHeights = [NSMutableArray array];
                        [_product.attributeList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            [_attributeSelected addObject:@(-1)];
                            [_attributeHeights addObject:@([AttributeCell cellHeight])];
                        }];
//                        CGRect frame = _attributeTableView.frame;
//                        frame.size.height = _product.attributeList.count * [AttributeCell cellHeight] + CGRectGetHeight(_attributeHeaderView.frame) + 1;
//                        frame.origin.y = CGRectGetHeight(_attributePopView.frame) - CGRectGetHeight(frame);
//                        _attributeTableView.frame = frame;
                        [_attributeTableView reloadData];
                        [self showAttributeView];
                    }
                }];
            }
            
        }else if (indexPath.section == 0 && indexPath.row == 1){
//            JRStore *store = [_product.stallInfoList firstObject];
//            if (store) {
//                NaviStoreInfoViewController *st = [[NaviStoreInfoViewController alloc] init];
//                st.store = store;
//                st.naviType = NaviTypeStall;
//                [self.navigationController pushViewController:st animated:YES];
//            }
            if (_product.stallInfoList.count > 0) {
                NaviStoreListViewController *vc = [[NaviStoreListViewController alloc]init];
                vc.naviType = NaviTypeStall;
                vc.shopId = _product.shopId;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                //[self showTip:@"该店铺没有关联实体店"];
            }
        }
    }
    
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
