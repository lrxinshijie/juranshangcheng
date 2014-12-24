//
//  TextFieldCell.h
//  JuranClient
//
//  Created by 李 久龙 on 14/12/18.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end
