//
//  RootViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "RootViewController.h"
#import "JRCase.h"
#import "CaseCell.h"
#import "CaseDetailViewController.h"
#import "JRAdInfo.h"
#import "EScrollerView.h"
#import "JRPhotoScrollViewController.h"
#import "JRWebViewController.h"
#import "SDWebImageDownloader.h"
#import "UIButton+WebCache.h"
#import "CaseViewController.h"
#import "FitmentViewController.h"
#import "RootMenuCell.h"
#import "GoodsCategaryViewController.h"
#import "SearchViewController.h"
#import "MallViewController.h"
#import "ShopHomeViewController.h"
#import "JRShop.h"
#import "PrivateMessageViewController.h"
#import "ShopListViewController.h"


@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *adInfos;
@property (nonatomic, strong) EScrollerView *bannerView;
@property (nonatomic, strong) IBOutlet UIView *menuView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) NSArray *iconInfoList;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *iconInfoMutableList;
@property (strong, nonatomic) IBOutlet UIView *middleView;

@property(strong,nonatomic) UIScrollView *scrollerView;
@property(strong,nonatomic) UISearchBar *searchBar;

@end

@implementation RootViewController
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo"]];
    
    _collectionView.backgroundColor = kViewBackgroundColor;
    [_collectionView registerNib:[UINib nibWithNibName:@"RootMenuCell" bundle:nil] forCellWithReuseIdentifier:@"RootMenuCell"];
    //_collectionView.contentSize =  CGSizeMake(0, 0);
    
    [self configureScan];
    //[self configureSearchAndMore];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMoreMenu) name:kNotificationNameMsgCenterReloadData object:nil];
    //[self setupUI];
    [self initUI];
    
    
}


-(void)initUI
{
    

    
    _searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(40, 20, 210, 20)];
    _searchBar.center=CGPointMake(kWindowWidth/2, 22);
    [self setSearchTextFieldBackgroundColor:RGBColor(237, 237, 237)];
    _searchBar.delegate = self;
    _searchBar.placeholder=@"请输入搜索关键词";
       //self.navigationItem.titleView=_searchBar;
    [self.navigationController.navigationBar addSubview:_searchBar];
    //self.navigationController
    
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    rightView.clipsToBounds = NO;
    
    
    UIButton *messageButton = [self.view buttonWithFrame:CGRectMake(25, 0, 35, 35) target:self action:@selector(onMsg:) image:[UIImage imageNamed:@"news"]];
    
    
    
    [rightView addSubview:messageButton];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    
    
    
    
    
    _scrollerView=[[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollerView.contentSize=CGSizeMake(0, kWindowHeight+20);
    [self.view addSubview:_scrollerView];
    [self loadMenu];
    [self loadAd];
    //[_collectionView reloadData];
    
}

- (void) onMsg:(id)sender
{
    if (![self checkLogin]) {
        return;
    }
    PrivateMessageViewController *vc = [[PrivateMessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    //    [[ApplicationDelegate tabBarController].viewControllers[4] pushViewController:vc animated:YES];
    //    [ApplicationDelegate.tabBarController setSelectedIndex:4];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //    searchBar.showsCancelButton = YES;
    //    for(id cc in [searchBar subviews])
    //    {
    //        if([cc isKindOfClass:[UIButton class]])
    //        {
    //            UIButton *btn = (UIButton *)cc;
    //            [btn setTitle:@"取消"  forState:UIControlStateNormal];
    //        }
    //    }
    //    NSLog(@"shuould begin");
    SearchViewController  *searchViewController=[[SearchViewController alloc] init];
    
    searchViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchViewController animated:YES];
    
    return YES;
}

- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor
{
    UIView *searchTextField = nil;
    //         if (IQ_IS_IOS7_OR_GREATER) {
    //                 // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    //                 self.barTintColor = [UIColor whiteColor];
    //                 searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    //             } else { // iOS6以下版本searchBar内部子视图的结构不一样
    //                     for (UIView *subView in self.subviews) {
    //                             if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
    //                                     searchTextField = subView;
    //                                 }
    //                         }
    //                 }
    
    _searchBar.barTintColor = [UIColor whiteColor];
    searchTextField = [[[_searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = backgroundColor;
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(237, 237, 237);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = _footerView;
    
    [self loadMenu];
    [self loadAd];
}

- (void)loadAd{
    NSDictionary *param = @{@"adCode": @"app_consumer_mall_index_roll",
                            @"areaCode": @"110000",
                            @"type": @(7)};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_GET_BANNER_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *bannerList = [data objectForKey:@"bannerList"];
            if (_bannerView) {
                [_bannerView removeFromSuperview];
            }
            if (bannerList.count > 0) {
                self.adInfos = [JRAdInfo buildUpWithValue:bannerList];
                self.bannerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, kWindowWidth, 165) ImageArray:_adInfos Aligment:PageControlAligmentRight];
                _bannerView.delegate = self;
                [_headerView addSubview:_bannerView];
                
                CGRect frame = _menuView.frame;
                frame.origin.y = CGRectGetMaxY(self.bannerView.frame);
                _menuView.frame = frame;
            }else{
                CGRect frame = _menuView.frame;
                frame.origin.y = 0;
                _menuView.frame = frame;
            }
            
            //            CGRect frame = _headerView.frame;
            //            frame.size.height = CGRectGetMaxY(_menuView.frame);
            //            _headerView.frame = frame;
            //_tableView.tableHeaderView = _headerView;
            
            
            _headerView.frame=CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBarAndTabbar-164);
            
            [_scrollerView addSubview:_headerView];
            //_footerView.backgroundColor=[UIColor redColor];
            _footerView.frame=CGRectMake(0, _headerView.frame.size.height, kWindowWidth, 164);
            [_scrollerView addSubview:_footerView];
            
            //            _middleView.frame=CGRectMake(0, 165, kWindowWidth, 163);
            //            [self.view addSubview:_middleView];
        }
        //[self loadData];
    }];
}

