//
//  OrderDetailViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/2/8.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "JROrder.h"
#import "PrivateLetterViewController.h"
#import "JRDesigner.h"
#import "OrderActionView.h"
#import "OrderPhotoViewController.h"
#import "OrderPhotoBrowserViewController.h"
#import "JRWebViewController.h"
#import "TTTAttributedLabel.h"
#import "PrivateMessageDetailViewController.h"
#import "PrivateMessage.h"

@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *paymentInfoView;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *payStatusLabel;
@property (nonatomic, strong) IBOutlet UILabel *orderNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *measureAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel *firstAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel *finalAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel *amountLabel;
@property (nonatomic, strong) IBOutlet UILabel *watiPayAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel *payAmountLabel;

@property (nonatomic, strong) IBOutlet UIView *deliveryInfoView;
@property (nonatomic, strong) IBOutlet UIView *roomTypeView;
@property (nonatomic, strong) IBOutlet UILabel *roomTypeCountLabel;
@property (nonatomic, strong) IBOutlet UIView *fileView;
@property (nonatomic, strong) IBOutlet UILabel *fileCountLabel;

@property (nonatomic, strong) IBOutlet UIView *customerInfoView;
@property (nonatomic, strong) IBOutlet UIImageView *customerHeaderImgView;
@property (nonatomic, strong) IBOutlet UILabel *customerRealNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *customerNameLabel;

@property (nonatomic, strong) IBOutlet UIView *designerInfoView;
@property (nonatomic, strong) IBOutlet UIImageView *designerHeaderImgView;
@property (nonatomic, strong) IBOutlet UILabel *designerRealNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *designerNameLabel;

@property (nonatomic, strong) IBOutlet UIView *addressView;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;

@property (nonatomic, strong) OrderActionView *footerView;

@property (nonatomic, strong) IBOutlet UIView *actionView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, assign) BOOL isHiddenSelfInfo;

@end

@implementation OrderDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"订单详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReloadDataNotification:) name:kNotificationNameOrderReloadData object:nil];
    
#ifdef kJuranDesigner
    self.keys = @[@[@"",@""], @[@"", @"手机号码", @"电子邮箱", @"会员卡号", @"微信号", @"户型", @"面积", @"装修地址"], @[@"", @"手机号码", @"电子邮箱", @"微信号"]];
#else
    self.keys = @[@[@"",@""], @[@"", @"手机号码", @"电子邮箱", @"微信号"], @[@"", @"手机号码", @"电子邮箱", @"会员卡号", @"微信号", @"户型", @"面积", @"装修地址"]];
#endif
    [self resetValues];
    [self setupUI];
    [self loadData];
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBar - 37) style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _customerHeaderImgView.layer.masksToBounds = YES;
    _customerHeaderImgView.layer.cornerRadius = CGRectGetHeight(_customerHeaderImgView.frame)/2.f;
    
    _designerHeaderImgView.layer.masksToBounds = YES;
    _designerHeaderImgView.layer.cornerRadius = CGRectGetHeight(_designerHeaderImgView.frame)/2.f;
    
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *btn = (UIButton*)[_actionView viewWithTag:1100 + i];
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = RGBColor(49, 89, 143).CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = 3.f;
    }
    
    self.footerView = [[OrderActionView alloc] initWithFrame:CGRectMake(0, kWindowHeightWithoutNavigationBar - 37, kWindowWidth, 37)];
    _footerView.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:_footerView];
}

- (void)reloadData{
    [self resetValues];
    for (UIView *v in _footerView.subviews) {
        [v removeFromSuperview];
    }
    [_footerView fillViewWithOrder:_order];
    [_tableView reloadData];
    if (_footerView.subviews.count == 0) {
        _footerView.hidden = YES;
        _tableView.frame = kContentFrameWithoutNavigationBar;
    }else{
        _footerView.hidden = NO;
        _tableView.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBar - 37);
    }
}

- (void)receiveReloadDataNotification:(NSNotification*)notification{
    [self loadData];
}

