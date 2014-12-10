//
//  MenuView.h
//  JuranClient
//
//  Created by Kowloon on 14/12/9.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

+ (MenuView *)sharedView;

- (void)showMenu;
- (void)hideMenu;

@end
