 //
//  ProfileViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ProfileViewController.h"
#import "PersonalDataViewController.h"
#import "JRUser.h"
#import "JRProfileData.h"
#import "MyFollowViewController.h"
#import "AccountManageViewController.h"
#import "AccountSecurityViewController.h"
#import "MyAskOrAnswerViewController.h"
#import "InteractionViewController.h"
#import "PushMessageViewController.h"
#import "CaseCollectViewController.h"
#import "SettingsViewController.h"
#import "OrderListViewController.h"

#ifdef kJuranDesigner
#import "RealNameAuthViewController.h"
#import "CaseManagementViewController.h"
#import "DesignerDetailViewController.h"
#import "JRDesigner.h"
#import "BidManagementViewController.h"
#import "PersonalDataForDesignerViewController.h"
#else
#import "PrivateMessageViewController.h"
#import "MyDemandViewController.h"

#endif

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titleArray;
    NSArray *imageArray;
}
@property (nonatomic, strong) IBOutlet UIView *buttonView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *loginNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *unLoginLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;
@property (nonatomic, strong) IBOutlet UIButton *signedButton;
@property (nonatomic, strong) IBOutlet UIView *hasNewBidView;
@property (nonatomic, strong) IBOutlet UIView *hasNewAnswerView;
@property (nonatomic, strong) IBOutlet UIView *hasNewPushMsgView;
@property (nonatomic, strong) IBOutlet UILabel *privateLetterCountLabel;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReloadDataNotification:) name:kNotificationNameProfileReloadData object:nil];
    
    _user = [JRUser currentUser];
    
#ifdef kJuranDesigner
//
    titleArray = @[ @"案例管理"
                    , @"个人主页"
                    , @"我的关注"
                    , @"我的收藏"
                    , @"订单管理"
                    , @"实名认证"
                    , @"账户安全"
                    , @"账户管理"
                    ];
//
    imageArray = @[@"icon_case_manage"
                    , @"icon_homepage.png"
                    , @"icon_personal_guanzhu.png"
                    , @"icon_personal_shouchang.png"
                    , @"icon_dingdan.png"
                    , @"icon_realname_auth.png"
                    , @"icon_personal_zhaq"
                    , @"icon_personal_zhgl"];
    self.navigationItem.title = @"个人中心";
#else
    titleArray = @[@"互动管理"
                    , @"我的关注"
                    , @"我的收藏"
                    , @"订单管理"
                    , @"账户安全"
                    , @"账户管理"];
    
    imageArray = @[ @"icon_personal_hudong.png"
                    , @"icon_personal_guanzhu.png"
                    , @"icon_personal_shouchang.png"
                    , @"icon_personal_ddgl.png"
                    , @"icon_personal_zhaq"
                    , @"icon_personal_zhgl"];
    [self configureMenu];
#endif
                   
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([JRUser isLogin]) {
        [self loadData];
    }else{
        [self refreshUI];
    }
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = _headerImageView.frame.size.width / 2.f;
    _headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerImageView.layer.borderWidth = 1.f;
    
    _privateLetterCountLabel.layer.masksToBounds = YES;
    _privateLetterCountLabel.layer.cornerRadius = _privateLetterCountLabel.frame.size.width / 2.f;
    
    _signedButton.layer.cornerRadius = 2.0f;
    _hasNewAnswerView.layer.cornerRadius = _hasNewAnswerView.frame.size.height/2.f;
    _hasNewBidView.layer.cornerRadius = _hasNewBidView.frame.size.height/2.f;
    _hasNewPushMsgView.layer.cornerRadius = _hasNewPushMsgView.frame.size.height/2.f;
    
#ifdef kJuranDesigner
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon_setting_white.png"] rightBarButtonItemAction:@selector(onSetting)];
    
    UILabel *label = (UILabel*)[_buttonView viewWithTag:1101];
    label.text = @"应标";
    
    UIImageView *imageView = (UIImageView*)[_buttonView viewWithTag:1102];
    imageView.image = [UIImage imageNamed:@"icon_personal_hudong.png"];
    label = (UILabel*)[_buttonView viewWithTag:1103];
    label.text = @"互动";
    
    imageView = (UIImageView*)[_headerView viewWithTag:2010];
    imageView.image = [UIImage imageNamed:@"personal_bg.png"];
#endif
}

- (void)refreshUI{
    if (![JRUser isLogin]) {
        _unLoginLabel.hidden = NO;
        _loginNameLabel.hidden = YES;
        _userNameLabel.hidden = YES;
        [_headerImageView setImage:[UIImage imageNamed:@"unlogin_head.png"]];
        _signedButton.enabled = YES;
        [_signedButton setTitle:@" 签到" forState:UIControlStateNormal];
    }else{
        _unLoginLabel.hidden = YES;
        _loginNameLabel.hidden = NO;
        _userNameLabel.hidden = NO;
        _userNameLabel.text = _user.showName;
        _loginNameLabel.text = [NSString stringWithFormat:@"用户名：%@", _user.account];
        [_headerImageView setImageWithURLString:_user.headUrl];
        
        _privateLetterCountLabel.text = [NSString stringWithFormat:@"%i", _user.newPrivateLetterCount];
        _signedButton.enabled = !_user.isSigned;
        [_signedButton setTitle:_user.isSigned?@" 已签":@" 签到" forState:UIControlStateNormal];
    }
#ifdef kJuranDesigner
    _privateLetterCountLabel.hidden = YES;
    _hasNewAnswerView.hidden = YES;
    _hasNewBidView.hidden = YES;
     _hasNewPushMsgView.hidden = [JRUser isLogin] && _user.newPushMsgCount?NO:YES;
#else
    _privateLetterCountLabel.hidden = [JRUser isLogin] && _user.newPrivateLetterCount?NO:YES;
    _hasNewAnswerView.hidden = [JRUser isLogin] && _user.newAnswerCount?NO:YES;
    _hasNewBidView.hidden = [JRUser isLogin] && _user.hasNewBidCount?NO:YES;
    _hasNewPushMsgView.hidden = [JRUser isLogin] && _user.newPushMsgCount?NO:YES;
#endif
}

