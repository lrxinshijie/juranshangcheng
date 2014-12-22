//
//  AboutViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-14.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic, strong) IBOutlet UIView *footerView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"关于";
    
    UILabel *label = [self.view labelWithFrame:CGRectMake(20, 10, 280, 20) text:@"居然在线简介" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:17]];
    [self.view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 1)];
    line.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:line];
    
    UITextView *textView = [self.view textViewWithFrame:CGRectMake(20, 55, 280, kWindowHeightWithoutNavigationBarAndTabbar - 60) backgroundColor:[UIColor clearColor] text:@"    居然在线（www.juran.cn）是北京居然之家投资控股集团（以下简称“居然之家”）投资创立的，采用线上线下融为一体的“O2O”+“全渠道”商业模式，构建同担共赢生态圈式的全价值链大家居服务平台。商城版于2013年11月11日上线，由北京居然之家投资控股集团有限公司的全资子公司北京居然之家电子商务有限公司全面运营管理。\n    居然之家成立于1999年，以中高端为经营定位，为顾客提供设计、装修、材料、家具、家居用品及饰品等“一站式”服务的大型家居建材主题购物中心。截止到2014年底，居然之家分店数量达到110家，营业面积达500万平米，年销售额超过350亿元，连续9年蝉联“北京市十大商业品牌”称号，在家居建材流通业处于行业领先地位。在未来3年内，居然之家分店数量将达到200家，5年内将开遍全国绝大部分地级城市，分店数量达到500家，年销售额超过1000亿元，成为中国家居建材流通业第一服务品牌和国际知名商业零售品牌。\n   居然在线依托居然之家的品牌影响力和资源优势，旨在构建以用户为中心，商品和设计资源为大数据重要基础，集设计、装修、商品交易、社交网络为一体，全业态、全渠道、全生命周期的线上线下一体化家居平台生态圈，最终引领用户的家居消费潮流，创造新的用户消费行为模式与用户服务模式。家居平台生态圈，是以线上线下一体化为基础，以设计为驱动，涵盖装修设计、施工、线上商城及线下实体购物体验中心。\n    居然在线，以设计驱动为价值导向，全面打通O2O，打造设计、DIY、装修、商城、社区等五大频道，通过设立合理的规则和激励机制，重构传统家居产业链，实现设计驱动模式下的多边共赢，为客户提供“大家居”全价值链服务。同时，强化社会化电商体系，借助一体化平台进行服务创新，进一步提升设计驱动与大数据分析能力，从简单交易走向以客户为中心的服务和社会化电商，全面打造设计驱动的运营模式，线上线下全渠道融合的“O2O”营运体系，最终实现“大家居”全业态、全渠道协同发展的家居平台生态圈。" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    textView.editable = NO;
    [self.view addSubview:textView];
    
    _footerView.frame = CGRectMake(0, kWindowHeightWithoutNavigationBarAndTabbar, CGRectGetWidth(_footerView.frame), CGRectGetHeight(_footerView.frame));
    [self.view addSubview:_footerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCall:(id)sender{
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",@"4006888888"]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨
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
