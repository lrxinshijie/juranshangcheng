//
//  HomeViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "HomeViewController.h"
#import "NewestBidInfoCell.h"
#import "JRDemand.h"
#import "JRDesigner.h"
#import "EScrollerView.h"
#import "DesignerDetailViewController.h"
#import "DesignerViewController.h"
#import "JRAdInfo.h"
#import "JRWebViewController.h"
#import "SubjectDetailViewController.h"
#import "CaseViewController.h"
#import "JRPhotoScrollViewController.h"
#import "JRSubject.h"
#import "QuestionViewController.h"
#import "NewestTopicViewController.h"
#import "PrivateMessageViewController.h"
#import "BidListViewController.h"
#import "DemandDetailViewController.h"

#define kDesignerViewTag 1100

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) IBOutlet UIView *tempView;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *adInfos;
@property (nonatomic, strong) EScrollerView *bannerView;

@property (nonatomic, assign) NSInteger privateMsgCount;
@property (nonatomic, strong) IBOutlet UILabel *privateMsgCountLabel;

@end

@implementation HomeViewController

- (void)dealloc{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReloadDataNotification:) name:kNotificationNameMyDemandReloadData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveProfileReloadDataNotification:) name:kNotificationNameProfileReloadData object:nil];
    
    [self setupUI];
    
//    [self configureLeftBarButtonItemImage:[UIImage imageNamed:@"navbar_leftbtn_logo"] leftBarButtonItemAction:nil];
    [self configureMenu];
    
    [self configureSearch];
    
    [_tableView headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([JRUser isLogin]) {
        [self loadPrivateMsgData];
    }else{
        self.privateMsgCount = 0;
    }
}

- (void)receiveReloadDataNotification:(NSNotification*)notification{
    [_tableView headerBeginRefreshing];
}

- (void)receiveProfileReloadDataNotification:(NSNotification*)notification{
    [self loadPrivateMsgData];
}

- (void)setupUI{
    _privateMsgCountLabel.layer.masksToBounds = YES;
    _privateMsgCountLabel.layer.cornerRadius = _privateMsgCountLabel.frame.size.width / 2.f;
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = _tableHeaderView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadAd];
        [weakSelf loadDemandData];
        [weakSelf loadNewestDesignerData];
        [weakSelf loadPrivateMsgData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadDemandData];
    }];
}

- (void)loadPrivateMsgData{
//    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_INDEX_PRIVATELETTERREP parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyShowErrorDefaultMessage: @(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            self.privateMsgCount = [data getIntValueForKey:@"count" defaultValue:0];
        }
    }];
}

- (void)loadAd{
    NSDictionary *param = @{@"adCode": @"app_designer_index_roll",
                            @"areaCode": @"110000",
                            @"type": @(8)};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_GET_BANNER_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *bannerList = [data objectForKey:@"bannerList"];
            if (bannerList.count > 0) {
                self.adInfos = [JRAdInfo buildUpWithValue:bannerList];
                //                [_adInfos addObjectsFromArray:_adInfos];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reSetAdView];
        });
    }];
}

- (void)loadDemandData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": kOnePageCount};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_GET_INDEX_DESIGN_REQ_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *demandList = [data objectForKey:@"designReqGeneralList"];
            NSMutableArray *rows = [JRDemand buildUpWithValueForDesigner:demandList];
            if (_currentPage > 1) {
                [_demandDatas addObjectsFromArray:rows];
            }else{
                self.demandDatas = rows;
            }
            
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (void)loadNewestDesignerData{
    NSDictionary *param = @{@"count": @"4"};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_GET_INDEX_DESIGNER_LIST_REQ parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            self.designerDatas = [JRDesigner buildUpWithValue:[data objectForKey:@"designerList"]];
            
            [self reloadNesestDesignerData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (void)reSetAdView{
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
    if (self.adInfos.count > 0) {
        self.bannerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, kWindowWidth, 165) ImageArray:_adInfos Aligment:PageControlAligmentCenter];
        _bannerView.delegate = self;
        [_tableHeaderView addSubview:_bannerView];
        _tempView.frame = CGRectMake(0, CGRectGetMaxY(_bannerView.frame),  CGRectGetWidth(_tempView.frame), CGRectGetHeight(_tempView.frame));
    }else{
        _tempView.frame = CGRectMake(0, 0, CGRectGetWidth(_tempView.frame), CGRectGetHeight(_tempView.frame));
    }
    _tableHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(_tableHeaderView.frame), CGRectGetMaxY(_tempView.frame));
    _tableView.tableHeaderView = _tableHeaderView;
}

