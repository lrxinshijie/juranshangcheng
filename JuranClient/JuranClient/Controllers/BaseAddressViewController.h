//
//  BaseAddressViewController.h
//  JuranClient
//
//  Created by song.he on 14-12-7.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

//@class JRMemberDetail;
@class JRAreaInfo;

@interface BaseAddressViewController : ALViewController

//@property (nonatomic, strong) JRMemberDetail *memberDetail;
@property (nonatomic, copy) AddressSelected block;

- (void)setAreaInfo:(JRAreaInfo *)areaInfo andAddressSelected:(AddressSelected)finish;

@end
