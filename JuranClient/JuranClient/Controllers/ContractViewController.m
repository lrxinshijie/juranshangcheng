//
//  ContractViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/2/26.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ContractViewController.h"
#import "JROrder.h"
#import "TextFieldCell.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetMultiPicker.h"
#import "BaseAddressViewController.h"
#import "JRAreaInfo.h"
#import "TTTAttributedLabel.h"
#import "ContractPreviewViewController.h"
#import "JRWebViewController.h"

@interface ContractViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSMutableDictionary *hiddenSectionDic;

@property (nonatomic, strong) IBOutlet UIView *waitFirstPayView;
@property (nonatomic, strong) IBOutlet UIView *designContentView;
@property (nonatomic, strong) IBOutlet UIView *tableFooterView;
@property (nonatomic, strong) IBOutlet UIView *addressView;
@property (nonatomic, strong) UITextField *selectedTextField;
@property (nonatomic, strong) UITextView *selectedTextView;

@property (nonatomic, strong) IBOutlet UITextField *firstPayAmountTextField;
@property (nonatomic, strong) IBOutlet UITextField *measureAmountTextField;
@property (nonatomic, strong) IBOutlet UITextField *designPageNumTextField;
@property (nonatomic, strong) IBOutlet UITextField *diyPageNumTextField;
@property (nonatomic, strong) IBOutlet UITextField *addPagePriceTextField;
@property (nonatomic, strong) IBOutlet ASPlaceholderTextView *commentTextView;
@property (nonatomic, strong) IBOutlet ASPlaceholderTextView *addessTextView;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *waitFirstPayAmountLabel;
@property (nonatomic, assign) BOOL isReadContact;
@property (nonatomic, strong) IBOutlet UIImageView *readFlagImgView;
@property (nonatomic, assign) BOOL isImmediate;

@end

@implementation ContractViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"创建设计合同";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    if (!_order) {
        _order = [[JROrder alloc] init];
        self.isImmediate = YES;
    }
    self.keys = @[@[[NSString stringWithFormat:@"量房合同编号：%@", _order.type?_order.designTid:_order.measureTid] , @"合同金额（元）", @"量房日期", @"待支付首款", @"尾款", @"设计工作内容"]
                  , @[@"真实姓名", @"用户名", @"手机号", @"微信号", @"会员卡号", @"电子邮箱", @"户型", @"面积", @"装修地址", @"小区名称"]
                  , @[@"真实姓名", @"用户名", @"手机号", @"微信号", @"电子邮箱"]];
    self.tags = @[@[@"", @"1200", @"", @"", @"", @""]
                  , @[@"1201", @"1202", @"1203", @"1204", @"1205", @"1206", @"", @"1207", @"", @"1208"]
                  , @[@"1209", @"1210", @"1211", @"1212", @"1213"]];
    self.hiddenSectionDic = [NSMutableDictionary dictionary];
//    _order.firstPayAmount = @"1";
//    _order.designPageNum = 1;
//    _order.diyPageNum = 2;
//    _order.addPagePrice = 100;
//    _order.customerRealName = @"ss";
    
    
    
    [self reSetValue];
    [self setupUI];
    [self loadData];
}

- (void)loadData{
    [self showHUD];
    NSDictionary *param = @{@"tid": _order.measureTid};
    [[ALEngine shareEngine]  pathURL:JR_ORDER_APPLE_DESIGN_TRADE_INIT parameters:_order.measureTid.length == 0?nil:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_order buildUpWithValueForContractInit:data];
            [self reloadData];
        }
    }];
}

