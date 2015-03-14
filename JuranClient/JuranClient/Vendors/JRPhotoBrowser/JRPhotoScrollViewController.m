//
//  JRPhotoScrollViewController.m
//  MyTest
//
//  Created by song.he on 14-11-26.
//  Copyright (c) 2014年 song.he. All rights reserved.
//

#import "JRPhotoScrollViewController.h"
#import "CaseDetailViewController.h"
#import "ShareView.h"
#import "SDWebImageManager.h"
#import "PrivateLetterViewController.h"
#import "MeasureViewController.h"
#import "JRDesigner.h"

@interface JRPhotoScrollViewController ()<UIActionSheetDelegate, MWPhotoBrowserDelegate>
{
}

@property (nonatomic, strong) UITextView *descTextView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) IBOutlet UIView *toolBar;
@property (nonatomic, strong) IBOutlet UIImageView *favImageView;
@property (nonatomic, strong) IBOutlet UIView *toolBarForDesigner;
@property (nonatomic, strong) IBOutlet UIImageView *favImageViewForDesigner;
@property (nonatomic, strong) UILabel *lastPageLabel;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation JRPhotoScrollViewController

- (id)initWithJRCase:(JRCase*)c andStartWithPhotoAtIndex:(NSUInteger)index{
    self = [self initWithDelegate:self];
    
    if (self) {
        self.jrCase = c;
        self.scrollNotHiddenControlEnable = YES;
        self.isNotAutoHiddenControl = YES;
        self.displayActionButton = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImageWithColor:RGBAColor(1, 1, 1, .5f)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
#ifndef kJuranDesigner
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [ALTheme sharedTheme].navigationTitleColor}];
#ifdef kJuranDesigner
    [self.navigationController.navigationBar setBackgroundImageWithColor:[UIColor blackColor]];
#else
    [self.navigationController.navigationBar setBackgroundImageWithColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self.view buttonWithFrame:CGRectZero target:self action:@selector(back:) image:[UIImage imageNamed:@"nav_backbtn_white"]]];    
    
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)]){
        [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]];
    }
#ifndef kJuranDesigner
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"case_icon_share_white.png"] rightBarButtonItemAction:@selector(doShare)];
#endif
    [self setBottomView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.f;
    [self.view addGestureRecognizer:longPress];
    [self loadData];
}

- (void)loadData{
    [self showHUD];
    NSDictionary *param = @{@"projectId": self.jrCase.projectId};
    [[ALEngine shareEngine] pathURL:JR_PRODETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if (_jrCase.nickName.length == 0) {
                self.jrCase = [[JRCase alloc] initWithDictionary:data];
            }
            
            [self.jrCase buildDetailWithDictionary:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                _descTextView.text = _jrCase.desc;
                [self adjustBottomViewFrame];
            });
            [self reloadData];
        }else{
            [super back:nil];
        }
    }];
}

- (void)reloadData{
    
#ifdef kJuranDesigner
    _favImageViewForDesigner.image = [UIImage imageNamed:_jrCase.isFav ? @"case_collect_selected" : @"case_icon_collect"];
#else
    
    _favImageView.image = [UIImage imageNamed:_jrCase.isFav ? @"case_collect_selected" : @"case_icon_collect"];
#endif
    [super reloadData];
}

- (UILabel*)lastPageLabel{
    if (!_lastPageLabel) {
        _lastPageLabel = [self.view labelWithFrame:CGRectMake(0, 0, 80, 20) text:@"最后一张" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:18]];
        [self.pagingScrollView addSubview:_lastPageLabel];
    }
    return _lastPageLabel;
}
/*
- (void)setScrollViewContentSize{
    [super setScrollViewContentSize];
    
    CGRect lastImageFrame = [self frameForPageAtIndex:[self numberOfPhotos] - 1];
    CGSize contentSize = scrollView_.contentSize;
    CGFloat y = lastImageFrame.origin.y + lastImageFrame.size.height/2;
    CGRect frame = CGRectMake(contentSize.width, y, 80, 20);
    self.lastPageLabel.frame = frame;
}
*/

