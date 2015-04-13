//
//  SearchTableViewCell.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    SearchTableViewCellModel_History = 0,
    SearchTableViewCellModel_SearchRange
    
}SearchTableViewCellModel;

@interface SearchTableViewCell : UITableViewCell

/*
    使用这个cell，请调用NSBundle的方法进行初始化。然后需要对这个cell进行UI的设定，model为UI类型取值SearchTableViewCellModel_History为历史记录类型，SearchTableViewCellModel_SearchRange为选择搜索范围类型，model必须传参。name必须传参为左边展示文字，count只在SearchTableViewCellModel_SearchRange模式下传参，传参为纯数字的字符串。
 */
- (void)setCellUIWithCellModel:(SearchTableViewCellModel)model leftLabelText:(NSString *)name rightLabelText:(NSString *)count;

- (NSString *)getSearchCellMessage;

@end