- (void)reSetValue{
//    _order.amount = @"1000";
//    _order.firstPayAmount = @"300";
//    _order.measurePayAmount = @"10";
//    _order.designPageNum = 1;
//    _order.diyPageNum = 10;
//    _order.addPagePrice = 100;
//    _order.customerCardNo = @"23847234";
//    _order.customerEmail = @"23402834@qq.com";
//    _order.decoratorMobile = @"13589092736";
//    _order.decoratorWechat = @"sjkdlf";
//    _order.decoratorEmail = @"942023487@qq.com";
    _order.finalPayAmount = [NSString stringWithFormat:@"%.2f", _order.amount.floatValue - _order.firstPayAmount.floatValue];
    self.values = @[@[@"", _order.amount, _order.serviceDateString, _order.firstPayAmount, _order.finalPayAmount, @""]
                    , @[_order.customerRealName, _order.customerName, _order.customerMobile, _order.customerWechat, _order.customerCardNo, _order.customerEmail, _order.roomTypeString, _order.houseArea, _order.areaInfo.title, _order.address]
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
    
    for (NSInteger i = 0; i < 2; i++) {
        UIView *view = [_waitFirstPayView viewWithTag:1100 + i];
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = RGBColor(241, 241, 241).CGColor;
    }
    
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [_designContentView viewWithTag:1100 + i];
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = RGBColor(241, 241, 241).CGColor;
    }
    
    UIView *view = [_tableFooterView viewWithTag:1100];
    view.layer.borderWidth = .5f;
    view.layer.borderColor = [UIColor darkGrayColor].CGColor;
    view.layer.cornerRadius = 2.f;
    
    view = [_tableFooterView viewWithTag:1101];
    view.layer.borderWidth = .5f;
    view.layer.borderColor = RGBColor(0, 54, 114).CGColor;
    view.layer.cornerRadius = 2.f;
    
    _commentTextView.placeholder = @"请输入200字以内的备注说明";
    _addessTextView.placeholder = @"请输入详细地址";
    _addessTextView.layer.borderWidth = 1.f;
    _addessTextView.layer.borderColor = RGBColor(241, 241, 241).CGColor;
    
    TTTAttributedLabel *label = (TTTAttributedLabel*)[_designContentView viewWithTag:1300];
    [label setText:@"说明：设计师还需提供详细施工图纸，具体详见《住宅室内装饰设计合同》中的合同条款。" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = [[mutableAttributedString string] rangeOfString:@"《住宅室内装饰设计合同》" options:NSCaseInsensitiveSearch];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:range];
        return mutableAttributedString;
    }];
    label = (TTTAttributedLabel*)[_tableFooterView viewWithTag:1300];
    [label setText:@"已阅读并接受《住宅室内装饰设计合同》中得合同条款" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = [[mutableAttributedString string] rangeOfString:@"《住宅室内装饰设计合同》" options:NSCaseInsensitiveSearch];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:range];
        return mutableAttributedString;
    }];
    
    _measureAmountTextField.enabled = _isImmediate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)onCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRead:(id)sender{
    _isReadContact = !_isReadContact;
    _readFlagImgView.image = [UIImage imageNamed:_isReadContact?@"box_selected.png":@"box_unselected.png"];
}

- (IBAction)onHiddenKeyBoard:(id)sender{
    if (_selectedTextField) {
        [_selectedTextField resignFirstResponder];
    }
    if (_selectedTextView) {
        [_selectedTextView resignFirstResponder];
    }
}

