//
//  EScrollerView.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "EScrollerView.h"
#import "JRAdInfo.h"

@interface EScrollerView () <UIScrollViewDelegate> {
    CGRect viewSize;
    UIScrollView *scrollView;
    NSArray *imageArray;
    
    UIPageControl *pageControl;
    
    int currentPageIndex;
}

@end

@implementation EScrollerView

- (void)dealloc {
    
}

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr
{
    //LOG(@"%d",imgArr.count);
	if ((self = [super initWithFrame:rect])) {
        
        if ([imgArr count] == 0) {
            return self;
        }
        
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        
        self.userInteractionEnabled=YES;
        
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtTheIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtTheIndex:0]];
		imageArray=[NSArray arrayWithArray:tempArray];
		viewSize = rect;
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * [imageArray count], viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        for (int i=0; i<[imageArray count]; i++) {
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(viewSize.size.width*i, 0, viewSize.size.width, viewSize.size.height)];
            JRAdInfo *ad = [imageArray objectAtTheIndex:i];
            
            [imgView setImageWithURLString:ad.mediaCode];
            
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            imgView.userInteractionEnabled=YES;
            imgView.tag = i;
            [imgView addTapGestureRecognizerWithTarget:self action:@selector(imagePressed:)];
            [scrollView addSubview:imgView];
        }
        
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];
        
        float pageControlWidth = ([imageArray count]-2)*10.0f+40.f;
        float pagecontrolHeight = 20.0f;
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth)-7,6, pageControlWidth, pagecontrolHeight)];
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        pageControl.center = CGPointMake(rect.size.width/2, CGRectGetHeight(rect)-10);
        pageControl.numberOfPages=([imageArray count]-2);
        [self addSubview:pageControl];
	}
	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    CGFloat pageWidth = scrollView.frame.size.width;

    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex = page;
    
    pageControl.currentPage = (page-1);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (currentPageIndex==0) {
        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width , 0)];
    }
    
   if (currentPageIndex == ([imageArray count]-1)) {
       [_scrollView setContentOffset:CGPointMake(viewSize.size.width , 0)];
    }
}

- (void)turnPage
{
    int page = pageControl.currentPage;
    [scrollView scrollRectToVisible:CGRectMake(viewSize.size.width*(page+1),0,viewSize.size.width,viewSize.size.height) animated:NO];
}

- (void)runTimePage
{
    int page = pageControl.currentPage;
    page++;
    //NSLog(@"%i",page);
    page = page > [imageArray count]-3 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}

- (void)imagePressed:(UITapGestureRecognizer *)sender
{

    if ([_delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [_delegate EScrollerViewDidClicked:sender.view.tag-1];
    }
}

@end