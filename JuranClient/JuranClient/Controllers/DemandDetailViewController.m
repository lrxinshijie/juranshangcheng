//
//  DemandDetailViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DemandDetailViewController.h"
#import "BidDesignerCell.h"
#import "JRDemand.h"
#import "JRDesigner.h"
#import "PublishDesignViewController.h"
#import "ZoomInImageView.h"
#import "JRBidInfo.h"
#import "DesignerDetailViewController.h"
#import "PrivateLetterViewController.h"
#import "MeasureViewController.h"
#import "UIAlertView+Blocks.h"
#import "JRAreaInfo.h"
#import "TTTAttributedLabel.h"
#import "InputView.h"

#define kStatusBGImageViewTag 2933

@interface DemandDetailViewController ()<UITableViewDelegate, UITableViewDataSource, BidDesignerCellDelegate>
{
    NSArray *demandInfoKeys;
    NSArray *demandInfoValues;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong)  UITableView *designerTableView;
@property (nonatomic, strong)  UITableView *demandInfoTableView;

@property (nonatomic, strong) IBOutlet UIView *designerTableHeaderView;
@property (nonatomic, strong) IBOutlet UIView *designerHeaderView;

@property (nonatomic, strong) IBOutlet UIView *demandInfoTableHeaderView;
@property (nonatomic, strong) IBOutlet UIView *demandInfoHeaderView;
@property (nonatomic, strong) IBOutlet UILabel *demandInfoTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *pullTipLabel;

@property (nonatomic, strong) IBOutlet UIView *demandAddressView;
@property (nonatomic, strong) IBOutlet UILabel *demandAddressLabel;
@property (nonatomic, strong) IBOutlet ZoomInImageView *roomTypeImageView;

@property (nonatomic, strong) TTTAttributedLabel *demandDescribeLabel;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) IBOutlet UIButton *modifyDemandInfoButton;
@property (nonatomic, strong) IBOutlet UIView *emptyView;

@property (nonatomic, strong) InputView *inputView;

@end

@implementation DemandDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReloadDataNotification:) name:kNotificationNameMyDemandReloadData object:nil];
#ifndef kJuranDesigner
    self.navigationItem.title = @"我的需求";
#else
    self.navigationItem.title = @"招标公告";
#endif
    demandInfoKeys = @[@"姓名", @"联系电话", @"编号", @"户型", @"装修预算", @"当前状态", @"房屋面积", @"风格", @"发布时间", @"终止时间", @"项目地址"];
    [self setupUI];
    
    [self loadData];
}

- (void)loadData{
    NSDictionary *param = @{@"designReqId": _demand.designReqId
#ifndef kJuranDesigner
                            ,@"searchFlag": @"forMySpace"
#endif
                            };
    [self showHUD];
#ifdef kJuranDesigner
    NSString *url = JR_GET_DESIGNREQ_DETAIL;
#else
    NSString *url = JR_GET_MYDEMANDDETAIL;
#endif
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_demand buildUpDetailWithValue:data];
        }
        [self reloadData];
    }];
    
}

- (void)reloadData{
//    _demandInfoTitleLabel.text = _demand.title;
    [self reSetData];
#ifndef kJuranDesigner
    NSInteger index = [_demand statusIndex];
    if (index < 3) {
        self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
        _modifyDemandInfoButton.hidden = NO;
        
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        _modifyDemandInfoButton.hidden = YES;
    }
#else
    if ([_demand.status isEqualToString:@"03_pass"]) {
        self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
        _rightButton.enabled = !_demand.isBidded;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
#endif
    [self setupDesignerTableHeaderView];
    _demandInfoTitleLabel.text = [NSString stringWithFormat:@"%@%@", _demand.neighbourhoods, [_demand roomNumString]];
    
    _emptyView.hidden = !(_demand.bidInfoList.count == 0 && !_demand.confirmDesignerDetail);
    _emptyView.center = CGPointMake(CGRectGetMinX(_designerTableView.frame) + CGRectGetWidth(_designerTableView.frame)/2, CGRectGetMinY(_designerTableView.frame) + CGRectGetHeight(_designerTableView.frame)/2+20);
    [_designerTableView reloadData];
    [_demandInfoTableView reloadData];
    
    
}

- (void)setupDesignerTableHeaderView{
    NSInteger index = [_demand statusIndex];
    NSInteger tag = kStatusBGImageViewTag;
    if (index == 2) {
        tag += 1;
    }else if (index > 2){
        tag += 2;
    }
    UIImageView *imageView = (UIImageView*)[_designerTableHeaderView viewWithTag:tag];
    imageView.image = [UIImage imageNamed:@"request_doing.png"];
    
#ifndef kJuranDesigner
    [_demandDescribeLabel setText:[_demand descriptionForDetail] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = [[mutableAttributedString string] rangeOfString:@"010-84094000" options:NSCaseInsensitiveSearch];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:range];
        return mutableAttributedString;
    }];
    
    CGRect frame = _demandDescribeLabel.frame;
    frame.size.height = [_demandDescribeLabel.text heightWithFont:_demandDescribeLabel.font constrainedToWidth:CGRectGetWidth(_demandDescribeLabel.frame)];
    _demandDescribeLabel.frame = frame;
    
    frame = _designerTableHeaderView.frame;
    frame.size.height = CGRectGetMaxY(_demandDescribeLabel.frame) + 10;
    _designerTableHeaderView.frame = frame;
    
    _designerTableView.tableHeaderView = _designerTableHeaderView;
