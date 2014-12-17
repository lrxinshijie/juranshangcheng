//
//  PersonalDataViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-27.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "PersonalDatasMoreViewController.h"
#import "SexySwitch.h"
#import "ModifyViewController.h"
#import "BaseAddressViewController.h"
#import "DetailAddressViewController.h"
#import "JRAreaInfo.h"
#import "ALGetPhoto.h"
#import "ActionSheetDatePicker.h"

@interface PersonalDataViewController ()<UITableViewDataSource, UITableViewDelegate, SexySwitchDelegate, ModifyViewControllerDelegate>
{
    NSArray *valuesForSection1;
    NSArray *keysForSection1;
    NSArray *valuesForSection2;
    NSArray *keysForSection2;
    NSArray *valuesForSection3;
    NSArray *keysForSection3;
    NSDictionary *param;
    NSArray *typesForSection3;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SexySwitch *sexySwitch;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation PersonalDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"个人资料";
    
    [self setupDatas];
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    _sexySwitch = [[SexySwitch alloc] init];
    _sexySwitch.selectedIndex = 1;
    _sexySwitch.delegate = self;
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_user) {
        [self reSetData];
        [_tableView reloadData];
    }
}

- (void)setupDatas{
    keysForSection1 = @[@"头像", @"用户名"];
    keysForSection2 = @[@"昵称", @"性别", @"生日", @"所在地", @"详细地址"];
    keysForSection3 = @[@"固定电话", @"证件信息", @"QQ", @"微信"];
    
    typesForSection3 = @[@(ModifyCVTypeHomeTel), @(ModifyCVTypeIdType),@(ModifyCVTypeQQ),@(ModifyCVTypeWeiXin)];
    /*
     *   设计师端个人资料
     *
     keysForSection1 = @[@"头像", @"用户名"];
     keysForSection2 = @[@"昵称", @"性别", @"生日", @"所在地"];
     keysForSection3 = @[@"从业经验", @"设计费用", @"量房费用", @"擅长风格", @"设计专长", @"毕业院校", @"自我介绍是老骥伏枥开离开就是离开对方极乐世界进口飞机来上课"];
     valuesForSection1 = @[@"头像", @"用户名"];
     valuesForSection1 = @[@"昵称", @"性别", @"生日", @"所在地"];
     valuesForSection1 = @[@"从业经验", @"设计费用", @"量房费用", @"擅长风格", @"设计专长", @"毕业院校", @"自我介绍"];
     */
    
}

- (void)reSetData{
    if (_user.headUrl && _user.headUrl.length>0) {
        [self.iconImageView setImageWithURLString:_user.headUrl];
    }
    valuesForSection1 = @[@"", _user.account];
    valuesForSection2 = @[_user.nickName,
                          @"性别",
                          _user.birthday.length == 0?@"未设置":_user.birthday,
                          [_user locationAddress],
                          _user.detailAddress.length == 0?@"未设置":_user.detailAddress];
    valuesForSection3 = @[[_user homeTelForPersonal], [_user idCardInfomation], _user.qq.length == 0?@"未设置":_user.qq, _user.weixin.length == 0?@"未设置":_user.weixin];
}

- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GETMEMBERDETAIL parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _user = [JRUser currentUser];
                [_user buildUpMemberDetailWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reSetData];
                    [_tableView reloadData];
                });
            }
        }
    }];
}

- (void)modifyMemberDetail{
    /*
    NSDictionary *param11 = @{@"nickName": _user.nickName,
                            @"birthday": _user.birthday,
                            @"homeTel": _user.homeTel,
                            @"provinceCode": _user.areaInfo.provinceCode,
                            @"cityCode": _user.areaInfo.cityCode,
                            @"districtCode": _user.areaInfo.districtCode,
                            @"detailAddress": _user.detailAddress,
                            @"zipCode": _user.zipCode,
                            @"idCardType": _user.idCardType,
                            @"idCardNum": _user.idCardNumber,
                            @"qq": _user.qq,
                            @"weixin": _user.weixin,
                            @"account": _user.account,
                            @"sex": @"1"
                        };
    */
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_EDIT_MEMBERINFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
//        [self hideHUD];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadData];
            });
        }
    }];
}

- (void)uploadHeaderImage:(UIImage*)image{
    [[ALEngine shareEngine] pathURL:JR_UPLOAD_HEAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"headpic":image} responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            [self loadData];
        }
    }];
}

#pragma mark - ModifyViewControllerDelegate

- (void)modifyCommit:(ModifyViewController *)vc{
    [self reSetData];
    [_tableView reloadData];
}

#pragma mark - SexySwitchDelegate

- (void)sexySwitch:(SexySwitch *)sexySwitch valueChange:(NSInteger)index{
    param = @{@"sex": [NSString stringWithFormat:@"%d", index]};
    [self modifyMemberDetail];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return keysForSection1.count;
    }else if (section == 1){
        return keysForSection2.count;
    }else if (section == 2){
        return keysForSection3.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 9;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     *  设计师端
     if (indexPath.section == 0 && indexPath.row == 0) {
     return 65;
     }else if (indexPath.section == 2 && indexPath.row == 6){
     return 70;
     }
     */
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"personalData";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize+2];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
    }
    cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 8, 15) image:[UIImage imageNamed:@"cellIndicator.png"]];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = keysForSection1[indexPath.row];
            CGRect frame = CGRectMake(0, 0, 100, 50);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            frame.origin = CGPointMake(frame.size.width - 8, (frame.size.height - 16)/2);
            frame.size = CGSizeMake(8, 15);
            UIImageView *arrowImageView = [cell imageViewWithFrame:frame image:[UIImage imageNamed:@"cellIndicator.png"]];
            [view addSubview:arrowImageView];
            
            if (self.iconImageView.superview) {
                [self.iconImageView removeFromSuperview];
            }
            frame = self.iconImageView.frame;
            frame.origin = CGPointMake(view.frame.size.width - arrowImageView.frame.size.width - 10 -50, 0);
            self.iconImageView.frame = frame;
            [view addSubview:self.iconImageView];
