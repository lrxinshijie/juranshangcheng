//
//  OrderConfirmPayViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/2/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderConfirmPayViewController.h"
#import "JROrder.h"

@interface OrderConfirmPayViewController ()

@property (nonatomic, strong) IBOutlet UILabel *orderLabel;
@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *payAmountLabel;

@property (nonatomic, strong) IBOutlet UIButton *aliButton;
@property (nonatomic, strong) IBOutlet UIButton *wxButton;

@property (nonatomic, assign) BOOL isPayAli;

- (IBAction)onSelectPay:(UIButton *)btn;

- (IBAction)onPay:(id)sender;

@end

@implementation OrderConfirmPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"支付订单";
    
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.cornerRadius = CGRectGetWidth(_avtarImageView.frame) / 2;
    
    _orderLabel.text = [NSString stringWithFormat:@"订单号：%@", _order.designTid];
    [_avtarImageView setImageWithURLString:_order.headUrl];
    _nameLabel.text = _order.decoratorName;
    
    _payAmountLabel.text = [NSString stringWithFormat:@"￥%@", _order.waitPayAmount];
    
    self.isPayAli = YES;
}

- (IBAction)onSelectPay:(UIButton *)btn{
    if ([btn isEqual:_aliButton] && !_isPayAli) {
        self.isPayAli = YES;
    }else if ([btn isEqual:_wxButton] && _isPayAli){
        self.isPayAli = NO;
    }
}

- (void)setIsPayAli:(BOOL)isPayAli{
    _isPayAli = isPayAli;
    UIImage *image = [UIImage imageNamed:@"image_quality_unselected.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"image_quality_selected.png"];
    
    [_aliButton setImage:_isPayAli ? selectedImage : image forState:UIControlStateNormal];
    [_wxButton setImage:_isPayAli ? image : selectedImage forState:UIControlStateNormal];
}

- (IBAction)onPay:(id)sender{
    
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
