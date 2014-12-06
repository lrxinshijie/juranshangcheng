//
//  JRPhotoScrollViewController.m
//  MyTest
//
//  Created by song.he on 14-11-26.
//  Copyright (c) 2014年 song.he. All rights reserved.
//

#import "JRPhotoScrollViewController.h"
#import "KTPhotoBrowserDataSource.h"
#import "KTPhotoBrowserGlobal.h"
#import "KTPhotoView.h"
#import "CaseDetailViewController.h"

@interface JRPhotoScrollViewController ()<KTPhotoBrowserDataSource>
{
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) IBOutlet UIView *toolBar;
@property (nonatomic, strong) IBOutlet UIImageView *favImageView;
@property (nonatomic, strong) UILabel *lastPageLabel;

@end

@implementation JRPhotoScrollViewController

- (id)initWithJRCase:(JRCase*)c andStartWithPhotoAtIndex:(NSUInteger)index{
    self = [self initWithDataSource:self andStartWithPhotoAtIndex:index];
    if (self) {
        self.jrCase = c;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImageWithColor:RGBAColor(0, 0, 0, .5f)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImageWithColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"case_icon_share_white.png"] rightBarButtonItemAction:@selector(doShare)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self.view buttonWithFrame:CGRectZero target:self action:@selector(back:) image:[UIImage imageNamed:@"nav_backbtn_white"]]];
    _favImageView.image = [UIImage imageNamed:_jrCase.isFav ? @"case_collect_selected" : @"case_icon_collect"];
}

- (void)setScrollViewContentSize{
    [super setScrollViewContentSize];
    if (!_lastPageLabel) {
        CGSize contentSize = scrollView_.contentSize;
        _lastPageLabel = [scrollView_ labelWithFrame:CGRectMake(contentSize.width-10, contentSize.height/2, 80, 20) text:@"最后一张" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:18]];
        [scrollView_ addSubview:_lastPageLabel];
    }
    CGPoint center = _lastPageLabel.center;
    center.y = scrollView_.bounds.size.height/2;
    _lastPageLabel.center = center;
}

- (void)setBottomView{
    [super setBottomView];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    bottomView_.backgroundColor = RGBAColor(0, 0, 0, .5f);
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, 70)];
    _titleView.backgroundColor = [UIColor clearColor];
    [bottomView_ addSubview:_titleView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 220, 50)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor whiteColor];
    [_titleView addSubview:_titleLabel];
    
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
    _toolBar.frame = toolbarFrame;
    [bottomView_ addSubview:_toolBar];
    
    CGRect bottomFrame = CGRectMake(0,
                                    screenFrame.size.height - _titleView.frame.size.height - toolbarFrame.size.height - _titleView.frame.size.height,
                                    screenFrame.size.width,
                                    bottomView_.frame.size.height + toolbarFrame.size.height + _titleView.frame.size.height);
    bottomView_.frame = bottomFrame;
    [self adjustBottomViewFrame];
}

- (void)doBarItem:(id)sender{
    
}

- (void)setCurrentIndex:(NSInteger)newIndex{
    [super setCurrentIndex:newIndex];
    [self setTitleAndIndex:newIndex];
}

- (void)setTitleAndIndex:(NSInteger)newIndex{
    _titleLabel.text = [dataSource_ titleAtIndex:newIndex];
    _indexLabel.text = [NSString stringWithFormat:@"%i/%i", newIndex+1,[dataSource_ numberOfPhotos]];
    [self adjustBottomViewFrame];
}

- (void)adjustBottomViewFrame{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGFloat height = [_titleLabel.text heightWithFont:_titleLabel.font constrainedToWidth:_titleLabel.frame.size.width];
    height = height == 0? 16: height;
    CGRect frame = _titleLabel.frame;
    frame.size.height = height;
    _titleLabel.frame = frame;
    
    frame = _titleView.frame;
    frame.size.height = CGRectGetMaxY(_titleLabel.frame) + 10;
    _titleView.frame = frame;
//    
//    CGPoint center = _indexLabel.center;
//    center.y = _titleView.center.y;
//    _indexLabel.center = center;
    
    frame = _toolBar.frame;
    frame.origin.y = CGRectGetMaxY(_titleView.frame);
    _toolBar.frame = frame;
    
    frame = bottomView_.frame;
    frame.size.height = CGRectGetMaxY(_toolBar.frame);
    frame.origin.y = screenFrame.size.height - frame.size.height;
    bottomView_.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Target Action

- (void)doShare{

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
    
    [_jrCase like:^(BOOL result) {
        if (result) {
            [self showTip:@"点赞成功"];
        }
    }];
}

- (IBAction)doCollect:(id)sender{
    if (![self checkLogin]) {
        return;
    }
    
    [_jrCase favorite:^(BOOL result) {
        if (result) {
            _favImageView.image = [UIImage imageNamed:_jrCase.isFav ? @"case_collect_selected" : @"case_icon_collect"];
        }
    }];
}

- (IBAction)doMakeAppointment:(id)sender{
    
}

- (IBAction)doPrivateLetter:(id)sender{
    
}

#pragma mark -
#pragma mark KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos {
    return _jrCase.detailImageList.count;
}



- (NSString*)titleAtIndex:(NSInteger)index{
    return _jrCase.desc;
}

- (void)imageAtIndex:(NSInteger)index photoView:(KTPhotoView *)photoView {
    NSString *imageStr = [_jrCase.detailImageList objectAtIndex:index];
    [photoView setImageWithURL:[Public imageURL:imageStr] placeholderImage:[UIImage imageNamed:@"sample-case-list.png"]];
}



@end
