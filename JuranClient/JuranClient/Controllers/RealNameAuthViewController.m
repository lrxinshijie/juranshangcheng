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

@interface RealNameAuthViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UploadCardImageViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) UITextField *selectedTextField;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *idCardNumLabel;
@property (nonatomic, strong) IBOutlet UIImageView *positiveIdImageView;
@property (nonatomic, strong) IBOutlet UIImageView *backIdImageView;
@property (nonatomic, strong) IBOutlet UIImageView *handImageView;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;

@property (nonatomic, assign) RealNameAuthStatus status;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *placeholders;

@property (nonatomic, strong) UIImage *positiveIdImage;
@property (nonatomic, strong) UIImage *backIdImage;
@property (nonatomic, strong) UIImage *headImage;

@property (nonatomic, strong) UIBarButtonItem *rightBarItem;

@end

@implementation RealNameAuthViewController

-(void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onResubmit) title:@"重新申请" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.title = @"实名认证";
    _keys = @[@"真实姓名", @"身份证号码", @"证件图片", @"手持证件照"];
    _placeholders = @[@"输入与身份证一致的名字", @"与真实姓名一致的身份证号码", @"上传证件照片", @"上传照片"];
    [self setupUI];
    _status = RealNameAuthStatusCommiting;
    
    [self reloadData];
    [self loadData];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    if (_status == RealNameAuthStatusCommiting) {
//        [_tableView reloadData];
//    }
//}

- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_REALNAMEAPPLY parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken: @"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _designer = [[JRDesigner alloc]initWithDictionaryForRealNameAuth:data];
//                _designer.realNameAuthStatus = 1;
//                _designer.realAuditDesc = @"老师就分了就是看对方即可";
                if (_designer.realNameAuthStatus == -1) {
                    _status = RealNameAuthStatusCommiting;
                }else if (_designer.realNameAuthStatus == 2){
                    _status = RealNameAuthStatusApproved;
                }else{
                    _status = RealNameAuthStatusReview;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            }
        }
    }];
}

- (void)setupUI{
    UIButton *hiddenBtn = [self.view buttonWithFrame:kContentFrameWithoutNavigationBar target:self action:@selector(onHidden) image:nil];
    [self.view addSubview:hiddenBtn];
    
    
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
    self.descLabel = [_bgView labelWithFrame:frame text:@"" textColor:RGBColor(66, 103, 177) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSmallSystemFontSize]];
    self.descLabel.numberOfLines = 0;
    [self.bgView addSubview:_descLabel];
    
    frame = _contentView.frame;
    frame.origin = CGPointMake(0, CGRectGetMaxY(_descLabel.frame)+10);
    _contentView.frame = frame;
    [self.bgView addSubview:_contentView];
}

- (void)reloadData{
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *label = (UILabel*)[_tableHeaderView viewWithTag:1103+i];
        label.text = [NSString stringWithFormat:@"%d", i + 1];
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
    self.navigationItem.rightBarButtonItem = nil;
    _tableView.hidden = YES;
    _bgView.hidden = YES;
    
    if (_status == RealNameAuthStatusCommiting) {
        _tableHeaderView.backgroundColor = RGBColor(237, 237, 237);
        _tableView.hidden = NO;
        [_tableView reloadData];
    }else{
        _bgView.hidden = NO;
        self.timeLabel.text = _designer.realNameGmtCreate;
        self.userNameLabel.text = _designer.userName;
        self.idCardNumLabel.text = _designer.idCardNum;
        [self.positiveIdImageView setImageWithURLString:_designer.positiveIdPhoto];
        [self.backIdImageView setImageWithURLString:_designer.backIdphoto];
        [self.handImageView setImageWithURLString:_designer.handHeldIdPhoto];
        self.statusLabel.text = [_designer realNameAuthStatusString];
        self.statusLabel.textColor = _designer.realNameAuthStatus == 1?[UIColor redColor]:RGBColor(28, 79, 166);
        self.descLabel.textColor = _designer.realNameAuthStatus == 1?[UIColor redColor]:RGBColor(28, 79, 166);
        self.navigationItem.rightBarButtonItem = _designer.realNameAuthStatus == 1?_rightBarItem:nil;
        self.descLabel.text = [_designer realNameAuthDescription];
        
        CGRect frame = _descLabel.frame;
        frame.size.height = [_descLabel.text heightWithFont:_descLabel.font constrainedToWidth:CGRectGetWidth(_descLabel.frame)];
        _descLabel.frame = frame;

        frame = _contentView.frame;
        frame.origin.y = CGRectGetMaxY(_descLabel.frame)+10;
        _contentView.frame = frame;
    }
}

