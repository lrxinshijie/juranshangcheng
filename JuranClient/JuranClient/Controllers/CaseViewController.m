//
//  CaseViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "CaseViewController.h"
#import "JRCase.h"
#import "CaseCell.h"
#import "CaseDetailViewController.h"
#import "JRAdInfo.h"
#import "EScrollerView.h"
#import "JRPhotoScrollViewController.h"
#import "FilterView.h"
#import "JRWebViewController.h"
#import "DesignerDetailViewController.h"
#import "SubjectDetailViewController.h"
#import "DesignerViewController.h"
#import "JRDesigner.h"
#import "JRSubject.h"
#import "CaseCollectionCell.h"
//#import "YIFullScreenScroll.h"
#import "UIViewController+ScrollingNavbar.h"

//YIFullScreenScrollDelegate,
@interface CaseViewController () <UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate, FilterViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,  AMScrollingNavbarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *adInfos;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) EScrollerView *bannerView;
@property (nonatomic, strong) FilterView *filterView;

@property (nonatomic, strong) IBOutlet UIView *emptyView;
@property (weak, nonatomic) NSLayoutConstraint *headerConstraint;

@end

@implementation CaseViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    if (_isHome) {
#ifdef kJuranDesigner
        self.navigationItem.title = @"案例";
#else
        [self configureMenu];
#endif
        [self configureSearch];
    }else{
        //self.navigationItem.title = @"搜索结果";
        [self configureGoBackPre];
        [self configureMore];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMoreMenu) name:kNotificationNameMsgCenterReloadData object:nil];
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 220, 30)];
        textField.placeholder = @"请输入搜索关键词";
        textField.background = [UIImage imageNamed:@"search_bar_bg_image"];
        textField.font = [UIFont systemFontOfSize:14];
        textField.text = _searchKey;
        textField.textColor = [UIColor darkGrayColor];
        self.navigationItem.titleView = textField;
        CGRect frame = textField.frame;
        frame.size.width  = 30;
        UIImageView *leftView = [[UIImageView alloc]imageViewWithFrame:frame image:[UIImage imageNamed:@"search_magnifying_glass"]];
        leftView.contentMode = UIViewContentModeCenter;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftView;
        [textField addTarget:self action:@selector(textFieldClick:) forControlEvents:UIControlEventEditingDidBegin];
    }
    
    self.filterView = [[FilterView alloc] initWithType:!_isHome ? FilterViewTypeCaseSearch : FilterViewTypeCase defaultData:_filterData];
    _filterView.delegate = self;
    [self.view addSubview:_filterView];
    
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, 44, kWindowWidth, (!_isHome ? kWindowHeightWithoutNavigationBar : kWindowHeightWithoutNavigationBarAndTabbar) -44) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(236, 236, 236);
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
#ifdef kJuranDesigner
        [weakSelf loadData];
#else
        if (weakSelf.isHome) {
            [weakSelf loadAd];
        }else{
            [weakSelf loadData];
        }
#endif
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    [_tableView headerBeginRefreshing];
    
//    if ([Public isDesignerApp]  || !_isHome) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.itemSize = CGSizeMake(152, 133);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:_tableView.frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = RGBColor(236, 236, 236);
        
        [_collectionView registerNib:[UINib nibWithNibName:@"CaseCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CaseCollectionCell"];
        
//        __weak typeof(self) weakSelf = self;
        [_collectionView addHeaderWithCallback:^{
            weakSelf.currentPage = 1;
            [weakSelf loadData];
        }];
        
        [_collectionView addFooterWithCallback:^{
            weakSelf.currentPage++;
            [weakSelf loadData];
        }];
//    }
    
//    self.fullScreenScroll = [[YIFullScreenScroll alloc] initWithViewController:self scrollView:self.tableView style:YIFullScreenScrollStyleFacebook];
//    self.fullScreenScroll.delegate = self;
//    self.fullScreenScroll.shouldHideTabBarOnScroll = NO;
//    self.fullScreenScroll.additionalOffsetYToStartShowing = -44;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // This enables the user to scroll down the navbar by tapping the status bar.
    [self showNavbar];
    
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
    if ([_filterView isShow]) {
        [_filterView showSort];
    }
}

