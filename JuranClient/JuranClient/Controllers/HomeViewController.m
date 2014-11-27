//
//  HomeViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation HomeViewController

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
//
//    [self configureLeftBarButtonItemImage:[UIImage imageNamed:@"icon-case-empty"] leftBarButtonItemAction:nil];
        [self configureLeftBarButtonItemImage:[UIImage imageNamed:@"navbar_leftbtn_logo"] leftBarButtonItemAction:nil];
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-search"] rightBarButtonItemAction:@selector(onSearch)];
}

- (void)onSearch{

    
    [self setupView];
}

- (void)setupView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    view.backgroundColor = [UIColor yellowColor];
//    _tableView.tableHeaderView = view;
    _tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 22;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