- (void)resetValues{
#ifdef kJuranDesigner
    self.values = @[@[@"",@""], @[@"", _order.customerMobile, _order.customerEmail, _order.customerCardNo, _order.customerWechat, _order.houseType, _order.houseAreaString, _order.addressInfo], @[@"", _order.decoratorMobile, _order.decoratorEmail, _order.decoratorWechat]];
#else
    self.values = @[@[@"",@""], @[@"", _order.decoratorMobile, _order.decoratorEmail, _order.decoratorWechat], @[@"", _order.customerMobile, _order.customerEmail, _order.customerCardNo, _order.customerWechat, _order.houseType, _order.houseAreaString, _order.addressInfo]];
#endif
}

- (void)loadData{
    [self showHUD];
    NSDictionary *param = @{@"tid": _order.type?_order.designTid:_order.measureTid,
                            @"userType": [[ALTheme sharedTheme]userType]
                            };
    [[ALEngine shareEngine]  pathURL:JR_ORDER_DETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_order buildUpWithValueForDetail:data];
            [self reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target Action

- (void)onHiddenSelfInfo{
    _isHiddenSelfInfo = !_isHiddenSelfInfo;
    [_tableView reloadData];
    if (!_isHiddenSelfInfo) {
        [_tableView scrollToBottom];
    }
}

- (IBAction)onCall:(id)sender{
    NSString *number = @"";
    if ([self customerSection] == 1) {
        number = _order.customerMobile;
    }else{
        number = _order.decoratorMobile;
    }
    if (number.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"tel://%@",number]]];
    }else{
        [self showTip:@"设计师未绑定手机号码，不能拨出电话"];
    }
}

- (IBAction)onPrivateLetter:(id)sender{
#ifdef kJuranDesigner
    return;
#endif
//    PrivateLetterViewController *pv = [[PrivateLetterViewController alloc] init];
//    JRDesigner *designer = [[JRDesigner alloc] init];
//    designer.userId = _order.decoratorId;
//    
//    pv.designer = designer;
//    [self.navigationController pushViewController:pv animated:YES];
    /*
    [self showHUD];
    NSDictionary *param = @{@"receiverId": [NSString stringWithFormat:@"%d", [[ALTheme sharedTheme].userType isEqualToString:@"designer"]?_order.customerId:_order.decoratorId],
                            };
    [[ALEngine shareEngine]  pathURL:JR_CHECK_PRIVATE_LETTER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
         [self hideHUD];
        if (!error) {
            NSString *privateLetterid = [data getStringValueForKey:@"privateLetterId" defaultValue:@""];
            if (privateLetterid.length == 0) {
                PrivateLetterViewController *pv = [[PrivateLetterViewController alloc] init];
//                pv.designer = _designer;
                [self.navigationController pushViewController:pv animated:YES];
            }else{
                PrivateMessageDetailViewController *vc = [[PrivateMessageDetailViewController alloc] init];
                PrivateMessage *message = [[PrivateMessage alloc] init];
                message.letterId = privateLetterid.integerValue;
                vc.message = message;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];*/
}

