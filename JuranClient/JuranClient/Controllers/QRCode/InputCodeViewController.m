//
//  InputCodeViewController.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "InputCodeViewController.h"

@interface InputCodeViewController ()<UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) QRCodeViewController * qrVC;

@end

@implementation InputCodeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil QRVC:(QRCodeViewController *)vc
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _qrVC = vc;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBackgroundLayer
{
    [self.qrVC.output setRectOfInterest:CGRectMake(0,0,0,0)];
    [self.view.layer insertSublayer:self.qrVC.preview atIndex:0];
}

- (void)removeBackgroundLayer
{
    [self.qrVC.preview removeFromSuperlayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputTextField resignFirstResponder];
}

- (IBAction)confirmButtonDidClick:(id)sender {
    
    [self.inputTextField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmButtonDidClick:)]) {
        [self.delegate confirmButtonDidClick:_inputTextField.text];
    }
    
}

- (void)dealloc
{
    
}

@end
