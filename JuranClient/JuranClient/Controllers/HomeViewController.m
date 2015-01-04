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

#define kDesignerViewTag 1100

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, EScrollerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *adInfos;
@property (nonatomic, strong) EScrollerView *bannerView;

@end

@implementation HomeViewController

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
    
    [self setupUI];
    
    [self configureLeftBarButtonItemImage:[UIImage imageNamed:@"navbar_leftbtn_logo"] leftBarButtonItemAction:nil];
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-search"] rightBarButtonItemAction:@selector(onSearch)];
    
    [_tableView headerBeginRefreshing];
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = _tableHeaderView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadAd];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadDemandData];
    }];
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
                self.bannerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, kWindowWidth, 165) ImageArray:_adInfos];
                _bannerView.delegate = self;
                
                [_tableHeaderView addSubview:_bannerView];
            }
            
        }
        [self loadDemandData];
        [self loadNewestDesignerData];
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

- (void)reloadNesestDesignerData{
    NSInteger i = 0;
    for (JRDesigner *d in _designerDatas) {
        UIImageView *imageView = (UIImageView*)[_tableHeaderView viewWithTag:kDesignerViewTag + i * 2];
        [imageView setImageWithURLString:d.headUrl];
        
        UILabel *label = (UILabel*)[_tableHeaderView viewWithTag:kDesignerViewTag + i*2 + 1];
        label.text = [d formatUserName];
        
        UIButton *btn = (UIButton*)[_tableHeaderView viewWithTag:kDesignerViewTag + 8 + i];
        btn.enabled = YES;
        
        i++;
    }
    
    for (; i < 4; i++) {
        UIImageView *imageView = (UIImageView*)[_tableHeaderView viewWithTag:kDesignerViewTag + i * 2];
        imageView.image = nil;
        
        UILabel *label = (UILabel*)[_tableHeaderView viewWithTag:kDesignerViewTag + i*2 + 1];
        label.text = @"";
        
        UIButton *btn = (UIButton*)[_tableHeaderView viewWithTag:kDesignerViewTag + 8 + i];
        btn.enabled = NO;
    }
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
    
}

- (IBAction)onQuestion:(id)sender{
    
}

- (IBAction)onTopic:(id)sender{
    
}

- (IBAction)onPrivateLetter:(id)sender{
    
}

- (void)onSearch{

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma EScrollerViewDelegate

- (void)EScrollerViewDidClicked:(NSUInteger)index{
    
    JRAdInfo *ad = [_adInfos objectAtIndex:index];
    ASLog(@"index:%d,%@",index,ad.link);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSArray *links = [ad.link componentsSeparatedByString:@"&"];
    [links enumerateObjectsUsingBlock:^(NSString *link, NSUInteger idx, BOOL *stop) {
        NSArray *values = [link componentsSeparatedByString:@"="];
        if ([values count] == 2) {
            [param setObject:[values lastObject] forKey:[values firstObject]];
        }
    }];
    ASLog(@"param:%@",param);
    NSInteger type = [param getIntValueForKey:@"type" defaultValue:0];
    if (type == 1) {
        [_tableView headerBeginRefreshing];
    }else if (type == 2){
        if ([param.allKeys containsObject:@"id"]) {
            DesignerDetailViewController *dv = [[DesignerDetailViewController alloc] init];
            JRDesigner *designer = [[JRDesigner alloc] init];
            designer.userId = [param getIntValueForKey:@"id" defaultValue:0];
            dv.designer = designer;
            dv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dv animated:YES];
        }else{
            DesignerViewController *cv = [[DesignerViewController alloc] init];
            NSMutableDictionary *filterData = [NSMutableDictionary dictionaryWithDictionary:param];
            [filterData removeObjectForKey:@"type"];
            [filterData removeObjectForKey:@"isRealAuth"];
            cv.filterData = filterData;
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
        }
    }else if (type == 7){
        JRWebViewController *wv = [[JRWebViewController alloc] init];
        wv.urlString = [param getStringValueForKey:@"url" defaultValue:@""];
        wv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wv animated:YES];
    }else if (type == 6){
        SubjectDetailViewController *sd = [[SubjectDetailViewController alloc] init];
        JRSubject *subject = [[JRSubject alloc] init];
        subject.key = [param getIntValueForKey:@"id" defaultValue:0];
        sd.subject = subject;
        sd.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sd animated:YES];
    }else if (type == 3){
        if ([param.allKeys containsObject:@"id"]) {
            JRCase *jrCase = [[JRCase alloc] init];
            jrCase.projectId = [param getStringValueForKey:@"id" defaultValue:@""];
            JRPhotoScrollViewController *dv = [[JRPhotoScrollViewController alloc] initWithJRCase:jrCase andStartWithPhotoAtIndex:0];
            dv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dv animated:YES];
        }else{
            CaseViewController *cv = [[CaseViewController alloc] init];
            NSMutableDictionary *filterData = [NSMutableDictionary dictionaryWithDictionary:param];
            [filterData removeObjectForKey:@"type"];
            cv.filterData = filterData;
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
        }
    }
    //    NSArray *types = [[links firstObject] componentsSeparatedByString:@"="];
    //    if ([types count] == 0) {
    //        NSInteger type = [[types lastObject] integerValue];
    //        if (type == 1) {
    //
    //        }
    //    }
}

@end
