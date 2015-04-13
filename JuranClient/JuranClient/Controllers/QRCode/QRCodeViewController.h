//
//  QRCodeViewController.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
#import <AVFoundation/AVFoundation.h>

@protocol QRCodeViewControllerDelegate <NSObject>

//扫描成功时的回调
- (void)qrCodeComplete:(NSString *)codeString;
//扫描失败时的回调
- (void)qrCodeError:(NSError *)error;

@end

@interface QRCodeViewController : ALViewController

@property(assign,nonatomic)id<QRCodeViewControllerDelegate> delegate;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice * lightDevice;


- (void)configBackground;
- (void)removeBackground;

@end
