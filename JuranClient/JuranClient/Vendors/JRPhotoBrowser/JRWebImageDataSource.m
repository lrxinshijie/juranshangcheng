//
//  JRWebImageDataSource.m
//  MyTest
//
//  Created by song.he on 14-11-27.
//  Copyright (c) 2014年 song.he. All rights reserved.
//

#import "JRWebImageDataSource.h"
#import "KTPhotoView+SDWebImage.h"

@implementation JRWebImageDataSource


- (id)init {
    self = [super init];
    if (self) {
        // Create a 2-dimensional array. First element of
        // the sub-array is the full size image URL and
        // the second element is the thumbnail URL.
        images_ = [[NSArray alloc] initWithObjects:@{@"url": @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg", @"title": @"可是江东父老开机收到了快放假了可是江东父老看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                     @"title": @"可是江东父老开机收到了快放假了可是江东父老看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                     @"title": @"可是江东父老开机假父尖上来的咖啡机"},
                   @{@"url": @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                     @"title": @"可是江东父老开机收到了快放假了可是江看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                     @"title": @"可是江东父老开机收到了可是江东可是江东父老看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                     @"title": @"可是江东父老开机收到了到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg", @"title": @"可是江东父老开机收到了快放假了可是江东父老看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                     @"title": @"可是江东父老开机收到了快放假了可是江东父老看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                     @"title": @"可是江东父老开机假父尖上来的咖啡机"},
                   @{@"url": @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                     @"title": @"可是江东父老开机收到了快放假了可是江看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                     @"title": @"可是江东父老开机收到了可是江东可是江东父老看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                     @"title": @"可是江东父老开机收到了到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg", @"title": @"可是江东父老开机收到了快放假了可是江东父老看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                     @"title": @"可是江东父老开机收到了快放假了可是江东父老看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                     @"title": @"可是江东父老开机假父尖上来的咖啡机"},
                   @{@"url": @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                     @"title": @"可是江东父老开机收到了快放假了可是江看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                     @"title": @"可是江东父老开机收到了可是江东可是江东父老看可升级到风口浪尖上来的咖啡机"},
                   @{@"url": @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                     @"title": @"可是江东父老开机收到了到风口浪尖上来的咖啡机"},
                   nil];
    }
    return self;
}

#pragma mark -
#pragma mark KTPhotoBrowserDataSource

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

/*
- (void)thumbImageAtIndex:(NSInteger)index thumbView:(KTThumbView *)thumbView {
    NSArray *imageUrls = [images_ objectAtIndex:index];
    NSString *url = [imageUrls objectAtIndex:THUMBNAIL_INDEX];
    [thumbView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}*/



@end
