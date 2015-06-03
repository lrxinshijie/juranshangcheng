//
//  QRCodeViewController.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "QRCodeViewController.h"
#import "MobClick.h"

#define IOS7               [[[UIDevice currentDevice] systemVersion]floatValue]>=7.0
#define ScreenWidth        self.view.bounds.size.width
#define ScreenHeight       self.view.bounds.size.height

#define UM_QRScanEvent_Product @"SCANPRODUCT"
#define UM_QRScanEvent_Shop    @"SCANSHOP"
#define k_UM_Shop_Type         @"SHOPTYPE"

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *scanLine;

@end

@implementation QRCodeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUiConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self judgeCamera];
}

- (void)judgeCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        NSString * str;
        if (version >= 8.0) {
            str = @"您还没有打开相机权限,请前往“设置”->“居然之家”->“相机”打开相机权限";
        }else{
            str = @"您还没有打开相机权限,请前往“设置”->“隐私”->“相机”打开相机权限";
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 10000;
        [alert show];
    }
}


- (void)initUiConfig
{
    //初始化闪光灯状态为关闭
    self.isLightOn = NO;
    
    if (IOS7) {
        
        [self initUI:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        [self animation];
        
        
    }else{
        //iOS6暂不处理
        [self initUI:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        [self animation];
        
    }
    
    
}


#pragma mark - ios7以上调用系统方法进行二维码扫描

- (void)initUI:(CGRect)previewFrame
{
    if (!self.device) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    NSError *error = nil;
    if (!self.input) {
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    }
    
    if (error) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(qrCodeError:)]) {
            [self.delegate qrCodeError:error];
        }
        
        NSLog(@"当前设备不支持二维码扫描!");
        return;
    }
    
    if (!self.output) {
        self.output = [[AVCaptureMetadataOutput alloc] init];
    }
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if (!self.session) {
        self.session = [[AVCaptureSession alloc] init];
    }
    
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    
    if (!self.preview) {
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.preview.frame = previewFrame;
    
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    else
    {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    [self.session startRunning];
}

- (void)configBackground
{
    [self.output setRectOfInterest:CGRectMake(120/ScreenHeight, 55/ScreenWidth, 280/ScreenHeight, 210/ScreenWidth)];
    [self.view.layer insertSublayer:self.preview atIndex:0];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    [self.preview removeFromSuperlayer];
    [self.session stopRunning];
    
    NSString *val = nil;
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        val = obj.stringValue;
        
        
        NSLog(@"%d",[self needShowWithWebView:val]);
        NSLog(@"%@",val);
        
        //判断是不是连接
        if ([self isURL:val]) {
            
            ChildVCStyle vcStyle = ChildVCStyle_None;
            NSString * code;
            
            //是连接，判断是解析还是用webView展示
            if ([self needShowWithWebView:val] == 0) {
                //webView展示
                vcStyle = ChildVCStyle_Web;
                code = val;
                
            }else if ([self needShowWithWebView:val] == 1){
                //跳转至店铺首页
                vcStyle = ChildVCStyle_Shop;
                code = [self getNumberFrom:val];
                if (!code) {
                    code = [self getCodeFrom:val];
                }
                if ([self getStatisticsCodeFrom:val]) {
                    [MobClick event:UM_QRScanEvent_Shop attributes:@{k_UM_Shop_Type:[self getStatisticsCodeFrom:val]}];
                }
                
            }else if ([self needShowWithWebView:val] == 2){
                //跳转至商品详情页
                vcStyle = ChildVCStyle_Product;
                code = [self getNumberFrom:val];
                [MobClick event:UM_QRScanEvent_Product];
                
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(qrCodeComplete:childVCStyle:)]) {
                [self.delegate qrCodeComplete:code childVCStyle:vcStyle];
            }
            
        }else{
            //不是连接，直接展示
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Tips" message:val delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alertView.tag = 10001;
            [alertView show];
            
        }
    }
}

