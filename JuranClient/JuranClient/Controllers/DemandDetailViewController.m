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

@interface DemandDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *demandInfoKeys;
    NSArray *demandInfoValues;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong)  UITableView *designerTableView;
@property (nonatomic, strong)  UITableView *demandInfoTableView;
@property (nonatomic, strong) IBOutlet UIView *demandInfoTableHeaderView;
@property (nonatomic, strong) IBOutlet UIView *designerTableHeaderView;
@property (nonatomic, strong) IBOutlet UIView *demandInfoHeaderView;
@property (nonatomic, strong) IBOutlet UIView *designerHeaderView;

@property (nonatomic, strong) IBOutlet UIView *demandAddressView;

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
    [self reSetData];
    
    [_designerTableView reloadData];
    [_demandInfoTableView reloadData];
}

- (void)reSetData{
    demandInfoValues = @[_demand.contactsName, _demand.contactsMobile, _demand.designReqId, _demand.roomType, [NSString stringWithFormat:@"￥%d", (NSInteger)_demand.renovationBudget/100], [_demand statusString], [NSString stringWithFormat:@"%d平方米", _demand.houseArea], [_demand renovationStyleString], @"2014-08-18 10:23:12", @"2014-08-18 10:23:12", @""];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _designerTableView) {
        return 7;
    }else{
        return demandInfoKeys.count;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _designerTableView) {
        return _designerHeaderView;
    }else{
        return _demandInfoHeaderView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _designerTableView) {
        return 45;
    }else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _designerTableView) {
        return 170 + ((indexPath.row == 7-1)?5:0);
    }else{
        return  (indexPath.row == demandInfoKeys.count - 1)?95:44;
    }
    
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
        
        //    JRDemand *d = [_datas objectAtIndex:indexPath.row];
        //    [cell fillCellWithDemand:d];
        
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
        if (indexPath.row == demandInfoKeys.count - 1) {
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
//    return nil;
}

@end
