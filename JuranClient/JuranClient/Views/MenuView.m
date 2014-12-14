//
//  MenuView.m
//  JuranClient
//
//  Created by Kowloon on 14/12/9.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "MenuView.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "QuestionViewController.h"
#import "NewestTopicViewController.h"

static CGFloat kAnimateDuration = 0.25f;

@interface MenuView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *selects;

@end

@implementation MenuView

- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeightWithoutNavigationBar)]) {
        
        self.titles = @[@"精选活动",@"家装百科",@"答疑解惑",@"最新话题",@"扫一扫",@"设置",@"关于"];
        self.images = @[@"menu_activity_default",@"menu_baike_default",@"menu_answer_default",@"menu_topic_default",@"menu_qr_default",@"menu_setting_default",@"menu_about_default"];
        self.selects = @[@"menu_activity_select",@"menu_baike_select",@"menu_answer_select",@"menu_topic_select",@"menu_qr_select",@"menu_setting_select",@"menu_about_select"];

        UISwipeGestureRecognizer *swipt = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu)];
        swipt.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipt];
        
        self.tableView = [self tableViewWithFrame:CGRectMake(0, 0, 220, kWindowHeightWithoutNavigationBar) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
        _tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    
    return self;
}


+ (MenuView *)sharedView{
    static MenuView *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)showMenu{
    if ([self superview]) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.x = -CGRectGetWidth(frame);
    self.frame = frame;
    
    UIView *supview = [(AppDelegate *)[UIApplication sharedApplication].delegate tabBarController].view;
    [supview addSubview:self];
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.x = 0;
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    }];
}

- (void)hideMenu{
    if (![self superview]) {
        return;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.x = -CGRectGetWidth(frame);
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.text = [_titles objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];

    cell.imageView.image = [UIImage imageNamed:[_images objectAtIndex:indexPath.row]];
    cell.textLabel.highlightedTextColor = kBlueColor;
    cell.imageView.highlightedImage = [UIImage imageNamed:[_selects objectAtIndex:indexPath.row]];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *selectView = [[UIView alloc] init];
    selectView.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
    cell.selectedBackgroundView = selectView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(tableView.frame)/[_titles count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.x = -CGRectGetWidth(frame);
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        UINavigationController *nav = (UINavigationController *)[(AppDelegate *)[UIApplication sharedApplication].delegate tabBarController].selectedViewController;
        if (indexPath.row == 5) {
            SettingsViewController *vc = [[SettingsViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;

            [nav pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){
            QuestionViewController *vc = [[QuestionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [nav pushViewController:vc animated:YES];
        }else if (indexPath.row == 3){
            NewestTopicViewController *vc = [[NewestTopicViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [nav pushViewController:vc animated:YES];
        }
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