- (void)loadAd{
    NSDictionary *param = @{@"adCode": @"app_consumer_index_roll",
                            @"areaCode": @"110000",
                            @"type": @(7)};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_GET_BANNER_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *bannerList = [data objectForKey:@"bannerList"];
            if (bannerList.count > 0) {
                self.adInfos = [JRAdInfo buildUpWithValue:bannerList];
                //                [_adInfos addObjectsFromArray:_adInfos];
                self.bannerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 44, kWindowWidth, 165) ImageArray:_adInfos Aligment:PageControlAligmentRight];
                _bannerView.delegate = self;
                
                self.tableView.tableHeaderView = _bannerView;
            }
            
        }
        [self loadData];
    }];
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": kOnePageCount}];
    [param addEntriesFromDictionary:self.filterData];
    
    if (_searchKey.length > 0) {
        [param setObject:_searchKey forKey:@"keyword"];
    }
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL: !_isHome ? JR_SEARCH_CASE : JR_PROLIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *projectList = [data objectForKey:@"projectGeneralDtoList"];
            NSMutableArray *rows = [JRCase buildUpWithValue:projectList];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = rows;
            }
        }
        [self reloadData];
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        [_collectionView headerEndRefreshing];
        [_collectionView footerEndRefreshing];
        
    }];
}

- (void)reloadData{
    [_emptyView removeFromSuperview];
    _tableView.tableFooterView = [[UIView alloc] init];
    
//    if ([_datas count] > 5) {
//        self.fullScreenScroll.scrollView = [_tableView superview] ? _tableView : _collectionView;
//    }else{
//        self.fullScreenScroll.scrollView = nil;
//    }
    
    if (_datas.count == 0) {
        if (_tableView.superview) {
            CGRect frame = CGRectMake(0, 0, kWindowWidth, (!_isHome ? kWindowHeightWithoutNavigationBar : kWindowHeightWithoutNavigationBarAndTabbar) -44);
            frame.size.height -= CGRectGetHeight(_tableView.tableHeaderView.frame);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            _emptyView.center = view.center;
            [view addSubview:_emptyView];
            _tableView.tableFooterView = view;
        }else if (_collectionView.superview){
            _emptyView.center = _collectionView.center;
            [self.view addSubview:_emptyView];
        }
    }
    
    [_tableView reloadData];
    [_collectionView reloadData];
}

- (NSMutableDictionary *)filterData{
    if (!_filterData) {
        NSDictionary *param = nil;
        if (_searchKey.length > 0) {
            param = [[DefaultData sharedData] objectForKey:@"caseSearchDefaultParam"];
        }else{
            param = [[DefaultData sharedData] objectForKey:@"caseDefaultParam"];
        }
        _filterData = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    return _filterData;
}

- (void)clickFilterView:(FilterView *)view actionType:(FilterViewAction)action returnData:(NSDictionary *)data{
    if (action == FilterViewActionGrid) {
        if ([_collectionView superview]) {
            [_collectionView removeFromSuperview];
            [self.view addSubview:_tableView];
            [self reloadData];
        } else {
            [_tableView removeFromSuperview];
            [self.view addSubview:_collectionView];
            [self reloadData];
        }
        
    }else{
        [data.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            [_filterData setObject:data[key] forKey:key];
        }];
        
        if (view.isGrid) {
            [_collectionView headerBeginRefreshing];
        }else{
            [_tableView headerBeginRefreshing];
        }
    }
}