- (void)loadData{
    if (![JRUser isLogin]) {
        _unLoginLabel.hidden = NO;
        _loginNameLabel.hidden = YES;
        _userNameLabel.hidden = YES;
        return;
    }
    BOOL showError = _user.nickName.length == 0;
    if (showError) {
        [self showHUD];
    }
#ifndef kJuranDesigner
    NSString *url = JR_MYCENTERINFO;
#else
    NSString *url = JR_GET_DESIGNER_CENTERINFO;
#endif
    [[ALEngine shareEngine] pathURL:url parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes", kNetworkParamKeyShowErrorDefaultMessage:@(showError)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                [_user buildUpProfileDataWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshUI];
                });
            }
        }
    }];
}

- (void)receiveReloadDataNotification:(NSNotification*)notification{
    [self loadData];
}


#pragma mark - Target Action

#ifdef kJuranDesigner

- (void)onSetting{
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#endif

- (IBAction)doSigned:(id)sender{
    if (![self checkLogin:^{
        [self loadData];
    }]) {
        return;
    }
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SIGNIN parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _user.isSigned = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                _signedButton.enabled = !_user.isSigned;
                [_signedButton setTitle:_user.isSigned?@" 已签":@" 签到" forState:UIControlStateNormal];
            });
        }
    }];
}

- (IBAction)doTouchHeaderView:(id)sender{
    if (![self checkLogin:^{
        [self loadData];
    }]) {
        return;
    }
#ifdef kJuranDesigner

    PersonalDataForDesignerViewController *vc = [[PersonalDataForDesignerViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
#else
    PersonalDataViewController *vc = [[PersonalDataViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
#endif
}


- (IBAction)doDemand:(id)sender{
    if (![self checkLogin:^{
        [self loadData];
    }]) {
        return;
    }
#ifndef kJuranDesigner
    //需求
    _user.hasNewBidCount = 0;
    MyDemandViewController *vc = [[MyDemandViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
#else
    BidManagementViewController *vc = [[BidManagementViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

//私信
- (IBAction)doPrivateLetter:(id)sender{
    if (![self checkLogin]) {
        return;
    }
#ifndef kJuranDesigner
//    _user.newPrivateLetterCount = 0;
    PrivateMessageViewController *pv = [[PrivateMessageViewController alloc] init];
    pv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pv animated:YES];
#else
    
    
//    互动隐藏
    InteractionViewController *vc = [[InteractionViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

//问答
- (IBAction)doAskOrAnswer:(id)sender{
    if (![self checkLogin:^{
        [self loadData];
    }]) {
        return;
    }
    _user.newAnswerCount = 0;
    MyAskOrAnswerViewController *vc = [[MyAskOrAnswerViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

//消息
- (IBAction)doPushMsg:(id)sender{
    if (![self checkLogin:^{
        [self loadData];
    }]) {
        return;
    }
//    _user.newPushMsgCount = 0;
    PushMessageViewController *vc = [[PushMessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 67;
    }
    /*
    //隐藏订单管理
#ifndef kJuranDesigner
    if (indexPath.row == 4){
        return 0;
    }
#else
    if (indexPath.row == 5){
        return 0;
    }
#endif*/
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_buttonView.superview) {
            [_buttonView removeFromSuperview];;
        }
        [cell.contentView addSubview:_buttonView];
    }else{
        static NSString *cellIdentifier = @"ProfileCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor colorWithRed:105/255.f green:105/255.f blue:105/255.f alpha:1.f];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:kSystemFontSize+3];
        }
        cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 8, 15) image:[UIImage imageNamed:@"cellIndicator.png"]];
        cell.textLabel.text = titleArray[indexPath.row - 1];
        cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.row - 1]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#ifndef kJuranDesigner
    if (![self checkLogin:^{
        [self loadData];
    }]) {
        return;
    }
    switch (indexPath.row) {
        case 1:
        {
            //互动
            InteractionViewController *vc = [[InteractionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            //        我的关注
            
            MyFollowViewController *vc = [[MyFollowViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            //        我的收藏
            CaseCollectViewController *vc = [[CaseCollectViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        
        case 4:{
            //        订单管理
            OrderListViewController *vc = [[OrderListViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:
        {
            //        账户安全
            AccountSecurityViewController *vc = [[AccountSecurityViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6:
        {
            //        账户管理
            AccountManageViewController *vc = [[AccountManageViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
#else
    if (![self checkLogin:^{
        [self loadData];
    }]) {
        return;
    }
    switch (indexPath.row) {
        case 1:
        {
            //案例管理
            CaseManagementViewController *vc = [[CaseManagementViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            //        个人主页
            DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
            detailVC.isHomePage = YES;
            JRDesigner *designer = [[JRDesigner alloc] init];
            designer.userId = _user.userId;
            detailVC.designer = designer;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 3:
        {
            //        我的关注
            MyFollowViewController *vc = [[MyFollowViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            //        我的收藏
            CaseCollectViewController *vc = [[CaseCollectViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:{
            //        订单管理
            OrderListViewController *vc = [[OrderListViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6:
        {
            //实名认证
            RealNameAuthViewController *vc = [[RealNameAuthViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 7:
        {
             //        账户安全
            AccountSecurityViewController *vc = [[AccountSecurityViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 8:
        {
            //        账户管理
            AccountManageViewController *vc = [[AccountManageViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
    
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
