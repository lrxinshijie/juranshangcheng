//
//  GuideViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/18.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"
@interface GuideViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView1;
@property (nonatomic, strong) IBOutlet UIImageView *imageView2;
@property (nonatomic, strong) IBOutlet UIImageView *imageView3;
@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIPageControl *pageCtl;

- (IBAction)onStart:(id)sender;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.view.backgroundColor = kViewBackgroundColor;
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame)*3, CGRectGetHeight(_scrollView.frame));
    
    BOOL bol = kWindowHeight > 480;
    
    _imageView1.image = [UIImage imageNamed:bol ? @"guide_h_1" : @"guide_1"];
    _imageView2.image = [UIImage imageNamed:bol ? @"guide_h_2" : @"guide_2"];
    _imageView3.image = [UIImage imageNamed:bol ? @"guide_h_3" : @"guide_3"];
    
    
    CGRect frame = _imageView1.frame;
    frame.size.height = kWindowHeight;
    _imageView1.frame = frame;
    
    frame = _imageView2.frame;
    frame.size.height = kWindowHeight;
    _imageView2.frame = frame;
    
    frame = _imageView3.frame;
    frame.size.height = kWindowHeight;
    _imageView3.frame = frame;
    
    frame = _startButton.frame;
    frame.origin.y = kWindowHeight - 75;
    _startButton.frame = frame;
    
    _startButton.backgroundColor = [UIColor clearColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

+ (BOOL)showGuide{
//    return YES;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud objectForKey:@"showGuide"] || [ud boolForKey:@"showGuide"]) {
        return YES;
    }
    
    return NO;
}

- (IBAction)onStart:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:@"showGuide"];
    [ud synchronize];
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate jumpToMain];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/kWindowWidth;
    _pageCtl.currentPage = page;
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