//            [self.iconImageView setImageWithURLString:_user.headUrl];
            cell.accessoryView = view;
            
        }else{
            cell.textLabel.text = keysForSection1[indexPath.row];
            cell.detailTextLabel.text = valuesForSection1[indexPath.row];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            cell.textLabel.text = keysForSection2[indexPath.row];
            cell.detailTextLabel.text = @"";
            _sexySwitch.selectedIndex = _user.sex;
            cell.accessoryView = _sexySwitch;
        }else{
            cell.textLabel.text = keysForSection2[indexPath.row];
            cell.detailTextLabel.text = valuesForSection2[indexPath.row];
        }
    }else if (indexPath.section == 2){
        /*
         *设计师端内容
         if (indexPath.row == keysForSection3.count - 1) {
         cell.textLabel.text = valuesForSection3[indexPath.row];
         cell.detailTextLabel.text = @"";
         CGRect frame = CGRectMake(0, 0, 210, 53);
         UIView *view = [[UIView alloc] initWithFrame:frame];
         frame.origin = CGPointMake(frame.size.width - 8, (frame.size.height - 16)/2);
         frame.size = CGSizeMake(8, 16);
         UIImageView *arrowImageView = [cell imageViewWithFrame:frame image:[UIImage imageNamed:@"cellIndicator.png"]];
         [view addSubview:arrowImageView];
         
         frame.origin = CGPointMake(view.frame.size.width - frame.size.width - 10 -190, 0);
         frame.size = CGSizeMake(190, 53);
         
         UILabel *label = [cell labelWithFrame:frame text:valuesForSection3[indexPath.row] textColor:cell.detailTextLabel.textColor textAlignment:NSTextAlignmentCenter font:cell.detailTextLabel.font];
         label.numberOfLines = 3;
         [view addSubview:label];
         
         cell.accessoryView = view;
         
         }else{
         cell.textLabel.text = keysForSection3[indexPath.row];
         cell.detailTextLabel.text = valuesForSection3[indexPath.row];
         }
         */
        cell.textLabel.text = keysForSection3[indexPath.row];
        cell.detailTextLabel.text = valuesForSection3[indexPath.row];
    }else{
        cell.textLabel.text = @"更多资料";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
     *设计师端
     if (indexPath.section == 3) {
     PersonalDatasMoreViewController *vc = [[PersonalDatasMoreViewController alloc] init];
     [self.navigationController pushViewController:vc animated:YES];
     }
     */
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:YES MaxNumber:1 Handler:^(NSArray *images) {
                if (images.count > 0) {
                    [self uploadHeaderImage:images[0]];
                }
            }];
        }else if (indexPath.row == 1) {
            ModifyViewController *vc = [[ModifyViewController alloc] initWithMemberDetail:_user type:ModifyCVTypeUserName];
            vc.title = keysForSection1[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                ModifyViewController *vc = [[ModifyViewController alloc] initWithMemberDetail:_user type:ModifyCVTypeNickName];
                vc.title = keysForSection2[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:
            {
                [ActionSheetDatePicker showPickerWithTitle:@"生日" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                    _user.birthday = [(NSDate*)selectedDate stringWithFormat:[NSDate dateFormatString]];
                    NSString *dateString = [(NSDate*)selectedDate stringWithFormat:[NSDate timestampFormatString]];
                    param = @{@"birthday": dateString};
                    [self modifyMemberDetail];
                } cancelBlock:^(ActionSheetDatePicker *picker) {
                    
                } origin:self.view];
                break;
            }
            case 3:
            {
                BaseAddressViewController *vc = [[BaseAddressViewController alloc] init];
                [vc setAreaInfo:_user.areaInfo andAddressSelected:^(id data) {
                    JRAreaInfo *areaInfo = (JRAreaInfo*)data;
                    param = @{@"areaInfo": @{@"provinceCode": areaInfo.provinceCode,
                                             @"cityCode": areaInfo.cityCode,
                                             @"districtCode": areaInfo.districtCode
                                             }};
                    [self modifyMemberDetail];
                }];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 4:
            {
                DetailAddressViewController *vc = [[DetailAddressViewController alloc] init];
                vc.user = _user;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }else if (indexPath.section == 2){
        ModifyViewController *vc = [[ModifyViewController alloc] initWithMemberDetail:_user type:[typesForSection3[indexPath.row] integerValue]];
        vc.title = keysForSection3[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView*)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [self.view imageViewWithFrame:CGRectMake(0, 0, 50, 50) image:[UIImage imageNamed:@"unlogin_head.png"]];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = _iconImageView.frame.size.height/2;
    }
    return _iconImageView;
}

@end
