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

@interface JRPhotoScrollViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation JRPhotoScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
}

- (void)setBottomView{
    [super setBottomView];
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, 70)];
    titleView.backgroundColor = [UIColor brownColor];
    [bottomView_ addSubview:titleView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 220, 50)];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:_titleLabel];
    
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenFrame.size.width - 70, 10, 60, 50)];
    _indexLabel.numberOfLines = 1;
    _indexLabel.textAlignment = NSTextAlignmentRight;
    _indexLabel.font = [UIFont systemFontOfSize:14];
    _indexLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:_indexLabel];
    
    UIBarItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                     target:nil
                                                                     action:nil];
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] initWithCapacity:7];
    for (NSInteger i = 0; i<4; i++) {
        [toolbarItems addObject:space];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"按钮%i", i] style:UIBarButtonItemStyleDone target:self action:@selector(doBarItem:)];
        [toolbarItems addObject:barItem];
    }
    [toolbarItems addObject:space];
    
    CGRect toolbarFrame = CGRectMake(0,
                                     70,
                                     screenFrame.size.width,
                                     44);
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    [toolbar setItems:toolbarItems];
    
    [bottomView_ addSubview:toolbar];
    
    CGRect bottomFrame = CGRectMake(0,
                                    screenFrame.size.height - bottomView_.frame.size.height - toolbarFrame.size.height - titleView.frame.size.height,
                                    screenFrame.size.width,
                                    bottomView_.frame.size.height + toolbarFrame.size.height + titleView.frame.size.height);
    bottomView_.frame = bottomFrame;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
