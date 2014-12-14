//
//  ActionSheetMultiPicker.h
//  JuranClient
//
//  Created by 李 久龙 on 14/12/14.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AbstractActionSheetPicker.h"

@class ActionSheetMultiPicker;

typedef void(^ActionMultiDoneBlock)(ActionSheetMultiPicker *picker, NSArray *selectedIndexs, NSArray *selectedValues);
typedef void(^ActionMultiCancelBlock)(ActionSheetMultiPicker *picker);

@interface ActionSheetMultiPicker : AbstractActionSheetPicker

+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSArray *)indexs doneBlock:(ActionMultiDoneBlock)doneBlock cancelBlock:(ActionMultiCancelBlock)cancelBlockOrNil origin:(id)origin;

@end
