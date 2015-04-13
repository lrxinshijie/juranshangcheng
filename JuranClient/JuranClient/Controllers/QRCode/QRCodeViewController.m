//
//  QRCodeViewController.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "QRCodeViewController.h"

#define IOS7               [[[UIDevice currentDevice] systemVersion]floatValue]>=7.0
#define ScreenWidth        self.view.bounds.size.width
#define ScreenHeight       self.view.bounds.size.height

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *scanLine;

@property (assign, nonatomic) BOOL isLightOn;

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



- (void)initUiConfig
{
    //初始化闪光灯状态为关闭
    self.isLightOn = NO;
    
    if (IOS7) {
        
        [self initUI:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        [self animation];
        
        
    }else{
        
        
        
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
    [self.output setRectOfInterest:CGRectMake(145/ScreenHeight, 80/ScreenWidth, 230/ScreenHeight, 160/ScreenWidth)];
    [self.view.layer insertSublayer:self.preview atIndex:0];
}
- (void)removeBackground
{
    [self.preview removeFromSuperlayer];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    [self.preview removeFromSuperlayer];
    
    //TODO:后期添加数据之后详细处理扫描完成之后的操作
    [self.session stopRunning];
    
    NSString *val = nil;
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        val = obj.stringValue;
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"OK" message:val delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        if ([self.delegate respondsToSelector:@selector(qrCodeComplete:)]) {
            [self.delegate qrCodeComplete:val];
        }
    }
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

#pragma mark - ios7以下版本调用二维码





#pragma mark - 闪光灯控制

- (IBAction)lightControlButtonDidClick:(id)sender {
    
    if (!_lightDevice) {
        _lightDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    if (![_lightDevice hasTorch]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前设备不支持闪光灯" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
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