#endif
}

- (void)reSetData{
    demandInfoValues = @[_demand.contactsName, _demand.contactsMobile, _demand.designReqId, [_demand roomNumString], [NSString stringWithFormat:@"%@万元", _demand.budget], [_demand statusString], [NSString stringWithFormat:@"%.2f㎡", [_demand.houseArea doubleValue]], [_demand renovationStyleString], _demand.postDate, _demand.deadline, @""];
}

- (void)setupUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:kContentFrameWithoutNavigationBar];
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    self.designerTableView = [self.view tableViewWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBar - 55) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _designerTableView.backgroundColor = RGBColor(241, 241, 241);
    _designerTableView.tableFooterView = [[UIView alloc] init];
    _designerTableView.tableHeaderView = _designerTableHeaderView;
    _designerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_designerTableView];
    
    self.demandDescribeLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 48, 300, 142)];
    _demandDescribeLabel.textColor = [UIColor blackColor];
    _demandDescribeLabel.font = [UIFont systemFontOfSize:14];
    _demandDescribeLabel.backgroundColor = [UIColor clearColor];
    _demandDescribeLabel.numberOfLines = 0;
    [_designerTableHeaderView addSubview:_demandDescribeLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_designerTableHeaderView addGestureRecognizer:tap];
    
    CGRect frame = _demandInfoTableHeaderView.frame;
    frame.origin = CGPointMake(0, CGRectGetMaxY(_designerTableView.frame));
    _demandInfoTableHeaderView.frame = frame;
    [_scrollView addSubview:_demandInfoTableHeaderView];
    _demandInfoTableHeaderView.backgroundColor = RGBColor(241, 241, 241);
    
    frame = kContentFrameWithoutNavigationBar;
    frame.origin.y = kWindowHeightWithoutNavigationBar;
    self.demandInfoTableView = [self.view tableViewWithFrame:frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _demandInfoTableView.backgroundColor = RGBColor(241, 241, 241);
    _demandInfoTableView.tableFooterView = [[UIView alloc] init];
    [_scrollView addSubview:_demandInfoTableView];
    
    _scrollView.contentSize = CGSizeMake(kWindowWidth, 2*kWindowHeightWithoutNavigationBar);
    
#ifdef kJuranDesigner
    frame = _demandInfoTableView.frame;
    _demandInfoTableView.frame = _designerTableView.frame;
    _designerTableView.frame = frame;
    
    frame = _designerTableHeaderView.frame;
    frame.size.height = 50;
    _designerTableHeaderView.frame = frame;
    
    _designerTableView.tableHeaderView = nil;
    _demandInfoTableView.tableHeaderView = _designerTableHeaderView;
    
    _modifyDemandInfoButton.hidden = YES;
    _pullTipLabel.text = @"上拉查看参与投标的设计师";
    
    self.rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onBidReq) title:@"我要应标" backgroundImage:nil];
    [_rightButton setTitle:@"已应标" forState:UIControlStateDisabled];
    [_rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
#else
    self.rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onDeadRequest) title:@"终止需求" backgroundImage:nil];
    [_rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
#endif
    
    _emptyView.hidden = YES;
    _emptyView.center = CGPointMake(CGRectGetMinX(_designerTableView.frame) + CGRectGetWidth(_designerTableView.frame)/2, CGRectGetMinY(_designerTableView.frame) + CGRectGetHeight(_designerTableView.frame)/2);
    [_scrollView addSubview:_emptyView];
    
    self.inputView = [[InputView alloc] init];
    [self.view addSubview:_inputView];
    
}

