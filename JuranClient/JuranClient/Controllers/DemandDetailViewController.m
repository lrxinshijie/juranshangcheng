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

@property (nonatomic, strong) IBOutlet UIView *demandAddressView;
@property (nonatomic, strong) IBOutlet UILabel *demandAddressLabel;
@property (nonatomic, strong) IBOutlet ZoomInImageView *roomTypeImageView;

@property (nonatomic, strong) IBOutlet UILabel *demandDescribeLabel;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, strong) IBOutlet UIButton *modifyDemandInfoButton;

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
    
    self.navigationItem.title = @"我的需求";
    demandInfoKeys = @[@"姓名", @"联系电话", @"编号", @"户型", @"装修预算", @"当前状态", @"房屋面积", @"风格", @"发布时间", @"终止时间", @"项目地址"];
    [self setupUI];
    
    [self loadData];
}

- (void)loadData{
    NSDictionary *param = @{@"designReqId": _demand.designReqId,
                            @"searchFlag": @"forMySpace"};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_MYDEMANDDETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_demand buildUpDetailWithValue:data];
            [self reloadData];
        }
    }];
    
}

- (void)reloadData{
    NSInteger index = [_demand statusIndex];
    if (index < 3) {
        self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
        _modifyDemandInfoButton.hidden = NO;
        
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        _modifyDemandInfoButton.hidden = YES;
    }
    
    _demandInfoTitleLabel.text = [NSString stringWithFormat:@"%@%@", _demand.neighbourhoods, _demand.roomType];
//    _demandInfoTitleLabel.text = _demand.title;
    [self reSetData];
    [self setupDesignerTableHeaderView];
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
    
    _demandDescribeLabel.text = [_demand descriptionForDetail];
    
    CGRect frame = _demandDescribeLabel.frame;
    frame.size.height = [_demandDescribeLabel.text heightWithFont:_demandDescribeLabel.font constrainedToWidth:CGRectGetWidth(_demandDescribeLabel.frame)];
    _demandDescribeLabel.frame = frame;
    
    frame = _designerTableHeaderView.frame;
    frame.size.height = CGRectGetMaxY(_demandDescribeLabel.frame) + 10;
    _designerTableHeaderView.frame = frame;
    
    _designerTableView.tableHeaderView = _designerTableHeaderView;
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
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onDeadRequest) title:@"终止需求" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
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
    PrivateLetterViewController *pv = [[PrivateLetterViewController alloc] init];
    pv.designer = bidInfo.userBase;
    [self.navigationController pushViewController:pv animated:YES];
}

- (void)takeMeasure:(BidDesignerCell *)cell andBidInfo:(JRBidInfo *)bidInfo{
//    if (!_jrCase.isAuth) {
//        [self showTip:@"未认证的设计师无法预约量房"];
//        return;
//    }
    MeasureViewController *mv = [[MeasureViewController alloc] init];
    mv.designer = bidInfo.userBase;
    [self.navigationController pushViewController:mv animated:YES];
}

- (void)rejectForBid:(BidDesignerCell *)cell andBidInfo:(JRBidInfo *)bidInfo{
    NSDictionary *param = @{@"designReqId": _demand.designReqId,
                            @"bidId":bidInfo.bidId};
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
        return _demand.bidInfoList.count;
    }else if(tableView == _demandInfoTableView){
        return demandInfoKeys.count;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _designerTableView) {
        return _designerHeaderView;
    }else if(tableView == _demandInfoTableView){
        return _demandInfoHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _designerTableView) {
        return 45;
    }else if(tableView == _demandInfoTableView){
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _designerTableView) {
        return 170 + ((indexPath.row == _demand.bidInfoList.count - 1)?5:0);
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
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        JRBidInfo *bidInfo = _demand.bidInfoList[indexPath.row];
        [cell fillCellWithJRBidInfo:bidInfo];
        //    JRDemand *d = [_datas objectAtIndex:indexPath.row];
        //    [cell fillCellWithDemand:d];
        
        return cell;
    }else if(tableView == _demandInfoTableView){
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
        if (indexPath.row == demandInfoKeys.count - 1) {
            if (_demandAddressView.superview) {
                [_demandAddressView removeFromSuperview];
            }
            _demandAddressLabel.text = [NSString stringWithFormat:@"%@%@", _demand.areaInfo.title, _demand.neighbourhoods];
            [_roomTypeImageView setImageWithURLString:_demand.roomTypeImgUrl];
            [cell.contentView addSubview:_demandAddressView];
        }else if (indexPath.row == 5){
            cell.detailTextLabel.textColor = RGBColor(49, 113, 179);
            cell.textLabel.text = demandInfoKeys[indexPath.row];
            cell.detailTextLabel.text = demandInfoValues[indexPath.row];
        }else{
            cell.textLabel.text = demandInfoKeys[indexPath.row];
            cell.detailTextLabel.text = demandInfoValues[indexPath.row];
        }
        
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _designerTableView) {
        JRBidInfo *bidInfo = _demand.bidInfoList[indexPath.row];
        DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
        detailVC.designer = bidInfo.userBase;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (tableView == _demandInfoTableView){
    }
}

@end
