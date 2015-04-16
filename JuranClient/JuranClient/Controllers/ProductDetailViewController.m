//
//  ProductDetailViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "HMSegmentedControl.h"

@interface ProductDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *tipsView;
@property (nonatomic, strong) IBOutlet UIView *navigationView;

@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, strong) UITableView *detailTableView;

@property (nonatomic, strong) HMSegmentedControl *segCtl;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)*2);
    
    self.baseTableView = [self.scrollView tableViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame) - CGRectGetHeight(_tipsView.frame)) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [_scrollView addSubview:_baseTableView];
    [_scrollView addSubview:_tipsView];
    
    self.segCtl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"商品详情", @"商品参数", @"店铺推荐"]];
    _segCtl.frame = CGRectMake(0, CGRectGetHeight(_scrollView.frame) + CGRectGetHeight(_navigationView.frame), CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame) - CGRectGetHeight(_scrollView.frame) + CGRectGetHeight(_navigationView.frame));
    [_segCtl addTarget:self action:@selector(segCtlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_segCtl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : kBlueColor}];
        return attString;
    }];
    [_scrollView addSubview:_segCtl];
    
    
}

- (void)segCtlValueChanged:(HMSegmentedControl *)segCtl{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if ([tableView isEqual:_baseTableView]) {
        if (section == 0) {
            count = 3;
        }else if (section == 1){
            count = 2;
        }else{
            count = 1;
        }
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
    
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
