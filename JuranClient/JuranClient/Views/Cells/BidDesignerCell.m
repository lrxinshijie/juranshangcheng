//
//  BidDesignerCell.m
//  JuranClient
//
//  Created by song.he on 14-12-13.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "BidDesignerCell.h"
#import "JRDesigner.h"
#import "JRBidInfo.h"

@interface BidDesignerCell()

@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *styleLabel;
@property (nonatomic, strong) IBOutlet UILabel *experienceLabel;
@property (nonatomic, strong) IBOutlet UILabel *produntCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *browseCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *declarationLabel;
@property (nonatomic, strong) IBOutlet UIImageView *headImageView;

@property (nonatomic, strong) IBOutlet UIImageView *confirmFlagImageView;

@property (nonatomic, strong) IBOutlet UIButton *measureButton;
@property (nonatomic, strong) IBOutlet UIButton *rejectButton;


@property (nonatomic, strong) JRBidInfo *bidInfo;

@end

@implementation BidDesignerCell

- (void)awakeFromNib {
    // Initialization code
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2.f;
    
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = (UIButton*)[self.bgView viewWithTag:1100 + i];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3.f;
        btn.layer.borderColor = RGBColor(0, 89, 172).CGColor;
        btn.layer.borderWidth = 1.0f;
    }
    
#ifdef kJuranDesigner
    UIView *view = [self.bgView viewWithTag:1200];
    view.hidden = YES;
    self.bgView.frame = CGRectMake(0, 0, kWindowWidth, 125);
#endif
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithConfirmBidInfo:(JRBidInfo*)bidInfo{
    [self fillCellWithJRBidInfo:bidInfo];
    _confirmFlagImageView.hidden = NO;
}

- (void)fillCellWithJRBidInfo:(JRBidInfo*)bidInfo{
    _confirmFlagImageView.hidden = YES;
    _bidInfo = bidInfo;
    JRDesigner *designer = _bidInfo.userBase;
    _nameLabel.text = designer.nickName.length?designer.nickName:designer.account;
    if (designer.headUrl.length > 0) {
        [_headImageView setImageWithURLString:designer.headUrl];
    }else{
        _headImageView.image = [UIImage imageNamed:@"unlogin_head.png"];
    }
    
    _timeLabel.text = bidInfo.bidDate;
    _styleLabel.text = [designer styleNameForPersonal];
    _experienceLabel.text =  [designer experienceString];
    _produntCountLabel.text = [NSString stringWithFormat:@"%i", designer.projectCount];
    _browseCountLabel.text = [NSString stringWithFormat:@"%i", designer.browseCount];
    _declarationLabel.text = [NSString stringWithFormat:@"应标宣言:%@", bidInfo.biddingDeclatation];
#ifndef kJuranDesigner
    if ([bidInfo isForbidMeasureAndReject]) {
        [_measureButton setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
        _measureButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_rejectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _rejectButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }else{
        [_measureButton setTitleColor:RGBColor(0, 89, 172) forState:UIControlStateNormal];
        _measureButton.layer.borderColor = RGBColor(0, 89, 172).CGColor;
        [_rejectButton setTitleColor:RGBColor(0, 89, 172) forState:UIControlStateNormal];
        _rejectButton.layer.borderColor = RGBColor(0, 89, 172).CGColor;
    }
#endif
}

#pragma mark - Target Action

- (IBAction)onPrivateLetter:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(privateLetter:andBidInfo:)])
    {
        [_delegate privateLetter:self andBidInfo:_bidInfo];
    }
}

- (IBAction)onTakeMeasure:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(takeMeasure:andBidInfo:)])
    {
        [_delegate takeMeasure:self andBidInfo:_bidInfo];
    }
}

- (IBAction)onReject:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(rejectForBid:andBidInfo:)])
    {
        [_delegate rejectForBid:self andBidInfo:_bidInfo];
    }
}

@end
