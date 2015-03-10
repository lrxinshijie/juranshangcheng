//
//  SerciceDetailViewController.m
//  JuranClient
//
//  Created by HuangKai on 14-12-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SerciceDetailViewController.h"

@interface SerciceDetailViewController ()

@property (nonatomic, strong) NSArray *descripes;

@end

@implementation SerciceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"服务详情";
    
    _descripes = @[@"先行赔付是指居然之家对市场内商家经营活动承担连带责任。当商家售商品出现质量或服务上的问题时，消费者可以携带销售合同和交款凭证到居然之家投诉，由居然之家先行向消费者赔付。",
                   @"《室内装饰装修材料中有害物质限量》（GB6566-2001）对内墙涂料、人造板及其制品、地毯及相关材料、胶粘剂、壁纸、溶剂型木器涂料、聚氯乙烯卷材、地板、木家具等有害物质的排放均有明确的规定，因叠加效应导致的空气质量超标，居然之家承诺家具180日内可以退换。",
                   @"商品验收后一个月内，在无任何损坏、不影响二次销售的情况下，可以随时换货退货。",
                   @"居然之家的所有商户都须按合同约定时间完成送货和安装任务，否则需承担违约责任，即：每延迟一天按已付货款的6‰向消费者支付违约金；超过15天，消费者有权终止合同，商户除返还消费者已付货款外，还须按已付货款的30%赔偿消费者违约金。",
                   @"为方便消费者使用各种结算方式交款，居然之家实行“统一收银”；同时，为避免消费者退换货时的往返波折，居然之家各店都设立了“统一退换货中心”方便消费者办理商品退换。",
                   @"消费者在签订合同后一周内，如发现所购商品（必须是同品牌、同规格、同材质）的正常交易价格（不包括促销期的价格、特价品和处理品的价格）高于同城其它零售卖场，并能提供有效销售合同和发票的，高出部分由居然之家双倍返还给消费者。",
                   @"为杜绝家装“钓鱼式工程”，乐屋在施工前增加 “预交底”环节确认工程量，未经消费者认可的工程增项以及虽经消费者认可但未超过装修费2%的增项，一律由乐屋承担。",
                   @"红木家具用材在国标规定的五属八类三十三个树种之内，正视面不使用边材，非正视面零部件使用边材不超过该零部件表面积的十分之一，否则假一赔二。",
                   @"“家之尊”国际家居馆所销售的进口家具为100%纯进口，品牌为国外注册，产品为国外生产，“原产地证明”、“装箱单”、“报关单”三证齐全，否则假一赔二。",
                   @"“明码实价”是指商家向消费者销售商品和提供服务时必须公开标示价格，并按标示价格与消费者进行结算，不接受任何讨价还价。“实价”是指根据成本、合理利润以及市场竞争状况计算出的“不注水”的价格。（目前仅限北京地区实行）",
                   @"所谓“三包”是指产品出现质量问题时的包修、包换、包退。居然之家已将家装“包修、包退、包换”期限由原来承诺的2年延长至3年；家具建材“包修、包退、包换”期限由原来承诺的1年延长至3年。",
                   @"以用户为中心，集设计、装修、商品交易、社交网络为一体，提供全方位的家装解决方案 ，便捷化个性化全渠道的产品和服务，实现“大家居”线上线下全渠道全价值链服务。"];
    
    [self setupUI];
}

- (void)setupUI{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 170)];
    imageView.image = [UIImage imageNamed:@"service_page.png"];
    [self.view addSubview:imageView];
    
    CGRect frame = CGRectMake(15, CGRectGetHeight(imageView.frame) + 15, 55, 55);
    imageView = [self.view imageViewWithFrame:frame image:[UIImage imageNamed:[NSString stringWithFormat:@"service_normal_%d", _index]]];
    [self.view addSubview:imageView];
    
    frame = CGRectMake(85, CGRectGetMinY(imageView.frame) + 10, 220, 25);
    UILabel *label = [self.view labelWithFrame:frame text:_titleForService textColor:RGBColor(92, 144, 204) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:17]];
    [self.view addSubview:label];
    
    frame = CGRectMake(15, CGRectGetMaxY(imageView.frame) + 15, kWindowWidth - 30, 0.5);
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = RGBColor(203, 203, 203);
    [self.view addSubview:line];
    
    frame.origin.y += 15;
    label = [self.view labelWithFrame:frame text:_descripes[_index] textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    frame = label.frame;
    frame.size.height = [label.text heightWithFont:label.font constrainedToWidth:CGRectGetWidth(label.frame)];
    label.frame = frame;
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