- (void)reloadNesestDesignerData{
    NSInteger i = 0;
    for (JRDesigner *d in _designerDatas) {
        UIImageView *imageView = (UIImageView*)[_tempView viewWithTag:kDesignerViewTag + i * 2];
        if (d.headUrl.length > 0) {
            [imageView setImageWithURLString:d.headUrl];
        }else{
            imageView.image = [UIImage imageNamed:@"unlogin_head.png"];
        }
        
        
        UILabel *label = (UILabel*)[_tempView viewWithTag:kDesignerViewTag + i*2 + 1];
        label.text = [d formatUserName];
        
        UIButton *btn = (UIButton*)[_tempView viewWithTag:kDesignerViewTag + 8 + i];
        btn.enabled = YES;
        
        i++;
    }
    
    for (; i < 4; i++) {
        UIImageView *imageView = (UIImageView*)[_tempView viewWithTag:kDesignerViewTag + i * 2];
        imageView.image = nil;
        
        UILabel *label = (UILabel*)[_tempView viewWithTag:kDesignerViewTag + i*2 + 1];
        label.text = @"";
        
        UIButton *btn = (UIButton*)[_tempView viewWithTag:kDesignerViewTag + 8 + i];
        btn.enabled = NO;
    }
}

- (void)setPrivateMsgCount:(NSInteger)privateMsgCount{
    _privateMsgCount = privateMsgCount;
    _privateMsgCountLabel.hidden = !privateMsgCount;
    _privateMsgCountLabel.text = [NSString stringWithFormat:@"%d", _privateMsgCount];
}

#pragma mark - TargetAction

- (IBAction)onDesignerDetail:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSInteger index = btn.tag - kDesignerViewTag - 8;
    DesignerDetailViewController *vc = [[DesignerDetailViewController alloc] init];
    vc.designer = _designerDatas[index];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBid:(id)sender{
    BidListViewController *vc = [[BidListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onQuestion:(id)sender{
    QuestionViewController *vc = [[QuestionViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTopic:(id)sender{
    NewestTopicViewController *vc = [[NewestTopicViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onPrivateLetter:(id)sender{
    if (![self checkLogin:^{
        [self loadPrivateMsgData];
    }]) {
        return;
    }
    
    PrivateMessageViewController *pv = [[PrivateMessageViewController alloc] init];
    self.privateMsgCount = 0;
    pv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pv animated:YES];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _demandDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87 + ((indexPath.row == _demandDatas.count - 1)?5:0);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"NewestBidInfoCell";
    NewestBidInfoCell *cell = (NewestBidInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (NewestBidInfoCell *)[nibs firstObject];
    }
    
    JRDemand *d = _demandDatas[indexPath.row];
    [cell fillCellWithData:d];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JRDemand *demand = _demandDatas[indexPath.row];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    DemandDetailViewController *vc = [[DemandDetailViewController alloc] init];
    vc.demand = demand;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma EScrollerViewDelegate

- (void)EScrollerViewDidClicked:(NSUInteger)index{
    
    JRAdInfo *ad = [_adInfos objectAtIndex:index];
    ASLog(@"index:%d,%@",index,ad.link);
    
    [Public jumpFromLink:ad.link];
}

@end
