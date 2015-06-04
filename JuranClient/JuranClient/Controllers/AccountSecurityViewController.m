//
//  AccountSecurityViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AccountSecurityViewController.h"
#import "JRMemberDetail.h"
#import "ModifyPasswordViewController.h"
#import "BindPhoneNumberViewController.h"
#import "BindMailViewController.h"

#ifdef kJuranDesigner
#import "JRDesigner.h"
#endif


@interface AccountSecurityViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *keys;
    NSArray *values;
    NSString *mail;
    NSString *phone;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AccountSecurityViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReloadDataNotification:) name:kNotificationNameProfileReloadData object:nil];
    self.navigationItem.title = @"账户安全";
    [self configureMore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMoreMenu) name:kNotificationNameMsgCenterReloadData object:nil];
    keys = @[@"修改密码", @"手机号码", @"邮箱"];
#ifndef kJuranDesigner
    _user = [JRUser currentUser];
#else
    _user = [[JRDesigner alloc] init];
#endif
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:_tableView];
    
    [self loadData];
}

- (void)receiveReloadDataNotification:(NSNotification*)notification{
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData{
    values = @[@"",
               [_user mobileNumForBindPhone],
               [_user emailForBindEmail]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

#ifndef kJuranDesigner
- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GETMEMBERDETAIL parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                [_user buildUpMemberDetailWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            }
        }
    }];
}
#else
- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_DEDESIGNER_SELFDETAIL parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                [_user buildUpWithValueForPersonal:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            }
        }
    }];
}
#endif

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return keys.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"AccountManage";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = RGBColor(108, 108, 108);
//        cell.detailTextLabel.textColor = RGBColor(69, 118, 187);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 8, 15) image:[UIImage imageNamed:@"cellIndicator.png"]];
    cell.textLabel.text = keys[indexPath.row];
    cell.detailTextLabel.text = values[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ModifyPasswordViewController *vc = [[ModifyPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1) {
        BindPhoneNumberViewController *vc = [[BindPhoneNumberViewController alloc] init];
        vc.user = _user;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        BindMailViewController *vc = [[BindMailViewController alloc] init];
        vc.user = _user;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
