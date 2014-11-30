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

@interface JRPhotoScrollViewController ()<KTPhotoBrowserDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) IBOutlet UIView *toolBar;

@end

@implementation JRPhotoScrollViewController

- (id)initWithJRCase:(JRCase*)c andStartWithPhotoAtIndex:(NSUInteger)index{
    self = [self initWithDataSource:self andStartWithPhotoAtIndex:index];
    if (self) {
        
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
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImageWithColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"case_icon_share_white.png"] rightBarButtonItemAction:@selector(doShare)];
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
    _titleLabel.font = [UIFont systemFontOfSize:14];
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
    
}

- (IBAction)doPraise:(id)sender{
    
}

- (IBAction)doCollect:(id)sender{
    
}

- (IBAction)doMakeAppointment:(id)sender{
    
}

- (IBAction)doPrivateLetter:(id)sender{
    
}

#pragma mark -
#pragma mark KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos {
    return 0;
}

/*

- (NSString*)titleAtIndex:(NSInteger)index{
    NSDictionary *imageDic = [images_ objectAtIndex:index];
    NSString *title = imageDic[@"title"];
    return title;
}

- (NSInteger)numberOfPhotos {
    NSInteger count = [images_ count];
    return count;
}

- (void)imageAtIndex:(NSInteger)index photoView:(KTPhotoView *)photoView {
    NSDictionary *imageDic = [images_ objectAtIndex:index];
    NSString *url = imageDic[@"url"];
    [photoView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}

*/

@end
