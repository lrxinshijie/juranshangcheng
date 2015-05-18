//
//  JRServiceViewController.m
//  JuranClient
//
//  Created by HuangKai on 14-12-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRServiceViewController.h"
#import "SerciceDetailViewController.h"

#define kButtonTag 1100

@interface JRServiceViewController ()

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation JRServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"居然服务";
    [self setupData];
    [self setupUI];
    
}

- (void)setupData{
    _titles = @[@"先行赔付", @"绿色环保", @"一个月无理\n由退换货", @"送货安装\n零延迟", @"统一收银\n统一退换货", @"同一品牌\n同一价", @"家装零增项", @"红木全保真", @"进口家具\n百分百纯进口", @"明码实价", @"三包服务期\n延至三年", @"O2O线上线下一体化服务"];
}

- (void)setupUI{
    CGRect frame = _headView.frame;
    frame.origin = CGPointMake(0, 0);
    _headView.frame = frame;
    [self.view addSubview:_headView];
    
    frame.origin.y = CGRectGetMaxY(_headView.frame);
    frame.size = CGSizeMake(kWindowWidth, kWindowHeightWithoutNavigationBar - CGRectGetHeight(_headView.frame));
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self.view addSubview:_scrollView];
    
    CGFloat x = 0;
    CGFloat y = 0;
    for (NSInteger i = 0; i < _titles.count; i ++) {
        frame = CGRectMake(30 + x + 100 * (i%3), 10 + y + 95*(i/3), 60, 95);
        UIButton *btn = [self.view buttonWithFrame:frame target:self action:@selector(onDetail:) image:[UIImage imageNamed:[NSString stringWithFormat:@"service_highlighted_%d", i]]];
        btn.tag = i + kButtonTag;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"service_normal_%d", i]] forState:UIControlStateHighlighted];
        UIEdgeInsets edge = btn.imageEdgeInsets;
        edge.top = 5;
        edge.bottom = 21;
        btn.imageEdgeInsets = edge;
        
//        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        btn.titleLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
        btn.titleLabel.numberOfLines = 0;
        NSString *title = _titles[i];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:kBlueColor forState:UIControlStateHighlighted];
        edge = btn.titleEdgeInsets;
        edge.top = 66 + (title.length > 5?12:0);
        edge.left -= 65;
        edge.right -= 5;
        btn.titleEdgeInsets = edge;
        
        [_scrollView addSubview:btn];
        
//        frame.origin.y += 60;
//        UILabel *label = [self.view labelWithFrame:frame text:_titles[i] textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:kSmallSystemFontSize]];
//        label.numberOfLines = 0;
//        frame.size.height = [label.text heightWithFont:label.font constrainedToWidth:CGRectGetWidth(frame)];
//        label.frame = frame;
//        [_scrollView addSubview:label];
    }
    
    _scrollView.contentSize = CGSizeMake(kWindowWidth, CGRectGetMaxY(frame) + 20);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureMore];
}

- (IBAction)onDetail:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSInteger index = btn.tag - kButtonTag;
    SerciceDetailViewController *vc = [[SerciceDetailViewController alloc] init];
    vc.titleForService = _titles[index];
    vc.index = index;
    [self.navigationController pushViewController:vc animated:YES];
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
