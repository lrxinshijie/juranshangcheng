//
//  OrderCommentReadViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/2/12.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderCommentReadViewController.h"
#import "CommentStarView.h"
#import "JROrder.h"
#import "JRDesigner.h"
#import "DesignerDetailViewController.h"

@interface OrderCommentReadViewController ()

@property (nonatomic, strong) IBOutlet UIView *contentView;

@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;

@property (nonatomic, strong) IBOutlet CommentStarView *capacityPointView;
@property (nonatomic, strong) IBOutlet CommentStarView *servicePointView;
@property (nonatomic, strong) IBOutlet UILabel *capacityLabel;
@property (nonatomic, strong) IBOutlet UILabel *serviceLabel;

@property (nonatomic, strong) IBOutlet UILabel *orderNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *mobileNumLabel;
@property (nonatomic, strong) IBOutlet UIImageView *idImageView;
@property (nonatomic, strong) IBOutlet UIImageView *userLevelImageView;

@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation OrderCommentReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"设计师评价";
    
    [self setupUI];
    [self loadData];
}

- (void)setupUI{
    self.scrollView = [[UIScrollView alloc] initWithFrame:kContentFrameWithoutNavigationBar];
    [self.view addSubview:self.scrollView];
    _scrollView.backgroundColor = RGBColor(241, 241, 241);
    
    [_scrollView addSubview:_contentView];
    
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = CGRectGetHeight(_headerImageView.frame)/2.f;
    
    [_capacityPointView setEnable:NO];
    [_servicePointView setEnable:NO];
    
}

- (void)loadData{
    [self showHUD];
    NSDictionary *param = @{@"designTid": _order.type?_order.designTid:_order.measureTid
                            };
    [[ALEngine shareEngine]  pathURL:JR_VIEW_APPRAISED parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            [self hideHUD];
            [_order buildUpWithValueForComment:data];
            [self reloadData];
        }
    }];
}

- (void)reloadData{
    _orderNumberLabel.text = [NSString stringWithFormat:@"设计订单：%@", _order.designTid];
    [_headerImageView setImageWithURLString:_order.headUrl];
    _nameLabel.text = _order.decoratorName;
    _mobileNumLabel.text = _order.decoratorMobile;
    _timeLabel.text = _order.commentGmtCreate;
    
    CGRect frame = _nameLabel.frame;
    CGFloat width = [_nameLabel.text widthWithFont:_nameLabel.font constrainedToHeight:CGRectGetHeight(frame)];
    if (width > 136) {
        width = 136;
    }
    frame.size.width = width;
    _nameLabel.frame = frame;
    
    frame = _idImageView.frame;
    frame.origin.x = CGRectGetMaxX(_nameLabel.frame) + 10;
    _idImageView.frame = frame;
    _idImageView.hidden = !_order.isAuth;
    
    _userLevelImageView.image = [UIImage imageNamed:[JRDesigner userLevelImage:_order.levelCode]];
    frame = _userLevelImageView.frame;
    if (_idImageView.hidden) {
        frame.origin.x = CGRectGetMaxX(_nameLabel.frame) + 10;
    }else{
        frame.origin.x = CGRectGetMaxX(_idImageView.frame) + 10;
    }

    _userLevelImageView.frame = frame;
    
    [_capacityPointView setSelectedIndex:_order.capacityPoint];
    [_servicePointView setSelectedIndex:_order.servicePoint];
    self.capacityLabel.text = [NSString stringWithFormat:@"%d星", _order.capacityPoint];
    self.serviceLabel.text = [NSString stringWithFormat:@"%d星", _order.servicePoint];
    
    _contentLabel.text = _order.content;
    frame = _contentLabel.frame;
    frame.size.height = [_contentLabel.text heightWithFont:_contentLabel.font constrainedToWidth:CGRectGetWidth(_contentLabel.frame)];
    _contentLabel.frame = frame;
    
    frame = _timeLabel.frame;
    frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
    _timeLabel.frame = frame;
    
    frame = _contentView.frame;
    frame.size.height = CGRectGetMaxY(_timeLabel.frame) + 5;
    _contentView.frame = frame;
    
    _scrollView.contentSize = CGSizeMake(kWindowWidth, CGRectGetHeight(_contentView.frame));
}

- (IBAction)onDesignerView:(id)sender{
    DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
//    detailVC.designer = _datas[indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
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