- (void)setBottomView{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    self.bottomView.backgroundColor = RGBAColor(0, 0, 0, .5f);
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, 70)];
    _titleView.backgroundColor = [UIColor clearColor];
    [self.bottomView addSubview:_titleView];
    
    _descTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 270, 50)];
    _descTextView.editable = NO;
    _descTextView.backgroundColor = [UIColor clearColor];
    _descTextView.textAlignment = NSTextAlignmentLeft;
    _descTextView.font = [UIFont systemFontOfSize:16];
    _descTextView.textColor = [UIColor whiteColor];
    [_titleView addSubview:_descTextView];
    
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenFrame.size.width - 70, 10, 60, 20)];
    _indexLabel.numberOfLines = 1;
    _indexLabel.textAlignment = NSTextAlignmentRight;
    _indexLabel.font = [UIFont systemFontOfSize:14];
    _indexLabel.textColor = [UIColor whiteColor];
    [_titleView addSubview:_indexLabel];
    
    CGRect toolbarFrame = CGRectMake(0,
                                     _titleView.frame.size.height,
                                     screenFrame.size.width,
                                     49);
    
#ifdef kJuranDesigner
    _toolBarForDesigner.frame = toolbarFrame;
    [self.bottomView addSubview:_toolBarForDesigner];
    _favImageViewForDesigner.image = [UIImage imageNamed:_jrCase.isFav ? @"case_collect_selected" : @"case_icon_collect"];
#else
    _toolBar.frame = toolbarFrame;
    [self.bottomView addSubview:_toolBar];
    _favImageView.image = [UIImage imageNamed:_jrCase.isFav ? @"case_collect_selected" : @"case_icon_collect"];
#endif
    
    CGRect bottomFrame = CGRectMake(0,
                                    screenFrame.size.height - _titleView.frame.size.height - toolbarFrame.size.height - _titleView.frame.size.height,
                                    screenFrame.size.width,
                                    self.bottomView.frame.size.height + toolbarFrame.size.height + _titleView.frame.size.height);
    self.bottomView.frame = bottomFrame;
    [self adjustBottomViewFrame];
}

- (void)doBarItem:(id)sender{
    
}

