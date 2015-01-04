//
//  RealNameAuthViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/1.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "RealNameAuthViewController.h"
#import "TextFieldCell.h"
#import "UploadCardImageViewController.h"
#import "JRDesigner.h"

@interface RealNameAuthViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) UITextField *selectedTextField;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, assign) RealNameAuthStatus status;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *placeholders;

@end

@implementation RealNameAuthViewController

-(void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"实名认证";
    _keys = @[@"真实姓名", @"身份证号码", @"证件图片", @"手持证件照"];
    _placeholders = @[@"输入与身份证一致的名字", @"与真实姓名一致的身份证号码", @"上传证件照片", @"上传照片"];
    [self setupUI];
    _status = RealNameAuthStatusCommiting;
    _designer = [[JRDesigner alloc] init];
    
    [self reloadData];
    [self loadData];
}

- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_DESIGNER_SELFDETAIL parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken: @"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _designer = [_designer buildDetailWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            }
        }
    }];
}

- (void)setupUI{
    
    for (NSInteger i = 0; i < 6; i++) {
        UIView *v = [_tableHeaderView viewWithTag:1100+i];
        v.layer.masksToBounds = YES;
        v.layer.cornerRadius = CGRectGetHeight(v.frame)/2.f;
    }
    
    CGRect frame = _tableHeaderView.frame;
    frame.origin = CGPointMake(0, 0);
    _tableHeaderView.frame = frame;
    [self.view addSubview:_tableHeaderView];
    
    frame = CGRectMake(0, CGRectGetMaxY(_tableHeaderView.frame), kWindowWidth, kWindowHeightWithoutNavigationBar - CGRectGetMaxY(_tableHeaderView.frame));
    
    self.tableView = [self.view tableViewWithFrame:frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    frame = CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(_tableView.frame) - _keys.count*44);
    UIView *footerView = [[UIView alloc] initWithFrame:frame];
    
    frame = CGRectMake(10, CGRectGetHeight(footerView.frame) - 44 -10, CGRectGetWidth(footerView.frame) - 20, 44);
    UIButton *btn = [footerView buttonWithFrame:frame target:self action:@selector(onSubmit:) title:@"提交认证" backgroundImage:nil];
    btn.backgroundColor = RGBColor(66, 103, 177);
    [footerView addSubview:btn];
    _tableView.tableFooterView = footerView;
    
    frame = CGRectMake(0, CGRectGetMaxY(_tableHeaderView.frame), kWindowWidth, kWindowHeightWithoutNavigationBar - CGRectGetMaxY(_tableHeaderView.frame));
    self.bgView = [[UIView alloc] initWithFrame:frame];
    _bgView.hidden = YES;
    _bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgView];
    
    frame = CGRectMake(10, 0, kWindowWidth - 12, 12);
    self.descLabel = [_bgView labelWithFrame:frame text:@"实名认证" textColor:RGBColor(66, 103, 177) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSmallSystemFontSize]];
    [self.bgView addSubview:_descLabel];
    
    frame = _contentView.frame;
    frame.origin = CGPointMake(0, CGRectGetMaxY(_descLabel.frame)+10);
    _contentView.frame = frame;
    [self.bgView addSubview:_contentView];
}

- (void)reloadData{
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *label = (UILabel*)[_tableHeaderView viewWithTag:1103+i];
        label.backgroundColor = RGBColor(175, 175, 175);
        if (i == _status) {
            label.backgroundColor = RGBColor(28, 79, 166);
        }
        
        label = (UILabel*)[_tableHeaderView viewWithTag:1106+i];
        label.textColor = [UIColor blackColor];
        if (i == _status) {
            label.textColor = RGBColor(28, 79, 166);
        }
    }
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.hidden = YES;
    _bgView.hidden = YES;
    if (_status == RealNameAuthStatusCommiting) {
        _tableHeaderView.backgroundColor = RGBColor(237, 237, 237);
        _tableView.hidden = NO;
        [_tableView reloadData];
    }else if (_status == RealNameAuthStatusReview){
        _bgView.hidden = NO;
    }else if (_status == RealNameAuthStatusApproved){
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSubmit:(id)sender{
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _keys.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        static NSString *CellIdentifier = @"TextFieldCell";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (TextFieldCell *)[nibs firstObject];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textField.enabled = YES;
        cell.textField.delegate = self;
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.titleLabel.text =  _keys[indexPath.row];
        cell.textField.placeholder = _placeholders[indexPath.row];
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.tag = 10+indexPath.row;
        if (indexPath.row == 1) {
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        return cell;
    }else{
        static NSString *cellIdentifier = @"personalData";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize+2];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
            cell.detailTextLabel.textColor = RGBColor(200, 200, 200);
        }
        cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 8, 15) image:[UIImage imageNamed:@"cellIndicator.png"]];
        cell.textLabel.text = _keys[indexPath.row];
        cell.detailTextLabel.text = _placeholders[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 2) {
        [_selectedTextField resignFirstResponder];
    }else{
        UploadCardImageViewController *vc = [[UploadCardImageViewController alloc] init];
        vc.type = indexPath.row - 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITextFieldDelegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isContainsEmoji]) {
        return NO;
    }
    
//    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.selectedTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 10) {
        
    }else if (textField.tag == 11){
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