- (void)uploadImage{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":_positiveIdImage} responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            NSString *imageUrl = [data objectForKey:@"imgUrl"];
            _designer.positiveIdPhoto = imageUrl;
            [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":_backIdImage} responseHandler:^(NSError *error, id data, NSDictionary *other) {
                if (!error) {
                    NSString *imageUrl = [data objectForKey:@"imgUrl"];
                    _designer.backIdphoto = imageUrl;
                    [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":_headImage} responseHandler:^(NSError *error, id data, NSDictionary *other) {
                        if (!error) {
                            NSString *imageUrl = [data objectForKey:@"imgUrl"];
                            _designer.handHeldIdPhoto = imageUrl;
                            [self submitRealNameAuth];
                        }else{
                            [self hideHUD];
                        }
                    }];
                }else{
                    [self hideHUD];
                }
            }];
        }else{
            [self hideHUD];
        }
    }];
}

- (void)submitRealNameAuth{
    NSDictionary *param1 = @{@"userName": _designer.userName,
                             @"idCardNum": _designer.idCardNum,
                             @"positiveIdPhoto": _designer.positiveIdPhoto,
                             @"positiveIdPhotoName": _designer.positiveIdPhoto,
                             @"backIdphoto": _designer.backIdphoto,
                             @"backIdphotoName": _designer.backIdphoto,
                             @"handHeldIdPhoto": _designer.handHeldIdPhoto,
                             @"headUrlName": _designer.handHeldIdPhoto
                             };
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_REALNAME_APPLY parameters:param1 HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameProfileReloadData object:nil];
                if (_designer.realNameAuthStatus == -1) {
                    [self showTip:@"申请成功"];
                }else if (_designer.realNameAuthStatus == 1){
                    [self showTip:@"重新申请成功"];
                }
            });
            [self loadData];
        }
    }];
}

- (void)onResubmit{
    _status = RealNameAuthStatusCommiting;
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UploadCardImageViewControllerDelegate

- (void)uploadCardImageWithImages:(NSArray *)images andType:(NSInteger)type{
    if (type == 0) {
        self.positiveIdImage = images[0];
        self.backIdImage = images[1];
    }else if(type == 1){
        self.headImage = images[0];
    }
    [_tableView reloadData];
}

#pragma mark - Target Action

- (void)onHidden{
    [self.selectedTextField resignFirstResponder];
}

- (void)onSubmit:(id)sender{
    if(_designer.userName.length == 0){
        [self showTip:@"请输入与身份证一致的名字"];
        return;
    }
    
    if(_designer.idCardNum.length == 0){
        [self showTip:@"请输入与真实名字一致的身份证号"];
        return;
    }
    
    if (!self.positiveIdImage || !self.backIdImage) {
        [self showTip:@"请选择证件图片"];
        return;
    }
    
    if (!self.headImage) {
        [self showTip:@"请选择手持证件照片"];
        return;
    }
    [self uploadImage];
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
        if (indexPath.row == 0) {
            cell.textField.text = _designer.userName;
        }else if (indexPath.row == 1) {
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.textField.text = _designer.idCardNum;
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
        if (indexPath.row == 2) {
            if (_positiveIdImage && _backIdImage) {
                cell.detailTextLabel.text = @"已添加";
            }
        }
        if (indexPath.row == 3) {
            if (_headImage) {
                cell.detailTextLabel.text = @"已添加";
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_selectedTextField resignFirstResponder];
    if (indexPath.row >= 2) {
        UploadCardImageViewController *vc = [[UploadCardImageViewController alloc] init];
        vc.delegate = self;
        vc.positiveIdImage = self.positiveIdImage;
        vc.headImage = self.headImage;
        vc.backIdImage = self.backIdImage;
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
        _designer.userName = textField.text;
    }else if (textField.tag == 11){
        _designer.idCardNum = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
