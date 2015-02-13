//
//  OrderPayViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/2/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderPayViewController.h"
#import "JROrder.h"
#import "OrderConfirmPayViewController.h"

@interface OrderPayViewController ()

@property (nonatomic, strong) IBOutlet UILabel *orderLabel;
@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *amountLabel;
@property (nonatomic, strong) IBOutlet UILabel *payAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel *waitPayAmountLabel;

- (IBAction)onNext:(id)sender;

@end

@implementation OrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"提交订单";
    
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.cornerRadius = CGRectGetWidth(_avtarImageView.frame) / 2;
    
    _orderLabel.text = [NSString stringWithFormat:@"订单号：%@", _order.designTid];
    [_avtarImageView setImageWithURLString:_order.headUrl];
    _nameLabel.text = _order.decoratorName;
    
    _amountLabel.text = [NSString stringWithFormat:@"￥%d", _order.amount];
    _payAmountLabel.text = [NSString stringWithFormat:@"￥%d", _order.payAmount];
    _waitPayAmountLabel.text = [NSString stringWithFormat:@"￥%d", _order.waitPayAmount];
}

- (IBAction)onNext:(id)sender{
    OrderConfirmPayViewController *ov = [[OrderConfirmPayViewController alloc] init];
    ov.order = _order;
    [self.navigationController pushViewController:ov animated:YES];
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
