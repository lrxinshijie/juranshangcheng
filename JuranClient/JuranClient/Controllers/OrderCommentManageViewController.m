//
//  OrderCommentManageViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/2/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderCommentManageViewController.h"
#import "JROrderManage.h"
#import "CommentStarView.h"
#import "OrderCommentCell.h"
#import "JRDesignCreditDto.h"

@interface OrderCommentManageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) JROrderManage *manage;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *praiseView;
@property (nonatomic, strong) IBOutlet CommentStarView *capacityPointView;
@property (nonatomic, strong) IBOutlet CommentStarView *servicePointView;
@property (nonatomic, strong) IBOutlet UILabel *capacityLabel;
@property (nonatomic, strong) IBOutlet UILabel *serviceLabel;
@property (nonatomic, strong) IBOutlet UILabel *capacityDescLabel;
@property (nonatomic, strong) IBOutlet UILabel *serviceDescLabel;
@property (nonatomic, strong) IBOutlet UILabel *capacityNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *serviceNumLabel;

@end

@implementation OrderCommentManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"评价管理";
    
    [self setupUI];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    [_tableView headerBeginRefreshing];
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(237, 237, 237);
    [self.view addSubview:_tableView];
    
    [self.capacityPointView setEnable:NO];
    [self.servicePointView setEnable:NO];
    
}


- (void)loadData{
    NSDictionary *param = @{@"pageNo": @(_currentPage),
                            @"onePageCount": kOnePageCount};
    [[ALEngine shareEngine]  pathURL:JR_CREDIT_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            if (_currentPage == 1) {
                self.manage = [[JROrderManage alloc] initWithDictionary:data];
            }else{
                [self.manage addDesignCreditList:data[@"designCreditList"]];
            }
        }
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return _manage.designCreditList.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 75;
    }else if (indexPath.section == 1 && indexPath.row != 0){
        JRDesignCreditDto *dto = _manage.designCreditList[indexPath.row - 1];
        return 126 + [dto.content heightWithFont:[UIFont systemFontOfSize:12] constrainedToWidth:290];
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.row == 0) {
        static NSString *cellIdentifier = @"OrderCommentCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.clipsToBounds = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = @"";
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        UIView *view = [cell.contentView viewWithTag:5555];
        if (view) {
            [view removeFromSuperview];
        }
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.textLabel.text = @"综合评价";
        }else if (indexPath.section == 1){
            cell.textLabel.text = @"收到的评价";
        }else if (indexPath.section == 0&& indexPath.row == 1){
            _capacityPointView.selectedIndex = _manage.capacityPointInfo.averageCredit;
            _capacityLabel.text = [NSString stringWithFormat:@"%d分", _manage.capacityPointInfo.averageCredit];
            _capacityDescLabel.text = _manage.capacityPointInfo.descForDto;
            _capacityNumLabel.text = [NSString stringWithFormat:@"%d人", _manage.capacityPointInfo.sellerTotal];
            
            _servicePointView.selectedIndex = _manage.servicePointInfo.averageCredit;
            _serviceLabel.text = [NSString stringWithFormat:@"%d分", _manage.servicePointInfo.averageCredit];
            _serviceDescLabel.text = _manage.servicePointInfo.descForDto;
            _serviceNumLabel.text = [NSString stringWithFormat:@"%d人", _manage.servicePointInfo.sellerTotal];
            [cell.contentView addSubview:_praiseView];
        }
        
        return cell;
    }else{ //OrderCommentCell
        static NSString *CellIdentifier = @"OrderCommentCell";
        OrderCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (OrderCommentCell *)[nibs firstObject];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        JRDesignCreditDto *dto = [_manage.designCreditList objectAtIndex:indexPath.row - 1];
        [cell fillCellWithDesigneCreditDto:dto];
        
        return cell;
    }
}

@end