- (void)handleLongPress:(UIGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSURL *url = [Public imageURL:[_jrCase.detailImageList objectAtIndex:self.currentIndex] Width:512];
        NSLog(@"%@",url);
        MWPhoto *photo = [self currentPhoto];
        if ([photo underlyingImage]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
            [actionSheet showInView:self.view];
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        MWPhoto *photo = [self currentPhoto];
        UIImageWriteToSavedPhotosAlbum([photo underlyingImage], self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [self showTip:@"图片保存成功"];
    }else{
        [self showTip:[NSString stringWithFormat:@"图片保存失败!%@", error.localizedFailureReason]];
    }
}

- (void)adjustBottomViewFrame{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGFloat height = [_descTextView.text heightWithFont:_descTextView.font constrainedToWidth:_descTextView.frame.size.width];
    if (height == 0) {
        height = 16;
    }else if (height > 65){
        height = 65;
    }else{
        height += 10;
    }
    
    CGRect frame = _descTextView.frame;
    frame.size.height = height;
    _descTextView.frame = frame;
    
    _indexLabel.center = CGPointMake(_indexLabel.center.x, _descTextView.center.y);
    
    frame = _titleView.frame;
    frame.size.height = CGRectGetMaxY(_descTextView.frame) + 10;
    _titleView.frame = frame;
    
#ifdef kJuranDesigner
    frame = _toolBarForDesigner.frame;
    frame.origin.y = CGRectGetMaxY(_titleView.frame);
    _toolBarForDesigner.frame = frame;
    
    frame = self.bottomView.frame;
    frame.size.height = CGRectGetMaxY(_toolBarForDesigner.frame);
    frame.origin.y = screenFrame.size.height - frame.size.height;
    self.bottomView.frame = frame;
#else
    frame = _toolBar.frame;
    frame.origin.y = CGRectGetMaxY(_titleView.frame);
    _toolBar.frame = frame;
    
    frame = self.bottomView.frame;
    frame.size.height = CGRectGetMaxY(_toolBar.frame);
    frame.origin.y = screenFrame.size.height - frame.size.height;
    self.bottomView.frame = frame;
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Target Action

- (void)doShare{
//    [[ShareView sharedView] showWithContent:[self titleAtIndex:currentIndex_] image:[Public imageURLString:_jrCase.detailImageList[currentIndex_]] title:_jrCase.title url:_jrCase.shareURL];
    [_jrCase doShare];
}

- (IBAction)doDetail:(id)sender{
    CaseDetailViewController *cd = [[CaseDetailViewController alloc] init];
    cd.jrCase = _jrCase;
    [self.navigationController pushViewController:cd animated:YES];
}

- (IBAction)doPraise:(id)sender{
    if (![self checkLogin]) {
        return;
    }
    
    [self showHUD];
    [_jrCase like:^(BOOL result) {
        [self hideHUD];
        if (result) {
            [self showTip:@"点赞成功"];
        }
    }];
}

- (IBAction)doCollect:(id)sender{
    if (![self checkLogin]) {
        return;
    }
    
    [self showHUD];
    [_jrCase favorite:^(BOOL result) {
        [self hideHUD];
        if (result) {
#ifdef kJuranDesigner
            _favImageViewForDesigner.image = [UIImage imageNamed:_jrCase.isFav ? @"case_collect_selected" : @"case_icon_collect"];
#else
            _favImageView.image = [UIImage imageNamed:_jrCase.isFav ? @"case_collect_selected" : @"case_icon_collect"];
#endif
            [self showTip:_jrCase.isFav?@"收藏成功":@"取消收藏成功"];
        }
    }];
}

- (IBAction)doMakeAppointment:(id)sender{
#ifdef kJuranDesigner
    [self doShare];
#else
    if (![self checkLogin]) {
        return;
    }
    
    if (!_jrCase.isAuth) {
        [self showTip:@"未认证的设计师无法预约量房"];
        return;
    }
    MeasureViewController *mv = [[MeasureViewController alloc] init];
    JRDesigner *designer = [[JRDesigner alloc] init];
    designer.userId = _jrCase.userId;
    designer.headUrl = _jrCase.headUrl;
    designer.nickName = _jrCase.nickName;
    mv.designer = designer;
    [self.navigationController pushViewController:mv animated:YES];
#endif
}

- (IBAction)doPrivateLetter:(id)sender{
    if (![self checkLogin]) {
        return;
    }
    /*
    PrivateLetterViewController *pv = [[PrivateLetterViewController alloc] init];
    JRDesigner *designer = [[JRDesigner alloc] init];
    designer.userId = _jrCase.userId;
    designer.headUrl = _jrCase.headUrl;
    designer.nickName = _jrCase.nickName;
    pv.designer = designer;
    [self.navigationController pushViewController:pv animated:YES];*/
    [[JRUser currentUser] postPrivateLetterWithUserId:_jrCase.userId VC:self];
}


#pragma mark - MWPhotoBrowserDelegate

- (NSString*)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    return nil;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _jrCase.detailImageList.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _jrCase.detailImageList.count){
        NSURL *url = [Public imageURL:[_jrCase.detailImageList objectAtIndex:index] Width:512];
        NSLog(@"%@",url);
        return [MWPhoto photoWithURL:url];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    _indexLabel.text = [NSString stringWithFormat:@"%i/%i", index+1,_jrCase.detailImageList.count];
    if (index == _jrCase.detailImageList.count - 1) {
        CGSize contentSize = self.pagingScrollView.contentSize;
        CGPoint center = CGPointMake(contentSize.width + CGRectGetWidth(self.lastPageLabel.frame)/2, self.pagingScrollView.center.y);
        self.lastPageLabel.center = center;
    }
}

@end
