//
//  FilterView.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/7.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "FilterView.h"
#import "FilterViewController.h"

@interface FilterView () <UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate>

@property (nonatomic, strong) UIButton *sortButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UIView *parentView;
@property (nonatomic, assign) NSDictionary *defaultData;
@property (nonatomic, strong) UINavigationController *filterViewNav;
@property (nonatomic, assign) FilterViewType type;

@end

@implementation FilterView

- (void)dealloc{
    _tableView.delegate = nil, _tableView.dataSource = nil; _tableView = nil;
}

-(id)initWithType:(FilterViewType)type defaultData:(NSDictionary *)defaultData{
    self = [super initWithFrame:CGRectMake(0, 0, kWindowWidth, 44)];
    if (self) {
        self.defaultData = defaultData;
        self.type = type;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 44)];
        [bgImg setImage:[UIImage imageNamed:@"bcs_list_bg"]];
        [self addSubview:bgImg];
        
        self.sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sortButton.frame = CGRectMake(0, 0, 160, 44);
        [_sortButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_sortButton setTitle:@" 排序" forState:UIControlStateNormal];
        _sortButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sortButton setImage:[UIImage imageNamed:@"case-icon-order"] forState:UIControlStateNormal];
        
        [_sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sortButton setTitleColor:kBlueColor forState:UIControlStateSelected];
        [_sortButton setImage:[UIImage imageNamed:@"menu_paixu"] forState:UIControlStateSelected];
        [self addSubview:_sortButton];
        
        self.filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _filterButton.frame = CGRectMake(160, 0, 160, 44);
        [_filterButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_filterButton setTitle:@" 筛选" forState:UIControlStateNormal];
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_filterButton setImage:[UIImage imageNamed:@"case-icon-filter"] forState:UIControlStateNormal];
        [_filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_filterButton setTitleColor:kBlueColor forState:UIControlStateSelected];
        [_filterButton setImage:[UIImage imageNamed:@"menu_shaixuan"] forState:UIControlStateSelected];
        [self addSubview:_filterButton];
    }
    
    
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [self tableViewWithFrame:CGRectMake(0, 108, 320, CGRectGetHeight(self.viewController.view.frame)-44) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
        _tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _tableView.hidden = YES;
        UINavigationController *nav = self.viewController.navigationController;
        [nav.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)clickButton:(UIButton *)btn{
    if ([btn isEqual:_sortButton]) {
        [self showSort];
    }else{
        [self showFilter];
    }
}

- (BOOL)isShow{
    return !self.tableView.hidden;
}

- (void)showSort{
    BOOL isHide = !self.tableView.hidden;
    _tableView.alpha = isHide ? 1 : 0;
    _tableView.hidden = isHide;
    [UIView animateWithDuration:.2 animations:^{
        _tableView.alpha = isHide ? 0 : 1;
        _sortButton.selected = !isHide;
    } completion:^(BOOL finished) {
        _tableView.hidden = isHide;
    }];
    
}

- (void)showFilter{
    if ([self isShow]) {
        [self showSort];
    }
    
    if (!_filterViewNav) {
        FilterViewController *filterViewController = [[FilterViewController alloc] init];
        filterViewController.type = _type;
        filterViewController.delegate = self;
        filterViewController.selecteds = [NSMutableDictionary dictionaryWithDictionary:_defaultData];
        _filterViewNav = [Public navigationControllerFromRootViewController:filterViewController];
    }
    
    [self.viewController presentViewController:_filterViewNav animated:YES completion:NULL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sorts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.text = [[self.sorts objectAtTheIndex:indexPath.row] objectForKey:@"k"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *v = [[self.sorts objectAtTheIndex:indexPath.row] objectForKey:@"v"];
    if ([_delegate respondsToSelector:@selector(clickFilterView:actionType:returnData:)]) {
        [_delegate clickFilterView:self actionType:FilterViewActionSort returnData:@{@"order":v}];
    }
    
    [self showSort];
}

- (void)clickFilterViewReturnData:(NSDictionary *)data{
    if ([_delegate respondsToSelector:@selector(clickFilterView:actionType:returnData:)]) {
        [_delegate clickFilterView:self actionType:FilterViewActionFilter returnData:data];
    }
}

#pragma mark - DataSource

- (NSArray *)sorts{
    if (!_sorts) {
        if (_type == FilterViewTypeCase) {
            _sorts = @[CELLDICTIONARYBUILT(@"默认排序", @""),
                       CELLDICTIONARYBUILT(@"按点赞总数降序", @"2"),
                       CELLDICTIONARYBUILT(@"按点赞总数升序", @"6"),
                       CELLDICTIONARYBUILT(@"按浏览量降序", @"4"),
                       CELLDICTIONARYBUILT(@"按浏览量升序", @"7")];
        }else{
            _sorts = @[CELLDICTIONARYBUILT(@"默认排序", @"1"),CELLDICTIONARYBUILT(@"作品数从高到低排序", @"2"),CELLDICTIONARYBUILT(@"人气从高到低排序", @"3")];
        }
        
    }
    return _sorts;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end