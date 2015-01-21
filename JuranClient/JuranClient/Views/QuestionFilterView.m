//
//  QuestionFilterView.m
//  JuranClient
//
//  Created by song.he on 14-12-19.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "QuestionFilterView.h"

@interface QuestionFilterView()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *selectedBtn;
}
@property (nonatomic, strong) UIButton *sortButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UIView *parentView;
@property (nonatomic, assign) NSDictionary *defaultData;
@property (nonatomic, strong) UINavigationController *filterViewNav;

@end

@implementation QuestionFilterView


- (void)dealloc{
    _tableView.delegate = nil, _tableView.dataSource = nil; _tableView = nil;
}

-(id)initWithDefaultData:(NSDictionary *)defaultData{
    self = [super initWithFrame:CGRectMake(0, 0, kWindowWidth, 44)];
    if (self) {
        self.defaultData = defaultData;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 44)];
        [bgImg setImage:[UIImage imageNamed:@"bcs_list_bg"]];
        [self addSubview:bgImg];
        
        self.sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sortButton.frame = CGRectMake(0, 0, 160, 44);
        [_sortButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_sortButton setTitle:@" 分类" forState:UIControlStateNormal];
        _sortButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sortButton setImage:[UIImage imageNamed:@"filter_kind"] forState:UIControlStateNormal];
        
        [_sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sortButton setTitleColor:kBlueColor forState:UIControlStateSelected];
        [_sortButton setImage:[UIImage imageNamed:@"filter_kind_selected"] forState:UIControlStateSelected];
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
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 0, 1, 44)];
        lineImageView.backgroundColor = RGBColor(213, 213, 213);
        [self addSubview:lineImageView];
    }
    
    
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [self tableViewWithFrame:CGRectMake(0, 108, kWindowWidth, CGRectGetHeight(self.viewController.view.frame)-44) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
        _tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _tableView.hidden = YES;
        UINavigationController *nav = self.viewController.navigationController;
        [nav.view addSubview:_tableView];
        UIView *bgView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        bgView.backgroundColor = [UIColor clearColor];
        UIButton *btn = [bgView buttonWithFrame:bgView.bounds target:self action:@selector(onHidden:) image:nil];
        [bgView addSubview:btn];
        _tableView.backgroundView = bgView;
    }
    return _tableView;
}

- (void)onHidden:(id)sender{
    [self showSort];
}

- (void)clickSortButton:(UIButton *)btn{
    if (selectedBtn == nil) {
        selectedBtn = btn;
        selectedBtn.selected = YES;
        [self showSort];
    }else if (selectedBtn == btn){
        selectedBtn.selected = NO;
    }else{
        selectedBtn.selected = NO;
        selectedBtn = btn;
        selectedBtn.selected = YES;
        [self showSort];
        [self showSort];
    }
}

- (void)clickFilterButton:(UIButton*)btn{
    
}

- (void)clickButton:(UIButton *)btn{
    if (selectedBtn == nil) {
        selectedBtn = btn;
        selectedBtn.selected = YES;
        [self showSort];
    }else if (selectedBtn == btn){
        selectedBtn.selected = NO;
        selectedBtn = nil;
        [self showSort];
    }else{
        selectedBtn.selected = NO;
        selectedBtn = nil;
//        [self showSort];
        selectedBtn = btn;
        selectedBtn.selected = YES;
//        [self showSort];
        [self.tableView reloadData];
    }
}

- (BOOL)isShow{
    return !self.tableView.hidden;
}

- (void)showSort{
    BOOL isHide = !self.tableView.hidden;
    _tableView.alpha = isHide ? 1 : 0;
    _tableView.hidden = isHide;
    [_tableView reloadData];
    [UIView animateWithDuration:.2 animations:^{
        _tableView.alpha = isHide ? 0 : 1;
    } completion:^(BOOL finished) {
        _tableView.hidden = isHide;
    }];
    
    if (isHide == YES) {
        _sortButton.selected = NO;
        _filterButton.selected = NO;
        selectedBtn = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (selectedBtn == _sortButton) {
        return [self.sorts count];
    }else if(selectedBtn == _filterButton){
        return [self.filters count];
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (selectedBtn == _sortButton) {
        cell.textLabel.text = [[self.sorts objectAtTheIndex:indexPath.row] objectForKey:@"k"];
    }else if(selectedBtn == _filterButton){
        cell.textLabel.text = [[self.filters objectAtTheIndex:indexPath.row] objectForKey:@"k"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = nil;
    if (selectedBtn == _sortButton) {
        NSString *v = [[self.sorts objectAtTheIndex:indexPath.row] objectForKey:@"v"];
        data = @{@"questionType":v};
    }else if(selectedBtn == _filterButton){
        NSString *v = [[self.filters objectAtTheIndex:indexPath.row] objectForKey:@"v"];
        data = @{@"status":v};
    }
    
    if ([_delegate respondsToSelector:@selector(clickQuestionFilterView:returnData:)]) {
        [_delegate clickQuestionFilterView:self returnData:data];
    }
    
    [self showSort];
    selectedBtn.selected = NO;
    selectedBtn = nil;
}

#pragma mark - DataSource

- (NSArray *)sorts{
    if (!_sorts) {
        _sorts = @[CELLDICTIONARYBUILT(@"账户管理", @"account"),
                   CELLDICTIONARYBUILT(@"设计疑虑", @"design"),
                   CELLDICTIONARYBUILT(@"装修前后", @"decoration"),
                   CELLDICTIONARYBUILT(@"商品选购", @"goods"),
                   CELLDICTIONARYBUILT(@"DIY技巧", @"diy"),
                   CELLDICTIONARYBUILT(@"其他", @"other")];
        
    }
    return _sorts;
}

- (NSArray*)filters{
    if (!_filters) {
        _filters = @[CELLDICTIONARYBUILT(@"待解决问题", @"unresolved"),
                     CELLDICTIONARYBUILT(@"已解决问题", @"resolved")];
    }
    return _filters;
}

@end
