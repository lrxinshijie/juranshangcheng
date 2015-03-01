//
//  ContractPreviewViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/3/1.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ContractPreviewViewController.h"
#import "TTTAttributedLabel.h"
#import "JROrder.h"

@interface ContractPreviewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSMutableDictionary *hiddenSectionDic;

@property (nonatomic, strong) IBOutlet UIView *waitFirstPayView;
@property (nonatomic, strong) IBOutlet UILabel *firstPayAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel *measureAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel *waitFirstPayAmountLabel;

@property (nonatomic, strong) IBOutlet UIView *designContentView;
@property (nonatomic, strong) IBOutlet UILabel *designPageLabel;
@property (nonatomic, strong) IBOutlet UILabel *diyPageLabel;
@property (nonatomic, strong) IBOutlet UILabel *addPagePriceLabel;

@property (nonatomic, strong) IBOutlet UIView *tableFooterView;

@property (nonatomic, strong) IBOutlet UIView *commentView;
@property (nonatomic, strong) IBOutlet UILabel *commentLabel;

@property (nonatomic, strong) IBOutlet UIView *addressView;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;

@end

@implementation ContractPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"创建设计合同";
    
    self.keys = @[@[[NSString stringWithFormat:@"量房合同编号：%@", _order.type?_order.designTid:_order.measureTid] , @"合同金额（元）", @"待支付首款", @"尾款", @"设计工作内容", @""]
                  , @[@"真实姓名", @"用户名", @"手机号", @"微信号", @"会员卡号", @"电子邮箱", @"户型", @"面积", @"装修地址", @"小区名称"]
                  , @[@"真实姓名", @"用户名", @"手机号", @"微信号", @"电子邮箱"]];
    
    self.hiddenSectionDic = [NSMutableDictionary dictionary];
    [self reSetValue];
    [self setupUI];
}

- (void)reSetValue{
    self.values = @[@[@"", [NSString stringWithFormat:@"￥ %@", _order.amount], _order.firstPayAmount, [NSString stringWithFormat:@"￥ %@", _order.finalPayAmount], @"", @""]
                    , @[_order.customerRealName, _order.customerName, _order.customerMobile, _order.customerWechat, _order.customerCardNo, _order.customerEmail, _order.roomTypeString, _order.houseArea, _order.measureAddressString, _order.address]
                    , @[_order.decoratorRealName, _order.decoratorName, _order.decoratorMobile, _order.decoratorWechat, _order.decoratorEmail]];
}

- (void)reloadData{
    [self reSetValue];
    [_tableView reloadData];
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = _tableFooterView;
    [self.view addSubview:_tableView];
    
    UIView *view = [_tableFooterView viewWithTag:1100];
    view.layer.borderWidth = .5f;
    view.layer.borderColor = [UIColor darkGrayColor].CGColor;
    view.layer.cornerRadius = 2.f;
    
    view = [_tableFooterView viewWithTag:1101];
    view.layer.borderWidth = .5f;
    view.layer.borderColor = RGBColor(0, 54, 114).CGColor;
    view.layer.cornerRadius = 2.f;
    
    TTTAttributedLabel *label = (TTTAttributedLabel*)[_designContentView viewWithTag:1300];
    [label setText:@"说明：设计师还需提供详细施工图纸，具体详见《住宅室内装饰设计合同》中的合同条款。" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = [[mutableAttributedString string] rangeOfString:@"《住宅室内装饰设计合同》" options:NSCaseInsensitiveSearch];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:range];
        return mutableAttributedString;
    }];
    
//    label = (TTTAttributedLabel*)[_tableFooterView viewWithTag:1300];
//    [label setText:@"已阅读并接受《住宅室内装饰设计合同》中得合同条款" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        NSRange range = [[mutableAttributedString string] rangeOfString:@"《住宅室内装饰设计合同》" options:NSCaseInsensitiveSearch];
//        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:range];
//        return mutableAttributedString;
//    }];
    
}

#pragma mark - Target Action

- (void)onHiddenSection:(id)sender{
    UIButton *btn = (UIButton*)sender;
    if (_hiddenSectionDic[[NSString stringWithFormat:@"%d", btn.tag]]) {
        [_hiddenSectionDic removeObjectForKey:[NSString stringWithFormat:@"%d", btn.tag]];
    }else{
        [_hiddenSectionDic addEntriesFromDictionary:@{[NSString stringWithFormat:@"%d", btn.tag]:@""}];
    }
    [_tableView reloadData];
}

