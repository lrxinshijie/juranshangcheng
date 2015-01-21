//
//  WikiOrActivityViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "WikiOrActivityViewController.h"
#import "WikiFilterViewController.h"
#import "JRWiki.h"
#import "WikiCell.h"
#import "ActivityDetailViewController.h"
#import "JRActivity.h"
#import "ActivityCell.h"


@interface WikiOrActivityViewController ()<UITableViewDataSource, UITableViewDelegate, WikiFilterViewControllerDelegate, UIScrollViewDelegate>{
}

@property (nonatomic, strong)  UITableView *wikiTableView;
@property (nonatomic, strong) NSMutableArray *wikiDatas;
@property (nonatomic, assign) NSInteger wikiCurrentPage;

@property (nonatomic, strong)  UITableView *activityTableView;
@property (nonatomic, strong) NSMutableArray *activityDatas;
@property (nonatomic, assign) NSInteger activityCurrentPage;
@property (nonatomic, strong) ActivityCell *activityCell;

@property (nonatomic, strong) UINavigationController *filterViewNav;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *emptyView;

@property (nonatomic, strong) UIButton *wikiButton;
@property (nonatomic, strong) UIButton *activityButton;
@property (nonatomic, strong) UIBarButtonItem *filterButton;

@end

@implementation WikiOrActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.wikiButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSelected:) title:@"家装百科" backgroundImage:nil];
    [_wikiButton setTitleColor:RGBColor(113, 113, 113) forState:UIControlStateNormal];
    [_wikiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.activityButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSelected:) title:@"精选活动" backgroundImage:nil];
    [_activityButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    [_activityButton setTitleColor:RGBColor(113, 113, 113) forState:UIControlStateNormal];
    [_activityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:_wikiButton], [[UIBarButtonItem alloc] initWithCustomView:_activityButton]];
    _wikiButton.enabled = NO;
    _activityButton.enabled = YES;
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onFilter:) title:@"筛选" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.filterButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = _filterButton;
    
    [self setupUI];
    
    [_wikiTableView headerBeginRefreshing];
    [_activityTableView headerBeginRefreshing];
}

- (void)setupUI{
    
    WikiFilterViewController *filterViewController = [[WikiFilterViewController alloc] init];
    filterViewController.delegate = self;
    
    //            filterViewController.selecteds = [NSMutableDictionary dictionaryWithDictionary:_defaultData];
    _filterViewNav = [Public navigationControllerFromRootViewController:filterViewController];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:kContentFrameWithoutNavigationBarAndTabBar];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kWindowWidth * 2, kWindowHeightWithoutNavigationBarAndTabbar);
    
    self.wikiTableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.wikiTableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _wikiTableView.tableFooterView = [[UIView alloc] init];
    [self.scrollView addSubview:_wikiTableView];
    
    __weak typeof(self) weakSelf = self;
    [_wikiTableView addHeaderWithCallback:^{
        weakSelf.wikiCurrentPage = 1;
        [weakSelf loadWikiData];
    }];
    
    [_wikiTableView addFooterWithCallback:^{
        weakSelf.wikiCurrentPage++;
        [weakSelf loadWikiData];
    }];
    
    self.activityTableView = [self.view tableViewWithFrame:CGRectMake(kWindowWidth, 0, kWindowWidth, kWindowHeightWithoutNavigationBarAndTabbar) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.activityTableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _activityTableView.tableFooterView = [[UIView alloc] init];
    [self.scrollView addSubview:_activityTableView];
    
    [_activityTableView addHeaderWithCallback:^{
        weakSelf.activityCurrentPage = 1;
        [weakSelf loadActivityData];
    }];
    
    [_activityTableView addFooterWithCallback:^{
        weakSelf.activityCurrentPage++;
        [weakSelf loadActivityData];
    }];

    _emptyView.hidden = YES;
    _emptyView.center = _wikiTableView.center;
    [self.scrollView addSubview:_emptyView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_wikiTableView reloadData];
}

- (NSMutableDictionary *)filterData{
    if (!_filterData) {
        
        NSDictionary *param = [[DefaultData sharedData] objectForKey:@"wikiDefaultParam"];
        _filterData = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    return _filterData;
}

- (void)clickWikiFilterViewReturnData:(NSDictionary *)data{
    [data.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [_filterData setObject:data[key] forKey:key];
    }];
    
    [_wikiTableView headerBeginRefreshing];
}

