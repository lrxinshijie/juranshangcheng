//
//  SubjectCell.m
//  JuranClient
//
//  Created by Kowloon on 14/12/2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SubjectCell.h"
#import "JRSubject.h"

@interface SubjectCell ()

@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;

@end
@implementation SubjectCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithSubject:(JRSubject *)subject{
    [_photoImageView setImageWithURLString:subject.subjectUrl];
}

@end
