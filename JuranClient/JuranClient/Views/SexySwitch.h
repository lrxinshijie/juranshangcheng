//
//  SexySwitch.h
//  JuranClient
//
//  Created by song.he on 14-11-29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SexySwitchDelegate;

@interface SexySwitch : UIView

@property (nonatomic, weak) id<SexySwitchDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@protocol SexySwitchDelegate <NSObject>

- (void)sexySwitch:(SexySwitch*)sexySwitch valueChange:(NSInteger) index;

@end