- (void)loadWikiData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", _wikiCurrentPage],@"onePageCount": kOnePageCount}];
    [param addEntriesFromDictionary:self.filterData];
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_KNOWLEDGE_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            
            NSMutableArray *rows = [JRWiki buildUpWithValue:[data objectForKey:@"knowledgeList"]];
            
            if (_wikiCurrentPage > 1) {
                [_wikiDatas addObjectsFromArray:rows];
            }else{
                self.wikiDatas = rows;
            }
            [self reloadData];
        }
        [_wikiTableView headerEndRefreshing];
        [_wikiTableView footerEndRefreshing];
    }];
}

- (void)loadActivityData{
    NSString *scope = @"3";
    NSDictionary *param = @{@"activityScope": scope
                            , @"pageNo": [NSString stringWithFormat:@"%d", _activityCurrentPage]
                            , @"onePageCount": kOnePageCount};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_ACTIVITY_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSMutableArray *rows = [JRActivity buildUpWithValue:data[@"infoActivityRespList"]];
            
            if (_activityCurrentPage > 1) {
                [_activityDatas addObjectsFromArray:rows];
            }else{
                self.activityDatas = rows;
            }
            [self reloadData];
        }
        [_activityTableView headerEndRefreshing];
        [_activityTableView footerEndRefreshing];
    }];
}

- (void)reloadData{
    [_wikiTableView reloadData];
    [_activityTableView reloadData];
    if (_scrollView.contentOffset.x == 0) {
        self.navigationItem.rightBarButtonItem = _filterButton;
        _wikiButton.enabled = NO;
        _activityButton.enabled = YES;
        _emptyView.hidden = _wikiDatas.count != 0;
        _emptyView.center = _wikiTableView.center;
    }else if (_scrollView.contentOffset.x == kWindowWidth){
        self.navigationItem.rightBarButtonItem = nil;
        _wikiButton.enabled = YES;
        _activityButton.enabled = NO;
        _emptyView.hidden = _activityDatas.count != 0;
        _emptyView.center = _activityTableView.center;
    }
}

- (void)onSelected:(id)sender{
    UIButton *btn = (UIButton*)sender;
    if (btn == _wikiButton) {
        _scrollView.contentOffset = CGPointMake(0, 0);
    }else if (btn == _activityButton){
        _scrollView.contentOffset = CGPointMake(kWindowWidth, 0);
    }
}

- (void)onFilter:(id)sender{
    [self presentViewController:_filterViewNav animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _wikiTableView) {
        return _wikiDatas.count;
    }else{
        return _activityDatas.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _wikiTableView) {
        static NSString *CellIdentifier = @"WikiCell";
        WikiCell *cell = (WikiCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (WikiCell *)[nibs firstObject];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        JRWiki *wiki = [_wikiDatas objectAtIndex:indexPath.row];
        [cell fillCellWithWiki:wiki];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"ActivityCell";
        ActivityCell *cell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (ActivityCell *)[nibs firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        JRActivity *a = [_activityDatas objectAtIndex:indexPath.row];
        [cell fillCellWithActivity:a];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _wikiTableView) {
        return 80;
    }else{
        JRActivity *a = [_activityDatas objectAtIndex:indexPath.row];
        [self.activityCell fillCellWithActivity:a];
        return self.activityCell.contentView.frame.size.height + ((indexPath.row == _activityDatas.count - 1)?10:0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _wikiTableView) {
        ActivityDetailViewController *vc = [[ActivityDetailViewController alloc] init];
        vc.title = @"家装百科";
        JRWiki *wiki = [_wikiDatas objectAtIndex:indexPath.row];
        vc.urlString = [NSString stringWithFormat:@"http://apph5.juran.cn/wikis/%d%@", wiki.wikiId,[Public shareEnv]];
        vc.hidesBottomBarWhenPushed = YES;
        [vc setShareTitle:wiki.title Content:wiki.title ImagePath:wiki.imageUrl];
        wiki.browseCount++;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JRActivity *a = [_activityDatas objectAtIndex:indexPath.row];
        ActivityDetailViewController *vc = [[ActivityDetailViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"精品活动";
        vc.urlString = [NSString stringWithFormat:@"http://apph5.juran.cn/events/%d%@", a.activityId, [Public shareEnv]];
        [vc setShareTitle:a.activityName Content:a.activityIntro ImagePath:a.activityListUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (ActivityCell*)activityCell{
    if (_activityCell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:self options:nil];
        _activityCell = (ActivityCell *)[nibs firstObject];
    }
    return _activityCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        [self reloadData];
    }
}

@end
