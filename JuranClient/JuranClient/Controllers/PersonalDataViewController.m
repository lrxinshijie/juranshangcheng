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
    if (_memberDetail) {
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
    valuesForSection1 = @[_memberDetail.headImageURL, _memberDetail.account];
    valuesForSection2 = @[_memberDetail.nickName,
                          @"性别",
                          _memberDetail.birthday.length == 0?@"未设置":_memberDetail.birthday,
                          [_memberDetail locationAddress],
                          _memberDetail.detailAddress.length == 0?@"未设置":_memberDetail.detailAddress];
    valuesForSection3 = @[[_memberDetail homeTelForPersonal], [_memberDetail idCardInfomation], _memberDetail.qq.length == 0?@"未设置":_memberDetail.qq, _memberDetail.weixin.length == 0?@"未设置":_memberDetail.weixin];
}

- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GETMEMBERDETAIL parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _memberDetail = [[JRMemberDetail alloc] initWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reSetData];
                    [_tableView reloadData];
                });
            }
        }
    }];
}

- (void)modifyMemberDetail{
    NSDictionary *param11 = @{@"nickName": _memberDetail.nickName,
                            @"birthday": _memberDetail.birthday,
                            @"homeTel": _memberDetail.homeTel,
                            @"provinceCode": _memberDetail.provinceCode,
                            @"cityCode": _memberDetail.cityCode,
                            @"districtCode": _memberDetail.districtCode,
                            @"detailAddress": _memberDetail.detailAddress,
                            @"zipCode": _memberDetail.zipCode,
                            @"idCardType": _memberDetail.idCardType,
                            @"idCardNum": _memberDetail.idCardNumber,
                            @"qq": _memberDetail.qq,
                            @"weixin": _memberDetail.weixin,
                            @"account": _memberDetail.account,
                            @"sex": @"1"
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_EDIT_MEMBERINFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _memberDetail = [[JRMemberDetail alloc] initWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reSetData];
                    [_tableView reloadData];
                });
            }
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
            
            frame.origin = CGPointMake(view.frame.size.width - frame.size.width - 10 -50, 0);
            frame.size = CGSizeMake(50, 50);
            
            UIImageView *iconImageView = [cell imageViewWithFrame:frame image:[UIImage imageNamed:@"unlogin_head.png"]];
            iconImageView.layer.masksToBounds = YES;
            iconImageView.layer.cornerRadius = iconImageView.frame.size.height/2;
            [view addSubview:iconImageView];
            [iconImageView setImageWithURLString:_memberDetail.headUrl];
            cell.accessoryView = view;
            
        }else{
            cell.textLabel.text = keysForSection1[indexPath.row];
            cell.detailTextLabel.text = valuesForSection1[indexPath.row];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            cell.textLabel.text = keysForSection2[indexPath.row];
            cell.detailTextLabel.text = @"";
            _sexySwitch.selectedIndex = _memberDetail.sex;
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
    if (indexPath.section == 0 && indexPath.row == 1) {
        ModifyViewController *vc = [[ModifyViewController alloc] initWithMemberDetail:_memberDetail type:ModifyCVTypeUserName];
        vc.title = keysForSection1[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                ModifyViewController *vc = [[ModifyViewController alloc] initWithMemberDetail:_memberDetail type:ModifyCVTypeNickName];
                vc.title = keysForSection2[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 3:
            {
                BaseAddressViewController *vc = [[BaseAddressViewController alloc] init];
                vc.memberDetail = _memberDetail;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 4:
            {
                DetailAddressViewController *vc = [[DetailAddressViewController alloc] init];
                vc.memberDetail = _memberDetail;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }else if (indexPath.section == 2){
        ModifyViewController *vc = [[ModifyViewController alloc] initWithMemberDetail:_memberDetail type:[typesForSection3[indexPath.row] integerValue]];
        vc.title = keysForSection3[indexPath.row];
        vc.keyboardType = UIKeyboardTypeNumberPad;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
