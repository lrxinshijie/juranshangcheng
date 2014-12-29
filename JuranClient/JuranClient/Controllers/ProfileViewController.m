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
#import "MyDemandViewController.h"
#import "MyAskOrAnswerViewController.h"
#import "InteractionViewController.h"
#import "PushMessageViewController.h"
#import "CaseCollectViewController.h"
#import "PrivateMessageViewController.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titleArray;
    NSArray *imageArray;
}
@property (nonatomic, weak) IBOutlet UIView *buttonView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *loginNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *unLoginLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UIButton *signedButton;
@property (nonatomic, weak) IBOutlet UIView *hasNewBidView;
@property (nonatomic, weak) IBOutlet UIView *hasNewAnswerView;
@property (nonatomic, weak) IBOutlet UIView *hasNewPushMsgView;
@property (nonatomic, weak) IBOutlet UILabel *privateLetterCountLabel;

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
    
    [self configureMenu];
    
    _user = [JRUser currentUser];
    //@"互动",@"订单管理",  @"账户管理",
    titleArray = @[ @"我的关注", @"我的收藏", @"账户安全"];
    //@"icon_personal_hudong.png",, @"icon_personal_ddgl.png", @"icon_personal_zhgl.png"
    imageArray = @[ @"icon_personal_guanzhu.png", @"icon_personal_shouchang.png", @"icon_personal_zhaq"];
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshUI];
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
        _userNameLabel.text = _user.nickName.length?_user.nickName:_user.account;
        _loginNameLabel.text = [NSString stringWithFormat:@"用户名：%@", _user.account];
        [_headerImageView setImageWithURLString:_user.headUrl];
        
        _privateLetterCountLabel.text = [NSString stringWithFormat:@"%i", _user.newPushMsgCount];
        _signedButton.enabled = !_user.isSigned;
        [_signedButton setTitle:_user.isSigned?@" 已签":@" 签到" forState:UIControlStateNormal];
    }

    _privateLetterCountLabel.hidden = [JRUser isLogin] && _user.newPushMsgCount?NO:YES;
    _hasNewAnswerView.hidden = [JRUser isLogin] && _user.newAnswerCount?NO:YES;
    _hasNewBidView.hidden = [JRUser isLogin] && _user.hasNewBidCount?NO:YES;
    _hasNewPushMsgView.hidden = [JRUser isLogin] && _user.newPushMsgCount?NO:YES;
}

- (void)loadData{
    if (![JRUser isLogin]) {
        _unLoginLabel.hidden = NO;
        _loginNameLabel.hidden = YES;
        _userNameLabel.hidden = YES;
        return;
    }
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_MYCENTERINFO parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
        });
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
    PersonalDataViewController *vc = [[PersonalDataViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//需求
- (IBAction)doDemand:(id)sender{
    if (![self checkLogin:^{
        [self loadData];
    }]) {
        return;
    }
    _user.hasNewBidCount = 0;
    MyDemandViewController *vc = [[MyDemandViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//私信
- (IBAction)doPrivateLetter:(id)sender{
    if (![self checkLogin]) {
        return;
    }
    
    _user.newPrivateLetterCount = 0;
    PrivateMessageViewController *pv = [[PrivateMessageViewController alloc] init];
    pv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pv animated:YES];
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
    _user.newPushMsgCount = 0;
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
    if (indexPath.row == 1) {
        if (![self checkLogin:^{
            [self loadData];
        }]) {
            return;
        }
        MyFollowViewController *vc = [[MyFollowViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 15){
        if (![self checkLogin:^{
            [self loadData];
        }]) {
            return;
        }
        InteractionViewController *vc = [[InteractionViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 15){
        if (![self checkLogin:^{
            [self loadData];
        }]) {
            return;
        }
        AccountManageViewController *vc = [[AccountManageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        if (![self checkLogin:^{
            [self loadData];
        }]) {
            return;
        }
        AccountSecurityViewController *vc = [[AccountSecurityViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        if (![self checkLogin]) {
            return;
        }
        CaseCollectViewController *vc = [[CaseCollectViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