- (void)receiveReloadDataNotification:(NSNotification*)notification{
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target Action

- (void)handleTap:(UITapGestureRecognizer*)gesture{
    if ([_demand statusIndex] == 0) {
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",@"01084094000"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
}

- (IBAction)onModifyDemandInfo:(id)sender{
    PublishDesignViewController *vc = [[PublishDesignViewController alloc] init];
    vc.demand = _demand;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onBidReq{
    if (![self checkLogin:^{
        [self loadData];
    }]) {
        return;
    }
    if (_inputView.hidden) {
        [_inputView showWithTitle:@"我来应标" placeHolder:@"请填写您的应标宣言" content:@"" block:^(id result) {
            NSDictionary *param = @{@"designReqId": _demand.designReqId,
                                    @"biddingDeclatation":result};
            [self showHUD];
            [[ALEngine shareEngine] pathURL:JR_BID_DESIGNREQ parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
                [self hideHUD];
                if (!error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameMyDemandReloadData object:nil];
                }
            }];
        }];

    }else{
        [_inputView unShow];
    }
}

- (void)onDeadRequest{
    
    [UIAlertView showWithTitle:@"" message:@"您确定要终止本次设计需求吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSDictionary *param = @{@"designReqId": _demand.designReqId};
            [self showHUD];
            [[ALEngine shareEngine] pathURL:JR_REQ_STOP parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
                [self hideHUD];
                if (!error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameMyDemandReloadData object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }];
    
}

#pragma mark - 拒绝、私信、选TA量房

- (void)privateLetter:(BidDesignerCell *)cell andBidInfo:(JRBidInfo *)bidInfo{
//    PrivateLetterViewController *pv = [[PrivateLetterViewController alloc] init];
//    pv.designer = bidInfo.userBase;
//    [self.navigationController pushViewController:pv animated:YES];
    [[JRUser currentUser] postPrivateLetterWithUserId:bidInfo.userBase.userId VC:self];
}

- (void)takeMeasure:(BidDesignerCell *)cell andBidInfo:(JRBidInfo *)bidInfo{
//    if (!_jrCase.isAuth) {
//        [self showTip:@"未认证的设计师无法预约量房"];
//        return;
//    }
    if(bidInfo.statusIndex == 4 || bidInfo.statusIndex == 3){
        [self showTip:@"该需求已结束！"];
        return;
    }
    if (bidInfo.isMeasured) {
        [self showTip:@"你已选该设计师量房请耐心等待！"];
        return;
    }
    MeasureViewController *mv = [[MeasureViewController alloc] init];
    mv.designer = bidInfo.userBase;
    mv.bidId = bidInfo.bidId;
    mv.demand = _demand;
    [self.navigationController pushViewController:mv animated:YES];
}

- (void)rejectForBid:(BidDesignerCell *)cell andBidInfo:(JRBidInfo *)bidInfo{
    if(bidInfo.statusIndex == 4 || bidInfo.statusIndex == 3){
        [self showTip:@"该需求已结束！"];
        return;
    }
    if (bidInfo.isMeasured) {
        [self showTip:@"你已选该设计师量房请耐心等待！"];
        return;
    }
    NSDictionary *param = @{@"designReqId": _demand.designReqId,
                            @"designId":@(bidInfo.userBase.userId)};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_REJECT_DESIGNREQ parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_demand.bidInfoList removeObject:bidInfo];
            [_designerTableView reloadData];
        }
    }];
}