- (IBAction)onRoomTypePhoto:(id)sender{
    if (_order.measurefileSrc.count == 0) {
        return;
    }
    if (_order.measurefileSrc.count == 1) {
        OrderPhotoBrowserViewController *vc = [[OrderPhotoBrowserViewController alloc] initWithPhotos:_order.measurefileSrc andStartWithPhotoAtIndex:0];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        OrderPhotoViewController *vc = [[OrderPhotoViewController alloc] init];
        vc.order = _order;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onEffectPhoto:(id)sender{
    if (_order.fileSrc.count == 0) {
        return;
    }
    if (_order.fileSrc.count == 1) {
        OrderPhotoBrowserViewController *vc = [[OrderPhotoBrowserViewController alloc] initWithPhotos:_order.fileSrc andStartWithPhotoAtIndex:0];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        OrderPhotoViewController *vc = [[OrderPhotoViewController alloc] init];
        vc.order = _order;
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onContract:(id)sender{
    JRWebViewController *vc = [[JRWebViewController alloc] init];
    vc.urlString = @"http://apph5.juran.cn/contract?fromApp=1";
    vc.title = @"居然在线设计师合同条款";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate BEGIN

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = _keys[section];
    if (section == 2 && _isHiddenSelfInfo) {
        return 0;
    }
    if (section == 1) {
        return rows.count + 1;
    }
    if (section == 0) {
        if (_order.measurefileSrc.count == 0 && _order.fileSrc.count == 0) {
            return 1;
        }
    }
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *rows = _keys[indexPath.section];
    if (indexPath.section == 0 && indexPath.row == 0) {
        return _order.type == 0?75:185;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        if (_order.measurefileSrc.count && _order.fileSrc.count) {
            return 160;
        }else if (_order.measurefileSrc.count || _order.fileSrc.count){
            return 90;
        }
        return 0;
    }else if (indexPath.row == 0 && (indexPath.section == 1 || indexPath.section == 2)){
        return 70;
    }else if (indexPath.section == [self customerSection] && indexPath.row == 7) {
        return 40 + [_values[indexPath.section][indexPath.row] heightWithFont:[UIFont systemFontOfSize:kSmallSystemFontSize] constrainedToWidth:290];
    }else if (indexPath.section == 1 && indexPath.row == rows.count) {
        return 45;
    }else{
        return 40;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     if (indexPath.section == [self customerSection] && indexPath.row == 7) {
     static NSString *cellIdentifier = @"OrderDetailValue2";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
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
     
     cell.detailTextLabel.numberOfLines = 0;
     cell.textLabel.text = _keys[indexPath.section][indexPath.row];
     cell.detailTextLabel.text = _values[indexPath.section][indexPath.row];
     
     return cell;
     }else{*/
    
    static NSString *cellIdentifier = @"OrderDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
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
    NSArray *rows = _keys[indexPath.section];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        _statusLabel.text =  _order.statusName;
        if (_order.type == 0) {
            _orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@", _order.measureTid];
            __weak typeof(self.order) weakOrder = self.order;
            [_payStatusLabel setText:[NSString stringWithFormat:@"量房金额：￥%@", _order.amount]afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange range = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"￥%@", weakOrder.measurePayAmount] options:NSCaseInsensitiveSearch];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:range];
                return mutableAttributedString;
            }];
        }else{
            [_payStatusLabel setText:[NSString stringWithFormat:@"支付状态：%@", _order.payStatusString]];
            _orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@", _order.designTid];
            _measureAmountLabel.text = [NSString stringWithFormat:@"量房费 ￥%@", _order.measurePayAmount];
            _firstAmountLabel.text = [NSString stringWithFormat:@"首款 ￥%@", _order.firstPayAmount];
            _finalAmountLabel.text = [NSString stringWithFormat:@"尾款 ￥%@", _order.finalPayAmount];
            _amountLabel.text = [NSString stringWithFormat:@"总金额 ￥%@", _order.amount];
            _payAmountLabel.text = [NSString stringWithFormat:@"已付 ￥%@", _order.payAmount];
            _watiPayAmountLabel.text = [NSString stringWithFormat:@"实付 ￥%@", _order.waitPayAmount];
        }
        [cell.contentView addSubview:_paymentInfoView];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        [_roomTypeView removeFromSuperview];
        [_fileView removeFromSuperview];
        if (_order.measurefileSrc.count && _order.fileSrc.count) {
            _roomTypeView.frame = CGRectMake(0, 26, CGRectGetWidth(_roomTypeView.frame), CGRectGetHeight(_roomTypeView.frame));
            [_deliveryInfoView addSubview:_roomTypeView];
            
            _fileView.frame = CGRectMake(0, 92, CGRectGetWidth(_fileView.frame), CGRectGetHeight(_fileView.frame));
            [_deliveryInfoView addSubview:_fileView];
        }else if (_order.measurefileSrc.count || _order.fileSrc.count){
            if (_order.measurefileSrc.count) {
                _roomTypeView.frame = CGRectMake(0, 26, CGRectGetWidth(_roomTypeView.frame), CGRectGetHeight(_roomTypeView.frame));
                [_deliveryInfoView addSubview:_roomTypeView];
            }
            if (_order.fileSrc.count) {
                _fileView.frame = CGRectMake(0, 26, CGRectGetWidth(_fileView.frame), CGRectGetHeight(_fileView.frame));
                [_deliveryInfoView addSubview:_fileView];
            }
        }
        _roomTypeCountLabel.hidden = _order.measurefileSrc.count <= 3;
        _roomTypeCountLabel.text = [NSString stringWithFormat:@"共%d张", _order.measurefileSrc.count];
        _fileCountLabel.hidden = _order.fileSrc.count <= 3;
        _fileCountLabel.text = [NSString stringWithFormat:@"共%d张", _order.fileSrc.count];
        for (NSInteger i = 0; i < _order.measurefileSrc.count; i++) {
            UIImageView *imageView = (UIImageView*)[_deliveryInfoView viewWithTag:1300 + i];
            [imageView setImageWithURLString:_order.measurefileSrc[i]];
        }
        for (NSInteger i = 0; i < _order.fileSrc.count; i++) {
            UIImageView *imageView = (UIImageView*)[_deliveryInfoView viewWithTag:1400 + i];
            [imageView setImageWithURLString:_order.fileSrc[i]];
        }
        [cell.contentView addSubview:_deliveryInfoView];
    }else if (indexPath.row == 0 && indexPath.section == [self designerSection]){
        [_designerHeaderImgView setImageWithURLString:_order.headUrl];
        _designerRealNameLabel.text = [NSString stringWithFormat:@"真实姓名 %@", _order.decoratorRealName];
        _designerNameLabel.text = [NSString stringWithFormat:@"用户名 %@", _order.decoratorName];
        [cell.contentView addSubview:_designerInfoView];
    }else if (indexPath.row == 0 && indexPath.section == [self customerSection]){
        [_customerHeaderImgView setImageWithURLString:_order.customerHeadUrl];
        _customerRealNameLabel.text = [NSString stringWithFormat:@"真实姓名 %@", _order.customerRealName];
        _customerNameLabel.text = [NSString stringWithFormat:@"用户名 %@", _order.customerName];
        [cell.contentView addSubview:_customerInfoView];
    }else if (indexPath.row == rows.count && indexPath.section == 1){
        /*
        NSString *number = nil;
        if ([self customerSection] == 1) {
            number = _order.customerMobile;
        }else{
            number = _order.decoratorMobile;
        }
        UIButton *btn = (UIButton*)[_actionView viewWithTag:1100];
        if (number.length == 0) {
            btn.enabled = NO;
            btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
        }else{
            btn.enabled = YES;
            btn.layer.borderColor = RGBColor(49, 89, 143).CGColor;
        }*/
        [cell.contentView addSubview:_actionView];
    }else if (indexPath.section == [self customerSection] && indexPath.row == 7){
        _addressLabel.text = _values[indexPath.section][indexPath.row];
        
        CGRect frame = _addressLabel.frame;
        frame.size.height = [_addressLabel.text heightWithFont:_addressLabel.font constrainedToWidth:CGRectGetWidth(_addressLabel.frame)];
        _addressLabel.frame = frame;
        
        frame = _addressView.frame;
        frame.size.height = CGRectGetMaxY(_addressLabel.frame) + 10;
        _addressView.frame = frame;
        [cell.contentView addSubview:_addressView];
    } else{
        cell.textLabel.text = _keys[indexPath.section][indexPath.row];
        cell.detailTextLabel.text = _values[indexPath.section][indexPath.row];
    }
    return cell;
    /*
     }*/
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 35)];
        view.backgroundColor = [UIColor clearColor];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kWindowWidth, 25)];
        view2.backgroundColor = RGBColor(226, 226, 226);
        [view addSubview:view2];
        
        if (section == 2) {
            UIButton *btn = [view2 buttonWithFrame:view2.bounds target:self action:@selector(onHiddenSelfInfo) image:nil];
            [view2 addSubview:btn];
        }
        
        UILabel *label = [view2 labelWithFrame:CGRectMake(10, 5, 100, 15) text:@"" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
        [view2 addSubview:label];
        
        if (section == [self designerSection]) {
            label.text = @"设计师（乙方）";
        }else if (section == [self customerSection]){
            label.text = @"消费者（甲方）";
        }
        
        if (section == 2) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_isHiddenSelfInfo?@"arrow_up.png":@"arrow_down.png"]];
            imageView.center = CGPointMake(kWindowWidth - 10 - CGRectGetWidth(imageView.frame), CGRectGetHeight(view2.frame)/2.f);
            [view2 addSubview:imageView];
        }
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 35;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


#pragma mark - UITableViewDataSource/UITableViewDelegate END

- (NSInteger)designerSection{
#ifdef kJuranDesigner
    return 2;
#else
    return 1;
#endif
}

- (NSInteger)customerSection{
#ifdef kJuranDesigner
    return 1;
#else
    return 2;
#endif
}

@end
