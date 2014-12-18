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
@property (nonatomic, strong) IBOutlet UIImageView *roomTypeImageView;

@property (nonatomic, strong) IBOutlet UILabel *demandDescribeLabel;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@end

@implementation DemandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
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
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    _demandInfoTitleLabel.text = _demand.title;
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
    demandInfoValues = @[_demand.contactsName, _demand.contactsMobile, _demand.designReqId, _demand.roomType, [NSString stringWithFormat:@"￥%d", (NSInteger)_demand.renovationBudget/100], [_demand statusString], [NSString stringWithFormat:@"%d平方米", _demand.houseArea], [_demand renovationStyleString], _demand.postDate, _demand.deadline, @""];
}

- (void)setupUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:kContentFrameWithoutNavigationBar];
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    self.designerTableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _designerTableView.backgroundColor = RGBColor(241, 241, 241);
    _designerTableView.tableFooterView = [[UIView alloc] init];
    _designerTableView.tableHeaderView = _designerTableHeaderView;
    _designerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_designerTableView];
    
    CGRect frame = kContentFrameWithoutNavigationBar;
    frame.origin.y = CGRectGetMaxY(_designerTableView.frame);
    self.demandInfoTableView = [self.view tableViewWithFrame:frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _demandInfoTableView.backgroundColor = RGBColor(241, 241, 241);
    _demandInfoTableView.tableFooterView = [[UIView alloc] init];
    _demandInfoTableView.tableHeaderView = _demandInfoTableHeaderView;
    [_scrollView addSubview:_demandInfoTableView];
    
    _scrollView.contentSize = CGSizeMake(kWindowWidth, 2*kWindowHeightWithoutNavigationBar);
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onDeadRequest) title:@"终止需求" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target Action

- (IBAction)onModifyDemandInfo:(id)sender{
    
}

- (void)onDeadRequest{
    
    NSDictionary *param = @{@"designReqId": _demand.designReqId};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_REQ_STOP parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 拒绝、私信、选TA量房

- (void)privateLetter:(BidDesignerCell *)cell andDesigner:(JRDesigner *)designer{
    
}

- (void)takeMeasure:(BidDesignerCell *)cell andDesigner:(JRDesigner *)designer{
    
}

- (void)rejectForBid:(BidDesignerCell *)cell andDesigner:(JRDesigner *)designer{
    NSDictionary *param = @{@"designReqId": _demand.designReqId,
                            @"bidId":designer.bidId};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_REJECT_DESIGNREQ parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_demand.bidInfoList removeObject:designer];
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        JRDesigner *designer = _demand.bidInfoList[indexPath.row];
        [cell fillCellWithDesigner:designer];
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
            _demandAddressLabel.text = _demand.houseAddress;
            [_roomTypeImageView setImageWithURLString:_demand.imageUrl];
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

@end
