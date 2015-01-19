//
//  WikiCell.m
//  JuranClient
//
//  Created by HuangKai on 15/1/17.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "WikiCell.h"
#import "JRWiki.h"

@interface WikiCell()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *browseCountLabel;
@property (nonatomic, strong) IBOutlet UIImageView *contentImageView;
@property (nonatomic, strong) IBOutlet UIImageView *videoImageView;

@end

@implementation WikiCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithWiki:(JRWiki*)wiki{
    self.titleLabel.text = wiki.title;
    self.browseCountLabel.text = [NSString stringWithFormat:@"人气：%d", wiki.browseCount];
    if (wiki.imageUrl.length > 0) {
        [self.contentImageView setImageWithURLString:wiki.imageUrl];
    }else{
        self.contentImageView.image = [UIImage imageNamed:@"case_default_image.png"];
    }
    
    self.videoImageView.hidden = !wiki.hasVideo;
    
}

@end
