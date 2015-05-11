//
//  QRBaseViewController.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "QRBaseViewController.h"
#import "InputCodeViewController.h"
#import "ProductDetailViewController.h"
#import "ShopHomeViewController.h"
#import "QRCodeWebViewController.h"
#import "JRShop.h"
#import "JRProduct.h"

@interface QRBaseViewController ()<QRCodeViewControllerDelegate,InputCodeViewControllerDelegate>

@property (strong, nonatomic) QRCodeViewController * qrCodeViewController;
@property (strong, nonatomic) InputCodeViewController * inputCodeViewController;
@property (strong, nonatomic) IBOutlet UIView *bottomBaseView;
@property (strong, nonatomic) IBOutlet UIButton *scanButton;
@property (strong, nonatomic) IBOutlet UIButton *inputCodeButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) UIButton * oldButton;

@property (nonatomic, strong) UIViewController * currentViewcontroller;
@property (nonatomic, strong) NSArray * vcArray;

@property (nonatomic, assign) BOOL isPopNavHide;

@end

@implementation QRBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isPopNavHide:(BOOL)hide
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.isPopNavHide = hide;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    return self;
}

- (void)dealloc
{
    self.qrCodeViewController = nil;
    
    self.qrCodeViewController.preview = nil;
    self.qrCodeViewController.output = nil;
    self.qrCodeViewController.device = nil;
    self.qrCodeViewController.input = nil;
    self.qrCodeViewController.session = nil;
    self.qrCodeViewController.lightDevice = nil;
    
    
    self.inputCodeViewController = nil;
    
    if (self.enableClick) {
        self.enableClick(YES);
        self.enableClick = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES];
    self.qrCodeViewController = nil;
    [self initChildViewController];
    
    //需求：去除条形码输入，此处为调整，其他还有注释有“需求调整”的部分与此为同一调整。
    self.bottomBaseView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    //底部选择框被隐藏
//    [self initSelectButtonStyle];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:self.isPopNavHide];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [super viewWillDisappear:animated];
}

- (void)initSelectButtonStyle
{
    [self.scanButton setTitleColor:[UIColor colorWithRed:12.0/255.0 green:80.0/255.0 blue:163.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.scanButton setImage:[UIImage imageNamed:@"scanIcon_highlight"] forState:UIControlStateNormal];
    
    [self.inputCodeButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.inputCodeButton setImage:[UIImage imageNamed:@"inputIcon_normal"] forState:UIControlStateNormal];
    
    self.oldButton = self.scanButton;
}

- (void)initChildViewController
{
    [self initQRCodeViewController];
    //需求调整
//    [self initInputCodeViewController];
    //需求调整
    self.vcArray = @[self.qrCodeViewController/*,self.inputCodeViewController*/];
}

- (void)initQRCodeViewController
{
    if (!self.qrCodeViewController) {
        self.qrCodeViewController = [[QRCodeViewController alloc] initWithNibName:@"QRCodeViewController" bundle:nil];
    }
    self.qrCodeViewController.delegate = self;
    [self addChildViewController:self.qrCodeViewController];
    [self.view insertSubview:self.qrCodeViewController.view belowSubview:self.bottomBaseView];
    [self.view bringSubviewToFront:self.backButton];
    [self.qrCodeViewController configBackground];
    self.currentViewcontroller = self.qrCodeViewController;
}

- (void)initInputCodeViewController
{
    self.inputCodeViewController = [[InputCodeViewController alloc] initWithNibName:@"InputCodeViewController" bundle:nil QRVC:self.qrCodeViewController];
    self.inputCodeViewController.delegate = self;
    [self addChildViewController:self.inputCodeViewController];
    [self.view insertSubview:self.inputCodeViewController.view belowSubview:self.qrCodeViewController.view];
    [self.view bringSubviewToFront:self.backButton];
}

- (void)customeChangeSelectItemAtTabbar:(NSInteger)index
{
    
    __weak QRBaseViewController * wSelf = self;
    
    [self transitionFromViewController:self.currentViewcontroller toViewController:[self.vcArray objectAtIndex:index] duration:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
        
        if (index == 0) {
            
            if (wSelf.qrCodeViewController.isLightOn) {
                [wSelf.qrCodeViewController turnOnLed];
            }
            [wSelf.inputCodeViewController removeBackgroundLayer];
            [wSelf.qrCodeViewController configBackground];
            
        }else{
            
            [wSelf.qrCodeViewController turnOffLed];
            [wSelf.qrCodeViewController removeBackground];
            [wSelf.inputCodeViewController configBackgroundLayer];
            
        }
        
    }];
    [self.view insertSubview:[[self.vcArray objectAtIndex:index] view] atIndex:0];
    self.currentViewcontroller = [self.vcArray objectAtIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackButtonDidClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)selectCodeInputModel:(id)sender {
    
    //1998是扫码 ， 1999是输入条码
    
    UIButton * button = (UIButton *)sender;
    
    if (self.oldButton == button) {
        return;
    }
    
    self.oldButton = button;
    
    if (button.tag == 1998) {
        
        [self.scanButton setTitleColor:[UIColor colorWithRed:12.0/255.0 green:80.0/255.0 blue:163.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.scanButton setImage:[UIImage imageNamed:@"scanIcon_highlight"] forState:UIControlStateNormal];
        
        [self.inputCodeButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.inputCodeButton setImage:[UIImage imageNamed:@"inputIcon_normal"] forState:UIControlStateNormal];
        
    }else{
        
        [self.scanButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.scanButton setImage:[UIImage imageNamed:@"scanIcon_normal"] forState:UIControlStateNormal];
        
        [self.inputCodeButton setTitleColor:[UIColor colorWithRed:12.0/255.0 green:80.0/255.0 blue:163.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.inputCodeButton setImage:[UIImage imageNamed:@"inputIcon_highlight"] forState:UIControlStateNormal];
        
    }
    
    [self customeChangeSelectItemAtTabbar:(button.tag-1998)];
    
}



#pragma mark - QRCodeViewControllerDelegate

- (void)qrCodeComplete:(NSString *)codeString childVCStyle:(ChildVCStyle)style
{
    if (style == ChildVCStyle_Web) {
        
        QRCodeWebViewController * qrVC = [[QRCodeWebViewController alloc] init];
        qrVC.requestURL = codeString;
        
        [self.navigationController setNavigationBarHidden:self.isPopNavHide];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        [self.navigationController pushViewController:qrVC animated:YES];
        
    }else if (style == ChildVCStyle_Shop){
        
        ShopHomeViewController * shopVC = [[ShopHomeViewController alloc] init];
        JRShop * jrShop = [[JRShop alloc] init];
        jrShop.shopId = [codeString integerValue];
        shopVC.shop = jrShop;
        
        [self.navigationController setNavigationBarHidden:self.isPopNavHide];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        [self.navigationController pushViewController:shopVC animated:YES];
        
    }else if (style == ChildVCStyle_Product){
        
        ProductDetailViewController * pVC = [[ProductDetailViewController alloc] init];
        JRProduct * jrProduct = [[JRProduct alloc] init];
        jrProduct.linkProductId = [codeString integerValue];
        pVC.product = jrProduct;
        
        [self.navigationController setNavigationBarHidden:self.isPopNavHide];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        [self.navigationController pushViewController:pVC animated:YES];
    }
}

- (void)qrCodeError:(NSError *)error
{
    
}

- (void)qrCodeDismissTips
{
    self.qrCodeViewController = nil;
    [self initChildViewController];
}

#pragma mark - InputCodeViewControllerDelegate

-(void)confirmButtonDidClick:(NSString *)message
{
    
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