- (void)showMenu{
#ifndef kJuranDesigner
   // [self.fullScreenScroll showUIBarsAnimated:YES];
#endif
    [super showMenu];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [_datas count] - 1) {
        return 275;
    }
    
    return 270;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseCell";
    CaseCell *cell = (CaseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CaseCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRCase *c = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithCase:c];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    JRCase *cs = [_datas objectAtIndex:indexPath.row];
    
    JRPhotoScrollViewController *vc = [[JRPhotoScrollViewController alloc] initWithJRCase:cs andStartWithPhotoAtIndex:0];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
   // [self.fullScreenScroll showUIBarsAnimated:YES];
}

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
    
   // [self.fullScreenScroll showUIBarsAnimated:NO];
}

- (void)EScrollerViewDidClicked:(NSUInteger)index{
    
    JRAdInfo *ad = [_adInfos objectAtIndex:index];
    ASLog(@"index:%d,%@",index,ad.link);
    
    [Public jumpFromLink:ad.link];
}

/*
- (void)fullScreenScrollDidLayoutUIBars:(YIFullScreenScroll *)fullScreenScroll{

    
    
//    CGFloat y = 20 - self.navigationController.navigationBar.frame.origin.y;
    
    UIScrollView *view = [_tableView superview] ? _tableView : _collectionView;
    
//    CGFloat y = view.contentOffset.y;
//    if (y <= 88) {
////        y = 88;
//        
//        if (self.navigationController.navigationBar.frame.origin.y == 20) {
//            y = 0;
//        }
//        
//        CGRect frame = _filterView.frame;
//        frame.origin.y = -y;
//        _filterView.frame = frame;
//        
//        CGFloat height = self.tabBarController.tabBar.frame.origin.y - (kWindowHeight - 49);
//        
//        frame = view.frame;
//        frame.origin.y = CGRectGetMaxY(_filterView.frame);
//        frame.size.height = ((!_isHome ? kWindowHeightWithoutNavigationBar : kWindowHeightWithoutNavigationBarAndTabbar) -44) + y + height - 20;
//        view.frame = frame;
//    }else if (self.navigationController.navigationBar.frame.origin.y != -24){
//        
//    }
//    CGFloat y = self.navigationController.navigationBar.frame.origin.y - 20;
    
 
//    CGFloat y = view.contentOffset.y;
//    
//    if (self.navigationController.navigationBar.frame.origin.y == 20) {
//        y = 0;
//    }else if (y > 88) {
//        y = 88;
//    }
//    
//    CGRect frame = _filterView.frame;
//    frame.origin.y = -y;
//    _filterView.frame = frame;
//    
//    CGFloat height = self.tabBarController.tabBar.frame.origin.y - (kWindowHeight - 49);
//    
//    frame = view.frame;
//    frame.origin.y = CGRectGetMaxY(_filterView.frame);
//    frame.size.height = ((!_isHome ? kWindowHeightWithoutNavigationBar : kWindowHeightWithoutNavigationBarAndTabbar) -44) + y + height - 20;
//    view.frame = frame;
 
    
    CGFloat y = -(self.navigationController.navigationBar.frame.origin.y - 20)*2;
    
    ASLog(@"offset:%f,%f,%f", view.contentOffset.y,self.navigationController.navigationBar.frame.origin.y, y);
    
    CGRect frame = _filterView.frame;
    frame.origin.y = -y;
    _filterView.frame = frame;
    
    CGFloat height = self.tabBarController.tabBar.frame.origin.y - (kWindowHeight - 49);
    
    frame = view.frame;
    frame.origin.y = CGRectGetMaxY(_filterView.frame);
    frame.size.height = ((!_isHome ? kWindowHeightWithoutNavigationBar : kWindowHeightWithoutNavigationBarAndTabbar) -44) + y + height - 20;
    view.frame = frame;
    
//    if (y <> 88) {
//        [view setContentOffset:CGPointMake(0, 0)];
//    }
    
//    ASLog(@"size;%f,%f",y, height);
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect tableFrame =  _tableView.frame;
    CGRect filterViewFrame = _filterView.frame;
    
    CGFloat pointY = [scrollView.panGestureRecognizer translationInView:_tableView].y;
    
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
    _tableView.frame = tableFrame;
    
}

@end
