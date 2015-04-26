//
//  MyCollectViewController.m
//  JuranClient
//
//  Created by HuangKai on 15-4-14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "MyCollectViewController.h"
#import "JRCase.h"
#import "CaseCollectionCell.h"
#import "JRPhotoScrollViewController.h"
#import "JRSegmentControl.h"
#import "JRShop.h"
#import "JRProduct.h"
#import "AppDelegate.h"
#import "UserLocation.h"
#import "ProductCollectionCell.h"
#import "ShopCollectionCell.h"
#import "ShopHomeViewController.h"
#import "ProductDetailViewController.h"

@interface MyCollectViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JRSegmentControlDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet JRSegmentControl *segment;

@property (nonatomic, strong) IBOutlet UIView *emptyView;

@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"我的收藏";
    
    [self setupUI];
    
    [_collectionView headerBeginRefreshing];
}

- (void)setupUI{
    _segment.showUnderLine = YES;
    _segment.delegate = self;
    [_segment setTitleList:@[@"案例收藏" ,@"商品收藏", @"店铺收藏"]];
    
    _collectionView.backgroundColor = RGBColor(237, 237, 237);
    _collectionView.alwaysBounceVertical = YES;
    
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, CGRectGetHeight(_segment.frame), kWindowWidth, kWindowHeightWithoutNavigationBar - CGRectGetHeight(_segment.frame)) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(237, 237, 237);
    _tableView.hidden = YES;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"ProductCollectionCell" bundle:nil] forCellReuseIdentifier:@"ProductCollectionCell"];
    [self.view addSubview:_tableView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CaseCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CaseCollectionCell"];
    
    __weak typeof(self) weakSelf = self;
    [_collectionView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_collectionView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    _emptyView.hidden = YES;
    [self.view addSubview:_emptyView];
    _emptyView.center = self.view.center;
}

- (NSString *)urlString{
    if (_segment.selectedIndex == 0) {
        return JR_FAV_PROJECT;
    }else if (_segment.selectedIndex == 1){
        return JR_GOODS_COLLECTION;
    }else if (_segment.selectedIndex == 2){
        return JR_GET_SHOP_COLLECTION_LIST;
    }
    return @"";
}

- (NSDictionary*)param{
    if (_segment.selectedIndex == 0) {
        return @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": kOnePageCount, @"projectType" : @"01"};
    }else if (_segment.selectedIndex == 1){
        return @{@"cityName": [(AppDelegate*)ApplicationDelegate gLocation].cityName};
    }
    return nil;
}

- (void)loadData{
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:[self urlString] parameters:[self param] HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if (_segment.selectedIndex == 0) {
                NSArray *projectList = [data objectForKey:@"projectGeneralDtoList"];
                NSMutableArray *rows = [JRCase buildUpWithValue:projectList];
                if (_currentPage > 1) {
                    [_datas addObjectsFromArray:rows];
                }else{
                    self.datas = rows;
                }
            }else if (_segment.selectedIndex == 1) {
                self.datas = [JRProduct buildUpWithValueForCollection:[data objectForKey:@"goodsList"]];
            }else if (_segment.selectedIndex == 2) {
                self.datas = [JRShop buildUpWithValueForCollection:[data objectForKey:@"shopList"]];
            }
        }
        [self reloadData];
        [_collectionView headerEndRefreshing];
        [_collectionView footerEndRefreshing];
    }];
}

- (void)reloadData{
    if (_segment.selectedIndex == 0) {
        [_collectionView reloadData];
    }else{
        [_tableView reloadData];
    }
    _emptyView.hidden = _datas.count != 0;
}

#pragma mark - JRSegmentControl

- (void)segmentControl:(JRSegmentControl *)segment changedSelectedIndex:(NSInteger)index{
    _collectionView.hidden = index != 0;
    _tableView.hidden = index == 0;
    if (_datas.count > 0) {
        [_datas removeAllObjects];
        [_collectionView reloadData];
        [_tableView reloadData];
    }
    if (index == 0) {
        [_collectionView headerBeginRefreshing];
    }else{
        [self loadData];
    }
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedIndex == 1) {
        return 100;
    }else if (_segment.selectedIndex == 2){
        return 60;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedIndex == 1) {
        ProductCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCollectionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        JRProduct *p = [_datas objectAtIndex:indexPath.row];
        [cell fillCellWithValue:p];
        return cell;
    }else if (_segment.selectedIndex == 2){
        ShopCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCollectionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        JRShop *s = [_datas objectAtIndex:indexPath.row];
        [cell fillCellWithValue:s];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_segment.selectedIndex == 1) {
        JRProduct *p = _datas[indexPath.row];
        ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
        vc.product = p;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_segment.selectedIndex == 2){
        ShopHomeViewController *sv = [[ShopHomeViewController alloc] init];
        sv.shop = _datas[indexPath.row];
        [self.navigationController pushViewController:sv animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource/Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_datas count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseCollectionCell";
    CaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    JRCase *cs = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithCase:cs];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JRCase *cs = [_datas objectAtIndex:indexPath.row];
    
    JRPhotoScrollViewController *vc = [[JRPhotoScrollViewController alloc] initWithJRCase:cs andStartWithPhotoAtIndex:0];
    vc.hidesBottomBarWhenPushed = YES;
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

@end