- (BOOL)isURL:(NSString *)str
{
    if ([str length] == 0) {
        return NO;
    }
    NSString *regex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

- (int)needShowWithWebView:(NSString *)str
{
    //正常环境下
    NSString * regex_product = @"^http://mall\.juran\.cn/product/([0-9]{1,})\.htm(.ozu_sid=ProductMobile)?$";
    NSString * regex_shop = @"^http://mall\.juran\.cn/shop/([0-9]{1,})\.htm(.ozu_sid=.+)?$";
    NSString * regex_shop1 = @"^http://[a-zA-Z\-\_]{1,}\.juran\.cn(/)?(.ozu_sid=.+)?$";
    
    //SIT环境
//    NSString * regex_product = @"^http://mall\.juran.o2o.sit\.com/rankings/([0-9]{1,})\.htm$";
//    NSString * regex_shop = @"^http://mall\.juran.o2o.sit\.com/product/([0-9]{1,})\.htm$";
    
    //UAT环境
//    NSString * regex_product = @"^http://mallo2ouat\.juranzhijia\.cn/shop/([0-9]{1,})\.htm$";
//    NSString * regex_shop = @"^http://mallo2ouat\.juranzhijia\.cn/product/([0-9]{1,})\.htm$";
    
    NSPredicate *pred_shop = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_shop];
    BOOL isMatch_shop = [pred_shop evaluateWithObject:str];
    
    NSPredicate *pred_shop1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_shop1];
    BOOL isMatch_shop1 = [pred_shop1 evaluateWithObject:str];
    
    if (isMatch_shop || isMatch_shop1) {
        //跳转至店铺首页
        return 1;
    }
    
    
    NSPredicate *pred_product = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_product];
    BOOL isMatch_product = [pred_product evaluateWithObject:str];
    if (isMatch_product) {
        //跳转至商品详情页
        return 2;
    }
    //使用webView展示
    return 0;
}

- (NSString *)getNumberFrom:(NSString *)str
{
    NSRange range = [str rangeOfString:@"[0-9]{1,}" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return [str substringWithRange:range];
    }
    return nil;
}

- (NSString *)getCodeFrom:(NSString *)str
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]{1,}" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray * arr = [regex matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
    if (arr.count >= 2) {
        NSTextCheckingResult * result = [arr objectAtIndex:1];
        return [str substringWithRange:result.range];
    }
    return nil;
}

- (NSString *)getStatisticsCodeFrom:(NSString *)str
{
    NSRange range = [str rangeOfString:@"ozu_sid=" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return [str substringFromIndex:range.length+range.location];
    }
    return nil;
}

- (void)animation
{
    __weak QRCodeViewController * wSelf = self;
    
    [UIView animateWithDuration:2.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        wSelf.scanLine.frame = CGRectMake(58, 360, 204, 10);
        
    } completion:^(BOOL finished) {
        
        wSelf.scanLine.frame = CGRectMake(58, 141, 204, 10);
        
        [wSelf performSelector:@selector(animation) withObject:nil];
        
    }];
    
}




#pragma mark - 闪光灯控制

- (IBAction)lightControlButtonDidClick:(id)sender {
    
    if (!_lightDevice) {
        _lightDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    if (![_lightDevice hasTorch]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前设备不支持闪光灯" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        alert.tag = 10002;
        [alert show];
        return;
    }
    
    if (self.isLightOn) {
        //闪光灯已打开，需要关闭
        [self turnOffLed];
    }else{
        //闪光灯未打开，需要打开
        [self turnOnLed];
    }
    
    self.isLightOn = !self.isLightOn;
    
}

//打开闪光灯
-(void) turnOnLed
{
    [_lightDevice lockForConfiguration:nil];
    [_lightDevice setTorchMode:AVCaptureTorchModeOn];
    [_lightDevice unlockForConfiguration];
}

//关闭闪光灯
-(void) turnOffLed
{
    [_lightDevice lockForConfiguration:nil];
    [_lightDevice setTorchMode: AVCaptureTorchModeOff];
    [_lightDevice unlockForConfiguration];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(qrCodeDismissTips)]) {
            [self.delegate qrCodeDismissTips];
        }
    }else if (alertView.tag == 10000 || alertView.tag == 10002) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(qrCodeOpenCameraWithError)]) {
            [self.delegate qrCodeOpenCameraWithError];
        }
    }
    
}



- (void)dealloc
{
    
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