- (void)loadMenu{
    //    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_HOME_NAVIGATION parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            //            [_menuView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
            //                [subview removeFromSuperview];
            //            }];
            
            _iconInfoList = [[data objectForKey:@"iconInfoList"] copy];
            
            _iconInfoMutableList=[[NSMutableArray alloc] init];
            for (NSDictionary *dic in _iconInfoList) {
                //                NSString *name=[dic getStringValueForKey:@"name" defaultValue:@""];
                
                //                if([name isEqualToString:@"会员需求"] || [name isEqualToString:@"找案例"] || [name isEqualToString:@"找设计师"] || [name isEqualToString:@"家装百科"])
                //                {
                //                    continue;
                //                }
                [_iconInfoMutableList addObject:dic];
                
            }
            
            
            
            
            [_collectionView reloadData];
            //            UIImage *defaultImage = [UIImage imageWithColor:RGBColor(190, 190, 190) size:CGSizeMake(30, 30)];
            //
            //            [_iconInfoList enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            //                NSString *iconImage = [dict getStringValueForKey:@"iconImage" defaultValue:@""];
            ////                NSString *link = [dict getStringValueForKey:@"link" defaultValue:@""];
            //                NSString *name = [dict getStringValueForKey:@"name" defaultValue:@""];
            //
            //
            //                UIButton *btn = [_menuView buttonWithFrame:CGRectMake(80 * (idx % 4), (idx/4)*72, 80, 72) target:self action:@selector(onMenu:) title:name image:defaultImage];
            //                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //                btn.tag = idx;
            ////                btn.backgroundColor = [UIColor redColor];
            //                btn.titleEdgeInsets = UIEdgeInsetsMake(35, -20, 0, 0);
            //                btn.imageEdgeInsets = UIEdgeInsetsMake(-15, 25, 0, 0);
            //                NSString *imageUrl = [NSString stringWithFormat:@"%@/%@", JR_IMAGE_SERVICE, iconImage];
            //                NSLog(@"%@", imageUrl);
            //
            //                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            //                    if (finished && image) {
            //                        UIImage *i = [UIImage image:image fitInSize:CGSizeMake(30, 30)];
            //                        [btn setImage:i forState:UIControlStateNormal];
            //                    }
            //                }];
            //                //[_menuView addSubview:btn];
            //
            ////                *stop = YES;
            //
            //            }];
            
        }
    }];
}

- (void)onMenu:(UIButton *)btn{
    NSDictionary *dict = _iconInfoMutableList[btn.tag];
    NSString *link = [dict getStringValueForKey:@"link" defaultValue:@""];
    [Public jumpFromLink:link];
}