#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _designerTableView) {
        if (_demand.confirmDesignerDetail) {
            return _demand.bidInfoList.count + 1;
        }
        return _demand.bidInfoList.count;
    }else if(tableView == _demandInfoTableView){
        return demandInfoKeys.count;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _designerTableView) {
#ifndef kJuranDesigner
        return _designerHeaderView;
#else
        return nil;
#endif
    }else if(tableView == _demandInfoTableView){
        return _demandInfoHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _designerTableView) {
#ifndef kJuranDesigner
        return 45;
#else
        return 0;
#endif
    }else if(tableView == _demandInfoTableView){
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _designerTableView) {
        CGFloat height = 0;
#ifndef kJuranDesigner
        if (_demand.confirmDesignerDetail) {
            if (indexPath.row == 0) {
                height = [[NSString stringWithFormat:@"应标宣言:%@", _demand.confirmDesignerDetail.biddingDeclatation] heightWithFont:[UIFont systemFontOfSize:kSystemFontSize] constrainedToWidth:300];
            }else{
                JRBidInfo *b = _demand.bidInfoList[indexPath.row - 1];
                height = [[NSString stringWithFormat:@"应标宣言:%@", b.biddingDeclatation] heightWithFont:[UIFont systemFontOfSize:kSystemFontSize] constrainedToWidth:300];
            }
            return 145 + height;
        }else{
            JRBidInfo *b = _demand.bidInfoList[indexPath.row];
            height = [[NSString stringWithFormat:@"应标宣言:%@", b.biddingDeclatation] heightWithFont:[UIFont systemFontOfSize:kSystemFontSize] constrainedToWidth:300];
            return 145 + height;
        }
#else
        if (_demand.confirmDesignerDetail) {
            if (indexPath.row == 0) {
                height = [[NSString stringWithFormat:@"应标宣言:%@", _demand.confirmDesignerDetail.biddingDeclatation] heightWithFont:[UIFont systemFontOfSize:kSystemFontSize] constrainedToWidth:300];
            }else{
                JRBidInfo *b = _demand.bidInfoList[indexPath.row - 1];
                height = [[NSString stringWithFormat:@"应标宣言:%@", b.biddingDeclatation] heightWithFont:[UIFont systemFontOfSize:kSystemFontSize] constrainedToWidth:300];
            }
            return 112 + ((indexPath.row == _demand.bidInfoList.count)?5:0) + height;
        }else{
            JRBidInfo *b = _demand.bidInfoList[indexPath.row];
            height = [[NSString stringWithFormat:@"应标宣言:%@", b.biddingDeclatation]  heightWithFont:[UIFont systemFontOfSize:kSystemFontSize] constrainedToWidth:300];
            return 112 + ((indexPath.row == _demand.bidInfoList.count - 1)?5:0) + height;
        }
#endif
        
    }else if(tableView == _demandInfoTableView){
        return  (indexPath.row == demandInfoKeys.count - 1)?95:44;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _designerTableView) {
        static NSString *CellIdentifier = @"BidDesignerCell";
        BidDesignerCell *cell = (BidDesignerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (BidDesignerCell *)[nibs firstObject];
        }
        
        if (_demand.confirmDesignerDetail) {
            cell.delegate = self;
            if (indexPath.row == 0) {
                [cell fillCellWithConfirmBidInfo:_demand.confirmDesignerDetail];
            }else{
                JRBidInfo *bidInfo = _demand.bidInfoList[indexPath.row - 1];
                [cell fillCellWithJRBidInfo:bidInfo];
            }
        }else{
            cell.delegate = self;
            JRBidInfo *bidInfo = _demand.bidInfoList[indexPath.row];
            [cell fillCellWithJRBidInfo:bidInfo];
        }
        
        return cell;
    }else if(tableView == _demandInfoTableView){
        if (indexPath.row == demandInfoKeys.count - 1) {
            static NSString *CellIdentifier = @"DemandAddressCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
            }

            if (_demandAddressView.superview) {
                [_demandAddressView removeFromSuperview];
            }
            _demandAddressLabel.text = [NSString stringWithFormat:@"%@%@", _demand.areaInfo.title, _demand.neighbourhoods];
            [_roomTypeImageView setImageWithURLString:_demand.roomTypeImgUrl];
            [cell.contentView addSubview:_demandAddressView];
            return cell;
        }else{
            static NSString *CellIdentifier = @"DemandInfoCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
            }
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 5){
                cell.detailTextLabel.textColor = RGBColor(49, 113, 179);
                cell.textLabel.text = demandInfoKeys[indexPath.row];
                cell.detailTextLabel.text = demandInfoValues[indexPath.row];
            }else{
                cell.textLabel.text = demandInfoKeys[indexPath.row];
                cell.detailTextLabel.text = demandInfoValues[indexPath.row];
            }
            
            return cell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _designerTableView) {
        DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
        if (_demand.confirmDesignerDetail) {
            if (indexPath.row == 0) {
                detailVC.designer = _demand.confirmDesignerDetail.userBase;
            }else{
                JRBidInfo *bidInfo = _demand.bidInfoList[indexPath.row - 1];
                detailVC.designer = bidInfo.userBase;
            }
        }else{
            JRBidInfo *bidInfo = _demand.bidInfoList[indexPath.row];
            detailVC.designer = bidInfo.userBase;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if (tableView == _demandInfoTableView){
    }
}

@end
