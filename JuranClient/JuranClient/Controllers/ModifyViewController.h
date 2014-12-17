//
//  ModifyViewController.h
//  JuranClient
//
//  Created by song.he on 14-11-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"
@class ModifyViewController;

typedef NS_ENUM(NSInteger, ModifyCVType ) {
    ModifyCVTypeUserName,
    ModifyCVTypeHomeTel,
    ModifyCVTypeIdType,
    ModifyCVTypeQQ,
    ModifyCVTypeWeiXin,
    ModifyCVTypeNickName
};

@protocol ModifyViewControllerDelegate <NSObject>

- (void)modifyCommit:(ModifyViewController*)vc;

@end

@interface ModifyViewController : ALViewController

@property (nonatomic, assign) ModifyCVType type;
@property (nonatomic, weak) id<ModifyViewControllerDelegate> delegate;
@property (nonatomic, strong) JRUser *user;

- (id)initWithMemberDetail:(JRUser*)user type:(ModifyCVType)type;


@end