- (IBAction)onDesignContract:(id)sender{
    JRWebViewController *vc = [[JRWebViewController alloc] init];
    vc.urlString = @"http://apph5.juran.cn/contract?fromApp=1";
    vc.title = @"居然在线设计师合同条款";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onSubmit:(id)sender{
    if (_selectedTextField) {
        [_selectedTextField resignFirstResponder];
    }
    if (_selectedTextView) {
        [_selectedTextView resignFirstResponder];
    }
    /*
    if (!(_order.amount.floatValue > 0.f)) {
        [self showTip:@"合同金额不能小于0！"];
        return;
    }
    if (!(_order.firstPayAmount.floatValue > 0.f)) {
        [self showTip:@"首付金额不能小于0！"];
        return;
    }
    if (!(_order.designPageNum > 0)) {
        [self showTip:@"效果图不能小于0！"];
        return;
    }
    if (!(_order.diyPageNum > 0)) {
        [self showTip:@"DIY渲染图不能小于0！"];
        return;
    }
    if (!(_order.addPagePrice > 0)) {
        [self showTip:@"额外的效果图每张金额不能小于0！"];
        return;
    }
    if (!(_order.customerRealName.length > 0)) {
        [self showTip:@"消费者真实姓名不能为空！"];
        return;
    }
    if (!(_order.customerName.length > 0)) {
        [self showTip:@"消费者用户名不能为空！"];
        return;
    }
    if (!(_order.customerMobile.length > 0)) {
        [self showTip:@"消费者手机号不能为空！"];
        return;
    }
    if (!(_order.customerWechat.length > 0)) {
        [self showTip:@"消费者微信号不能为空！"];
        return;
    }
    if (!(_order.customerCardNo.length > 0)) {
        [self showTip:@"消费者会员卡号不能为空！"];
        return;
    }
    if (!(_order.customerEmail.length > 0)) {
        [self showTip:@"消费者电子邮箱不能为空！"];
        return;
    }
    if (!(_order.roomTypeString.length > 0)) {
        [self showTip:@"消费者户型不能为空！"];
        return;
    }
    if (!(_order.houseAreaString.length > 0)) {
        [self showTip:@"消费者房屋面积不能为空！"];
        return;
    }
    if (!(_order.areaInfo.title > 0)) {
        [self showTip:@"消费者装修地址不能为空！"];
        return;
    }
    if (!(_order.address.length > 0)) {
        [self showTip:@"消费者小区名称不能为空！"];
        return;
    }
    if (!(_order.decoratorRealName.length > 0)) {
        [self showTip:@"设计师真实姓名不能为空！"];
        return;
    }
    if (!(_order.decoratorName.length > 0)) {
        [self showTip:@"设计师用户名不能为空！"];
        return;
    }
    if (!(_order.decoratorMobile.length > 0)) {
        [self showTip:@"设计师手机号不能为空！"];
        return;
    }
    if (!(_order.decoratorWechat.length > 0)) {
        [self showTip:@"设计师微信号不能为空！"];
        return;
    }
    if (!(_order.decoratorEmail.length > 0)) {
        [self showTip:@"设计师电子邮箱不能为空！"];
        return;
    }*/
    if (_isImmediate) {
        if (_order.decoratorEmail.length > 0) {
            if (!_order.decoratorEmail.validateEmail) {
                [self showTip:@"请输入正确地设计师电子邮箱!"];
                return;
            }
        }
        if (_order.customerEmail.length > 0) {
            if (!_order.decoratorEmail.validateEmail) {
                [self showTip:@"请输入正确地消费者电子邮箱!"];
                return;
            }
        }
    }
    
    if (!_isReadContact) {
        [self showTip:@"请阅读《住宅室内装饰设计合同》！"];
        return;
    }
    
    CGFloat value = _order.amount.floatValue * 0.2f;
    if (_order.firstPayAmount.floatValue < value || _order.firstPayAmount.floatValue > _order.amount.floatValue) {
        [self showTip:@"首付定金不低于合同金额的20%并且不高于合同金！"];
        return;
    }
    
    ContractPreviewViewController *vc = [[ContractPreviewViewController alloc] init];
    vc.order = _order;
    [self.navigationController pushViewController:vc animated:YES];
    
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
    if (section == 0 && _isImmediate) {
        return rows.count - 1;
    }
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (indexPath.section == 0 && _isImmediate) {
        row = row + 1;
    }
    if (indexPath.section == 0 && row == 3) {
        return 140;
    }else if (indexPath.section == 0 && row == 5){
        return 285;
    }else if (indexPath.section == 1 && row == 9){
        return 80;
    }
    return 36;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 35)];
    view.backgroundColor = RGBColor(232, 232, 232);
    
    UIButton *btn = [view buttonWithFrame:view.bounds target:self action:@selector(onHiddenSection:) image:nil];
    btn.tag = section;
    [view addSubview:btn];
    
    UILabel *label = [view labelWithFrame:CGRectMake(10, 10, 100, 15) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
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
    NSInteger row = indexPath.row;
    if (indexPath.section == 0 && _isImmediate) {
        row = row + 1;
    }
    if ((indexPath.section == 0 && row == 1) || (_isImmediate && ((indexPath.section == 1 && row != 6 && row != 8 && row != 9) || (indexPath.section == 2)))) {
        static NSString *CellIdentifier = @"TextFieldCell";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (TextFieldCell *)[nibs firstObject];
        }
        
        cell.titleLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.titleLabel.textColor = [UIColor darkGrayColor];
        
        CGPoint center = cell.titleLabel.center;
        center.y = 18;
        cell.titleLabel.center = center;
        center = cell.textField.center;
        center.y = 18;
        center.x -= 5;
        cell.textField.center = center;
        
        cell.textField.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textField.enabled = YES;
        cell.textField.delegate = self;
        cell.textField.tag = [_tags[indexPath.section][row] integerValue];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text =  _keys[indexPath.section][row];
        cell.textField.placeholder = @"请输入";
        cell.textField.text = _values[indexPath.section][row];
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        
        if ((indexPath.section == 2 && row == 2) || (indexPath.section == 1 && row == 2)){
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
        }else if ((indexPath.section == 0 && row == 1) || (indexPath.section == 1 && (row == 4 || row == 7))){
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        return cell;
    }else{
        static NSString *cellIdentifier = @"ContractCell";
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
        cell.accessoryView = nil;
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        UIView *view = [cell.contentView viewWithTag:5555];
        if (view) {
            [view removeFromSuperview];
        }
        
        if (indexPath.section == 0 && row == 3) {
            _firstPayAmountTextField.text = _order.firstPayAmount;
            _measureAmountTextField.text = _order.measurePayAmount;
            __weak typeof(self.order) weakOrder = self.order;
            [_waitFirstPayAmountLabel setText:[NSString stringWithFormat:@"=  %.2f 元", (_order.firstPayAmount.floatValue - _order.measurePayAmount.floatValue)] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange range = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"%.2f", (weakOrder.firstPayAmount.floatValue - weakOrder.measurePayAmount.floatValue)] options:NSCaseInsensitiveSearch];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:range];
                return mutableAttributedString;
            }];
            [cell.contentView addSubview:_waitFirstPayView];
        }else if (indexPath.section == 0 && row == 5) {
            _designPageNumTextField.text = [NSString stringWithFormat:@"%d", _order.designPageNum];
            _diyPageNumTextField.text = [NSString stringWithFormat:@"%d", _order.diyPageNum];
            _addPagePriceTextField.text = [NSString stringWithFormat:@"%d", _order.addPagePrice];
            [cell.contentView addSubview:_designContentView];
        }else if (indexPath.section == 0 && row == 0) {
            cell.textLabel.text = _keys[indexPath.section][row];
        }else if (indexPath.section == 0 && row == 4) {
            cell.textLabel.text = _keys[indexPath.section][row];
            cell.detailTextLabel.text = _values[indexPath.section][row];
        }else if (indexPath.section == 1 && indexPath.row == 9){
            _addessTextView.text = _order.address;
            _addessTextView.userInteractionEnabled = _isImmediate;
            [cell.contentView addSubview:_addressView];
        }else if (indexPath.section == 0 || _isImmediate){
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellIndicator.png"]];
            
            cell.textLabel.text = _keys[indexPath.section][row];
            NSString *value = _values[indexPath.section][row];
            if (value.length == 0) {
                cell.detailTextLabel.text = @"请选择";
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            }else{
                cell.detailTextLabel.text = value;
            }
        }else{
            cell.textLabel.text = _keys[indexPath.section][row];
            cell.detailTextLabel.text = _values[indexPath.section][row];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (indexPath.section == 0 && _isImmediate) {
        row = row + 1;
    }
    if (_selectedTextField) {
        [_selectedTextField resignFirstResponder];
    }
    if (_selectedTextView) {
        [_selectedTextView resignFirstResponder];
    }
    
    if (indexPath.section == 0 && row == 2) {
        NSArray *rows = @[@"只工作日",@"工作日、双休日与假日均可",@"只双休日、假日"];
        [ActionSheetStringPicker showPickerWithTitle:nil rows:rows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.order.serviceDate = [@[@"1",@"2",@"3"] objectAtIndex:selectedIndex];
            [self reloadData];
            
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:[UIApplication sharedApplication].keyWindow];
    }else if (indexPath.section == 1 && row == 6){
        NSMutableArray *rows = [NSMutableArray array];
        NSMutableArray *selects = [NSMutableArray array];
        
        NSMutableArray *datas = [NSMutableArray array];
        __block NSInteger ind = 0;
        NSArray *roomNum = [[DefaultData sharedData] roomNum];
        [roomNum enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [datas addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_order.roomNum]) {
                ind = idx;
            }
        }];
        [rows addObject:datas];
        [selects addObject:@(ind)];
        
        ind = 0;
        NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
        datas = [NSMutableArray array];
        [livingroomCount enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [datas addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_order.livingroomNum]) {
                ind = idx;
            }
        }];
        [rows addObject:datas];
        [selects addObject:@(ind)];
        
        ind = 0;
        NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
        datas = [NSMutableArray array];
        [bathroomCount enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [datas addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_order.bathroomNum]) {
                ind = idx;
            }
        }];
        [rows addObject:datas];
        [selects addObject:@(ind)];
        
        [ActionSheetMultiPicker showPickerWithTitle:nil rows:rows initialSelection:selects doneBlock:^(ActionSheetMultiPicker *picker, NSArray *selectedIndexs, NSArray *selectedValues) {
            NSArray *roomNum = [[DefaultData sharedData] roomNum];
            _order.roomNum = [[roomNum objectAtIndex:[selectedIndexs[0] integerValue]] objectForKey:@"v"];
            
            NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
            _order.livingroomNum = [[livingroomCount objectAtIndex:[selectedIndexs[1] integerValue]] objectForKey:@"v"];
            
            NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
            _order.bathroomNum = [[bathroomCount objectAtIndex:[selectedIndexs[2] integerValue]] objectForKey:@"v"];
            
            [self reloadData];
        } cancelBlock:^(ActionSheetMultiPicker *picker) {
            
        } origin:[UIApplication sharedApplication].keyWindow];
    }else if (indexPath.section == 1 && row == 8){
        BaseAddressViewController *vc = [[BaseAddressViewController alloc] init];
        [vc setFinishBlock:^(JRAreaInfo *areaInfo) {
            _order.areaInfo = areaInfo;
            [self reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.selectedTextView = textView;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.commentTextView) {
        _order.comments = textView.text;
    }else if (textView == self.addessTextView){
        _order.address = textView.text;
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == self.commentTextView) {
        NSArray *rows = _keys[0];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows.count - 1 - (_isImmediate?1:0) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else if (textView == self.addessTextView){
        NSArray *rows = _keys[1];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows.count - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
   
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isContainsEmoji]) {
        return NO;
    }
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > 200) {
        [self showTip:@"内容长度不能超过200个字!"];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.selectedTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    /*
     self.keys = @[@[@"量房合同编号", @"合同金额（元）", @"量房日期", @"待支付首款", @"尾款", @"设计工作内容"]
     , @[@"真实姓名", @"用户名", @"手机号", @"微信号", @"会员卡号", @"电子邮箱", @"户型", @"面积", @"装修地址", @"小区名称"]
     , @[@"真实姓名", @"用户名", @"手机号", @"微信号", @"电子邮箱"]];
     self.values = @[@[]
     , @[]
     , @[]];
     self.tags = @[@[@"", @"1200", @"", @"", @"", @""]
     , @[@"1201", @"1202", @"1203", @"1204", @"1205", @"1206", @"", @"1207", @"", @"1208"]
     , @[@"1209", @"1210", @"1211", @"1212", @"1213"]];
     */
    if (textField.tag == 1200) {
        _order.amount = textField.text;
    }else if (textField.tag == 1201){
        _order.customerRealName = textField.text;
    }else if (textField.tag == 1202){
        _order.customerName = textField.text;
    }else if (textField.tag == 1203){
        _order.customerMobile = textField.text;
    }else if (textField.tag == 1204){
        _order.customerWechat = textField.text;
    }else if (textField.tag == 1205){
        _order.customerCardNo = textField.text;
    }else if (textField.tag == 1206){
        _order.customerEmail = textField.text;
    }else if (textField.tag == 1207){
        _order.houseArea = textField.text;
    }else if (textField.tag == 1208){
        _order.address = textField.text;
    }else if (textField.tag == 1209){
        _order.decoratorRealName = textField.text;
    }else if (textField.tag == 1210){
        _order.decoratorName = textField.text;
    }else if (textField.tag == 1211){
        _order.decoratorMobile = textField.text;
    }else if (textField.tag == 1212){
        _order.decoratorWechat = textField.text;
    }else if (textField.tag == 1213){
        _order.decoratorEmail = textField.text;
    }else if (textField.tag == 1250){
        _order.firstPayAmount = textField.text;
    }else if (textField.tag == 1251){
        _order.measurePayAmount = textField.text;
    }else if (textField.tag == 1252){
        _order.designPageNum = textField.text.integerValue;
    }else if (textField.tag == 1253){
        _order.diyPageNum = textField.text.integerValue;
    }else if (textField.tag == 1254){
        _order.addPagePrice = textField.text.integerValue;
    }
    [self reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSTimeInterval animation = animationDuration;
    
    //视图移动的动画开始
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animation];
    CGRect frame = _tableView.frame;
    frame.size.height = kWindowHeightWithoutNavigationBar - keyboardSize.height;
    _tableView.frame = frame;
    
    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    _tableView.frame = kContentFrameWithoutNavigationBar;
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
