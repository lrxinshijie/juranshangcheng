//
//  SelfIntrodutionCell.m
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SelfIntrodutionCell.h"

#define kContentLengthForClose 40

@interface SelfIntrodutionCell()
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIButton *hiddenButton;
@property (nonatomic, weak) IBOutlet UIView *backView;

@end

@implementation SelfIntrodutionCell

- (void)awakeFromNib
{
    // Initialization code
    _isClose = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(NSString *)content{
    _content = content;
    [self changeLabelHeight];
}

- (IBAction)doClose:(id)sender{
    _isClose = !_isClose;
    [self changeLabelHeight];
    if ([self.delegate respondsToSelector:@selector(heightChanged:)]) {
        [self.delegate heightChanged:self];
    }
}

- (void)changeLabelHeight{
    CGRect frame = _contentLabel.frame;
    _contentLabel.numberOfLines = 0;
    if (_isClose) {
        [_hiddenButton setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
        if (_content.length < kContentLengthForClose) {
            _contentLabel.text = _content;
        }else{
            _contentLabel.text = [NSString stringWithFormat:@"%@...", [_content substringToIndex:kContentLengthForClose]];
        }
        frame.size.height = 32;
    }else{
        [_hiddenButton setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateNormal];
        if (_content.length < kContentLengthForClose) {
            _contentLabel.text = _content;
        }else{
            _contentLabel.text = _content;
            CGSize size;
            if (SystemVersionGreaterThanOrEqualTo7) {
                size = [_contentLabel.text sizeWithFont:_contentLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(_contentLabel.frame), MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            }else{
                NSDictionary *attribute = @{NSFontAttributeName: _contentLabel.font};
                size = [_contentLabel.text boundingRectWithSize:CGSizeMake(280, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            }
            frame.size = size;
        }
    }
    _contentLabel.frame = frame;
    frame = self.frame;
    frame.size.height =  57 + _contentLabel.frame.size.height;
    self.frame = frame;
    self.contentView.frame = self.frame;
    frame = _backView.frame;
    frame.size.height = self.frame.size.height - 10;
    _backView.frame = frame;
    frame = _hiddenButton.frame;
    frame.origin.y = _backView.frame.size.height - 23;
    _hiddenButton.frame = frame;
}

@end
