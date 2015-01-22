//
//  AccountManageViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AccountManageViewController.h"
#import "JRDesigner.h"

@interface AccountManageViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *keys;
    NSArray *values;
}
@property (nonatomic, strong) UITableView *tableView;

#ifdef kJuranDesigner
@property (nonatomic, strong) JRDesigner *user;
#else
@property (nonatomic, strong) JRUser *user;
#endif

@end

@implementation AccountManageViewController

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
    
    self.navigationItem.title = @"账户管理";
    
#ifndef kJuranDesigner
    _user = [JRUser currentUser];
#else
    _user = [[JRDesigner alloc] init];
#endif
    
    keys = @[ @"积分", @"经验值"];//@"账户余额",
    values = @[@"", @""];//@"￥0.00",
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:_tableView];
    
    [self loadData];
}

- (void)reloadData{
    values = @[[NSString stringWithFormat:@"%d", _user.useablePoints], [NSString stringWithFormat:@"%d", _user.useableExp]];
    [_tableView reloadData];
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
        cell.detailTextLabel.textColor = RGBColor(69, 118, 187);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.textLabel.text = keys[indexPath.row];
    cell.detailTextLabel.text = values[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