- (IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSubmit:(id)sender{
    [self showHUD];
    NSDictionary *param = @{@"tid": _order.type?_order.designTid:_order.measureTid
                            , @"tradeInfo" : @{@"decoratorId": [NSString stringWithFormat:@"%d", _order.decoratorId]
                                      , @"decoratorName": _order.decoratorName
                                      , @"decoratorRealName": _order.decoratorRealName
                                      , @"decoratorMobile": _order.decoratorMobile
                                      , @"decoratorQQ": _order.decoratorQQ
                                      , @"decoratorWechat": _order.decoratorWechat
                                      , @"decoratorEmail": _order.decoratorEmail
                                      , @"customerId": [NSString stringWithFormat:@"%d", _order.customerId]
                                      , @"measureTid": _order.measureTid
                                      , @"measurePayAmount": _order.measurePayAmount
                                      , @"finalPayAmount": _order.finalPayAmount
                                      , @"designReqId": _order.designReqId
                                      //                            , @"amount": _order.amount
                                      , @"amountStr": _order.amount
                                      , @"firstPayAmountStr": _order.firstPayAmount
                                      , @"firstPayAmount": _order.firstPayAmount
                                      , @"diyPageNum": [NSString stringWithFormat:@"%d", _order.diyPageNum]
                                      , @"designPageNum": [NSString stringWithFormat:@"%d", _order.designPageNum]
                                      , @"addPagePriceStr": [NSString stringWithFormat:@"%d", _order.addPagePrice]
                                      , @"addPagePrice": [NSString stringWithFormat:@"%d", _order.addPagePrice]
                                      //                            , @"serviceDate": _order.serviceDate
                                      , @"comments": _order.comments
                                      , @"customerName": _order.customerName
                                      , @"customerRealName": _order.customerRealName
                                      , @"customerMobile": _order.customerMobile
                                      , @"customerCardNo": _order.customerCardNo
                                      , @"customerQQ": _order.customerQQ
                                      , @"customerWechat": _order.customerWechat
                                      , @"customerEmail": _order.customerEmail
                                      , @"roomNum": _order.roomNum
                                      , @"livingroomNum": _order.livingroomNum
                                      , @"bathroomNum": _order.bathroomNum
                                      , @"houseArea": _order.houseArea
                                      , @"province": _order.province
                                      , @"city": _order.city
                                      , @"district": _order.district
                                      , @"address": _order.address}
                            };
    [[ALEngine shareEngine]  pathURL:JR_ORDER_APPLE_DESIGNTRADE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = _keys[section];
    if (_hiddenSectionDic[[NSString stringWithFormat:@"%d", section]]) {
        return 0;
    }
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 2) {
        return 105;
    }else if (indexPath.section == 0 && indexPath.row == 4){
        return 165;
    }else if (indexPath.section == 0 && indexPath.row == 5){
        CGFloat height = [_order.comments heightWithFont:[UIFont systemFontOfSize:12] constrainedToWidth:290];
        return 43 + (height < 10?12:height);
    }else if (indexPath.section == 1 && indexPath.row == 9){
        CGFloat height = [_order.address heightWithFont:[UIFont systemFontOfSize:12] constrainedToWidth:290];
        return 40 + (height < 10?12:height);
    }
    return 36;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 35)];
    view.backgroundColor = RGBColor(226, 226, 226);
    
    UIButton *btn = [view buttonWithFrame:view.bounds target:self action:@selector(onHiddenSection:) image:nil];
    btn.tag = section;
    [view addSubview:btn];
    
    UILabel *label = [view labelWithFrame:CGRectMake(10, 5, 100, 15) text:@"" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    [view addSubview:label];
    
    if (section == 0) {
        label.text = @"合同信息";
    }else if (section == 1){
        label.text = @"消费者（甲方）";
    }else if (section == 2){
        label.text = @"设计师（乙方）";
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_hiddenSectionDic[[NSString stringWithFormat:@"%d", section]]?@"arrow_up.png":@"arrow_down.png"]];
    imageView.center = CGPointMake(kWindowWidth - 10 - CGRectGetWidth(imageView.frame), CGRectGetHeight(view.frame)/2.f);
    [view addSubview:imageView];
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ContractPreviewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
    }
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    UIView *view = [cell.contentView viewWithTag:5555];
    if (view) {
        [view removeFromSuperview];
    }
    cell.accessoryView = nil;
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        _firstPayAmountLabel.text = [NSString stringWithFormat:@"￥ %@", _order.firstPayAmount];
        _measureAmountLabel.text = [NSString stringWithFormat:@"￥ %@", _order.measurePayAmount];
        _waitFirstPayAmountLabel.text = [NSString stringWithFormat:@"￥ %.2f", (_order.firstPayAmount.floatValue - _order.measurePayAmount.floatValue)];
        [cell.contentView addSubview:_waitFirstPayView];
    }else if (indexPath.section == 0 && indexPath.row == 4) {
        _designPageLabel.text = [NSString stringWithFormat:@"%d 张", _order.designPageNum];
        _diyPageLabel.text = [NSString stringWithFormat:@"%d 张", _order.diyPageNum];
        _addPagePriceLabel.text = [NSString stringWithFormat:@"%d 元/张", _order.addPagePrice];
        [cell.contentView addSubview:_designContentView];
    }else if (indexPath.section == 0 && indexPath.row == 5){
        _commentLabel.text = _order.comments;
        
        CGRect frame = _commentLabel.frame;
        frame.size.height = [_commentLabel.text heightWithFont:_commentLabel.font constrainedToWidth:CGRectGetWidth(_commentLabel.frame)];
        _commentLabel.frame = frame;
        
        frame = _commentView.frame;
        frame.size.height = CGRectGetMaxY(_commentView.frame) + 10;
        _commentView.frame = frame;
        [cell.contentView addSubview:_commentView];
    }else if (indexPath.section == 1 && indexPath.row == 9){
        _addressLabel.text = _order.address;
        
        CGRect frame = _addressLabel.frame;
        frame.size.height = [_addressLabel.text heightWithFont:_addressLabel.font constrainedToWidth:CGRectGetWidth(_addressLabel.frame)];
        _addressLabel.frame = frame;
        
        frame = _addressView.frame;
        frame.size.height = CGRectGetMaxY(_addressLabel.frame) + 10;
        _addressView.frame = frame;
        [cell.contentView addSubview:_addressView];
    }else if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = _keys[indexPath.section][indexPath.row];
    }else{
        cell.textLabel.text = _keys[indexPath.section][indexPath.row];
        cell.detailTextLabel.text = _values[indexPath.section][indexPath.row];
    }
    return cell;
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

@end
