//
//  ActionSheetMultiPicker.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/14.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ActionSheetMultiPicker.h"

@interface ActionSheetMultiPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *selectedIndexs;
@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, copy) ActionMultiDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionMultiCancelBlock onActionSheetCancel;

@end

@implementation ActionSheetMultiPicker


+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSArray *)indexs doneBlock:(ActionMultiDoneBlock)doneBlock cancelBlock:(ActionMultiCancelBlock)cancelBlockOrNil origin:(id)origin {
    ActionSheetMultiPicker * picker = [[ActionSheetMultiPicker alloc] initWithTitle:title rows:strings initialSelection:indexs doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSArray *)indexs doneBlock:(ActionMultiDoneBlock)doneBlock cancelBlock:(ActionMultiCancelBlock)cancelBlockOrNil origin:(id)origin {
    self = [self initWithTitle:title rows:strings initialSelection:indexs target:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSArray *)indexs target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    ActionSheetMultiPicker *picker = [[ActionSheetMultiPicker alloc] initWithTitle:title rows:data initialSelection:indexs target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSArray *)indexs target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.datas = [NSMutableArray arrayWithArray:data];
        self.selectedIndexs = [NSMutableArray arrayWithArray:indexs];
        self.title = title;
    }
    return self;
}

- (UIView *)configuredPickerView {
    if (!self.datas)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    
    [_selectedIndexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [stringPicker selectRow:[obj integerValue] inComponent:idx animated:NO];
    }];
    
    
    if (self.datas.count == 0) {
        stringPicker.showsSelectionIndicator = NO;
        stringPicker.userInteractionEnabled = NO;
    } else {
        stringPicker.showsSelectionIndicator = YES;
        stringPicker.userInteractionEnabled = YES;
    }
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    return stringPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (self.onActionSheetDone) {
//        id selectedObject = (self.data.count > 0) ? (self.data)[(NSUInteger) self.selectedIndex] : nil;
        _onActionSheetDone(self, self.selectedIndexs, nil);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:successAction withObject:self.selectedIndexs withObject:origin];
#pragma clang diagnostic pop
        return;
    }
    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), sel_getName(successAction));
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:cancelAction withObject:origin];
#pragma clang diagnostic pop
    }
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0 && row > 4) {
        self.selectedIndexs = [NSMutableArray arrayWithArray:@[@(row), @(0), @(0)]];
    }else{
        [_selectedIndexs replaceObjectAtIndex:component withObject:@(row)];
    }
    
    
    [pickerView reloadComponent:1];
    [pickerView reloadComponent:2];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [_datas count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger row = [[_selectedIndexs objectAtIndex:0] integerValue];
    if (row > 4 && component > 0) {
        return 1;
    }else{
        return [[_datas objectAtIndex:component] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id obj = _datas[component][row];
    
    // return the object if it is already a NSString,
    // otherwise, return the description, just like the toString() method in Java
    // else, return nil to prevent exception
    
    if ([obj isKindOfClass:[NSString class]])
        return obj;
    
    if ([obj respondsToSelector:@selector(description)])
        return [obj performSelector:@selector(description)];
    
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (pickerView.frame.size.width - 30)/[_datas count];
}

@end