- (IBAction)onMore:(id)sender{
    NSArray *vcs = self.tabBarController.viewControllers;
    if (vcs.count == 5) {
        UINavigationController *nav = [vcs objectAtIndex:1];
        UIViewController *vc = nav.viewControllers.firstObject;
        if ([vc isKindOfClass:[FitmentViewController class]]) {
            [(FitmentViewController*)vc showCase];
            [self.tabBarController setSelectedIndex:1];
        }
    }
    
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", 0],@"onePageCount": kOnePageCount}];
    [param addEntriesFromDictionary:[[DefaultData sharedData] objectForKey:@"caseDefaultParam"]];
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_HOME_CASE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *projectList = [data objectForKey:@"projectGeneralDtoList"];
            NSMutableArray *rows = [JRCase buildUpWithValue:projectList];
            self.datas = rows;
        }
        
        [_tableView reloadData];
    }];
}

- (void)EScrollerViewDidClicked:(NSUInteger)index{
    JRAdInfo *ad = [_adInfos objectAtIndex:index];
    ASLog(@"index:%d,%@",index,ad.link);
    [Public jumpFromLink:ad.link];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [_datas count] - 1) {
        return 280;
    }
    
    return 275;
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _iconInfoMutableList.count-2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RootMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RootMenuCell" forIndexPath:indexPath];
    NSDictionary *dict = _iconInfoMutableList[indexPath.row];
    NSString *iconImage = [dict getStringValueForKey:@"iconImage" defaultValue:@""];
    NSString *name = [dict getStringValueForKey:@"name" defaultValue:@""];
    UIImage *defaultImage = [UIImage imageWithColor:RGBColor(190, 190, 190) size:CGSizeMake(30, 30)];
    [cell.icon setImageWithURLString:iconImage placeholderImage:defaultImage];
    cell.title.text = name;
    cell.title.textColor = RGBColor(102, 102, 102);
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _iconInfoMutableList[indexPath.row];
    NSString *link = [dict getStringValueForKey:@"link" defaultValue:@""];
    [Public jumpFromLink:link];
}
- (IBAction)btnClick:(id)sender {
    
   
    for (NSDictionary *dic in _iconInfoList) {
        NSString *name=[dic getStringValueForKey:@"name" defaultValue:@""];
        
        if([name isEqualToString:@"热卖商品"])
        {
            NSString *link = [dic getStringValueForKey:@"link" defaultValue:@""];
            [Public jumpFromLink:link];
        }
        
    }    
}

- (IBAction)btnNavigationClick:(id)sender {
    
    
    for (NSDictionary *dic in _iconInfoList) {
        NSString *name=[dic getStringValueForKey:@"name" defaultValue:@""];
        
        
        if([name isEqualToString:@"门店导航"])
        {
            NSString *link = [dic getStringValueForKey:@"link" defaultValue:@""];
            [Public jumpFromLink:link];
        }
        
    }
    
}

- (IBAction)btnRecommendClick:(id)sender {
    
    ShopListViewController * vc = [[ShopListViewController alloc] init];
    vc.keyword = @"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnFamousClick:(id)sender {
    GoodsCategaryViewController * good = [[GoodsCategaryViewController alloc] initWithNibName:@"GoodsCategaryViewController" bundle:nil isPopNavHide:NO style:CategaryStyle_Shop];
    good.hidesBottomBarWhenPushed=YES;
      [self.navigationController pushViewController:good animated:YES];
    

}

- (IBAction)btnCOHOClick:(id)sender {
    
    ShopHomeViewController *vc = [[ShopHomeViewController alloc]init];
    JRShop *shop = [[JRShop alloc] init];
    
    shop.shopName=@"丽屋超市";
    shop.shopId=1073;
    shop.grade=@"1";
    shop.logo=@"img/53211c1f498e65e7090848d2.img";
    
    vc.shop = shop;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnServiceClick:(id)sender {
    
    for (NSDictionary *dic in _iconInfoList) {
        NSString *name=[dic getStringValueForKey:@"name" defaultValue:@""];
        
        
        if([name isEqualToString:@"居然服务"])
        {
            NSString *link = [dic getStringValueForKey:@"link" defaultValue:@""];
            [Public jumpFromLink:link];
        }
        
    }

}

- (IBAction)btnBuyClick:(id)sender {
    
    GoodsCategaryViewController * good = [[GoodsCategaryViewController alloc] initWithNibName:@"GoodsCategaryViewController" bundle:nil isPopNavHide:NO style:CategaryStyle_Goods];
    [self.navigationController pushViewController:good animated:YES];

}

- (IBAction)btnRecommentClick:(id)sender {
    
    [self loadCustomService];
}

//JR_CUSTOMER_SERVICE
- (void)loadCustomService{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_CUSTOMER_SERVICE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSString *tel = [data getStringValueForKey:@"telphone" defaultValue:@""];
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }];
}
@end
