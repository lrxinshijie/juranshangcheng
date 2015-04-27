//
//  TestSearchViewController.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "TestSearchViewController.h"
#import "CustomSearchBar.h"
#import "QRBaseViewController.h"
#import "DesignerViewController.h"
#import "CaseViewController.h"
#import "QuestionViewController.h"
#import "ShopListViewController.h"

@interface TestSearchViewController ()<CustomSearchBarDelegate>
@property (strong, nonatomic) CustomSearchBar *searchBar;

@end

@implementation TestSearchViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)initUI
{
    self.searchBar = [[[NSBundle mainBundle] loadNibNamed:@"CustomSearchBar" owner:self options:nil] lastObject];
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    [self.view addSubview:self.searchBar];
    [self.searchBar rightButtonChangeStyleWithKey:RightBtnStyle_Scan];
    self.searchBar.delegate = self;
}

- (void)pushToQRCodeVCDidTriggered
{
    QRBaseViewController * QRVC = [[QRBaseViewController alloc] initWithNibName:@"QRBaseViewController" bundle:nil isPopNavHide:YES];
    [self.navigationController pushViewController:QRVC animated:YES];
}

- (void)goBackButtonDidSelect
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startSearchWithKeyWord:(NSString *)keyWord index:(int)index
{
    if (index == 0) {
        //作品案例
        CaseViewController *vc = [[CaseViewController alloc] init];
        vc.searchKey = keyWord;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (index == 1){
        //商品
        
    }else if (index == 2){
        //店铺
        ShopListViewController * vc = [[ShopListViewController alloc] init];
        vc.keyword = keyWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 3){
        //设计师
        DesignerViewController *vc = [[DesignerViewController alloc] init];
        vc.searchKeyWord = keyWord;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 4){
        //答疑
        QuestionViewController *vc = [[QuestionViewController alloc] init];
        vc.searchKeyWord = keyWord;
        vc.isSearchResult = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
