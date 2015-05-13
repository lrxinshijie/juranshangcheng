//
//  ProductFilterView.m
//  JuranClient
//
//  Created by HuangKai on 15/5/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductFilterView.h"
#import "ProductFilterData.h"

@interface ProductFilterView()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *selectedBtn;
}
@property (nonatomic, strong) UIButton *sortButton;
@property (nonatomic, strong) UILabel *sortLabel;
@property (nonatomic, strong) UIImageView *sortImageView;

@property (nonatomic, strong) UIButton *storeButton;
@property (nonatomic, strong) UILabel *storeLabel;
@property (nonatomic, strong) UIImageView *storeImageView;
@property (nonatomic, strong) UIView *clearStoreView;

@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UILabel *filterLabel;
@property (nonatomic, strong) UIImageView *filterImageView;

@property (nonatomic, strong) UIButton *gridButton;

@property (nonatomic, assign) BOOL isGrid;
@property (nonatomic, assign) BOOL isFilter;

@property (nonatomic, assign) UIView *parentView;
@property (nonatomic, assign) ProductFilterData *defaultData;
@property (nonatomic, strong) ProductSelectedFilter *selectedData;
@property (nonatomic, strong) UINavigationController *filterViewNav;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ProductFilterView


- (void)dealloc{
    _tableView.delegate = nil, _tableView.dataSource = nil; _tableView = nil;
}

-(id)initWithDefaultData:(ProductFilterData *)defaultData SeletedData:(ProductSelectedFilter*)seletedData{
    self = [super initWithFrame:CGRectMake(0, 0, kWindowWidth, 40)];
    if (self) {
        self.defaultData = defaultData;
        self.selectedData = seletedData;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 44)];
        [bgImg setImage:[UIImage imageNamed:@"bcs_list_bg"]];
        [self addSubview:bgImg];
        
        CGRect frame = CGRectMake(0, 0, 100, CGRectGetHeight(self.frame));
        self.sortButton = [self buttonWithFrame:frame target:self action:@selector(clickButton:) image:nil];
        [self addSubview:_sortButton];
        
        frame = CGRectMake(0, 10, 0, 20);
        self.sortLabel = [self labelWithFrame:frame text:@"综合排序" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:kSystemFontSize]];
        [self addSubview:_sortLabel];
        
        self.sortImageView = [self imageViewWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - 4)/2.f, 7, 4) image:[UIImage imageNamed:@"product-arrow-down.png"]];
        [self addSubview:_sortImageView];
        
        frame = CGRectMake(CGRectGetMaxX(_sortButton.frame), 10, 0.5, 20);
        UIView *lineView = [[UIView alloc] initWithFrame:frame];
        lineView.backgroundColor = RGBColor(213, 213, 213);
        [self addSubview:lineView];
        
        frame = CGRectMake(CGRectGetMaxX(_sortButton.frame), 0, 95, CGRectGetHeight(self.frame));
        self.storeButton = [self buttonWithFrame:frame target:self action:@selector(clickButton:) image:nil];
        [self addSubview:_storeButton];
        
        frame = CGRectMake(0, 10, 0, 20);
        self.storeLabel = [self labelWithFrame:frame text:@"选择门店" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:kSystemFontSize]];
        [self addSubview:_storeLabel];
        
        self.storeImageView = [self imageViewWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - 4)/2.f, 7, 4) image:[UIImage imageNamed:@"product-arrow-down.png"]];
        [self addSubview:_storeImageView];
        
        frame = CGRectMake(CGRectGetMaxX(_storeButton.frame), 10, 0.5, 20);
        lineView = [[UIView alloc] initWithFrame:frame];
        lineView.backgroundColor = RGBColor(213, 213, 213);
        [self addSubview:lineView];
        
        frame = CGRectMake(CGRectGetMaxX(_storeButton.frame), 0, 80, CGRectGetHeight(self.frame));
        self.filterButton = [self buttonWithFrame:frame target:self action:@selector(clickButton:) image:nil];
        [self addSubview:_filterButton];
        
        frame = CGRectMake(0, 10, 0, 20);
        self.filterLabel = [self labelWithFrame:frame text:@"筛选" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:kSystemFontSize]];
        [self addSubview:_filterLabel];
        
        self.filterImageView = [self imageViewWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - 10)/2.f, 9, 10) image:[UIImage imageNamed:@"icon-product-filter.png"]];
        [self addSubview:_filterImageView];
        
        frame = CGRectMake(CGRectGetMaxX(_filterButton.frame), 10, 0.5, 20);
        lineView = [[UIView alloc] initWithFrame:frame];
        lineView.backgroundColor = RGBColor(213, 213, 213);
        [self addSubview:lineView];
        
        frame = CGRectMake(CGRectGetMaxX(_filterButton.frame), 0, kWindowWidth - CGRectGetMaxX(_filterButton.frame), CGRectGetHeight(self.frame));
        self.gridButton = [self buttonWithFrame:frame target:self action:@selector(clickButton:) image:[UIImage imageNamed:@"icon-list.png"]];
        [self addSubview:_gridButton];
        
        frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1);
        lineView = [[UIView alloc] initWithFrame:frame];
        lineView.backgroundColor = RGBColor(213, 213, 213);
        [self addSubview:lineView];
        
        frame = CGRectMake(0, 0, kWindowWidth, 40);
        self.clearStoreView = [[UIView alloc] initWithFrame:frame];
        _clearStoreView.backgroundColor = [UIColor whiteColor];
        
        frame = CGRectMake(15, 0, CGRectGetWidth(self.clearStoreView.frame) - 15, 1);
        lineView = [[UIView alloc] initWithFrame:frame];
        lineView.backgroundColor = RGBColor(213, 213, 213);
        [_clearStoreView addSubview:lineView];
        
        UILabel *label = [_clearStoreView labelWithFrame:CGRectMake(15, 10, 200, 20) text:@"清除门店选择" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
        [_clearStoreView addSubview:label];
        
        UIButton *btn = [_clearStoreView buttonWithFrame:_clearStoreView.bounds target:self action:@selector(onClearStore:) image:nil];
        [_clearStoreView addSubview:btn];
        
        
        [self layoutFrame];
    }
    return self;
}

- (void)layoutFrame{
    CGRect frame = _sortLabel.frame;
    frame.size.width = [_sortLabel.text widthWithFont:_sortLabel.font constrainedToHeight:CGRectGetHeight(_sortLabel.frame)];
    frame.origin.x = CGRectGetMinX(_sortButton.frame) + (CGRectGetWidth(_sortButton.frame) - CGRectGetWidth(frame))/2.f;
    _sortLabel.frame = frame;
    
    frame = _sortImageView.frame;
    frame.origin.x = CGRectGetMaxX(_sortLabel.frame)+2;
    _sortImageView.frame = frame;
    
    frame = _storeLabel.frame;
    frame.size.width = [_storeLabel.text widthWithFont:_storeLabel.font constrainedToHeight:CGRectGetHeight(_storeLabel.frame)];
    frame.origin.x = CGRectGetMinX(_storeButton.frame) + (CGRectGetWidth(_storeButton.frame) - CGRectGetWidth(frame))/2.f;
    _storeLabel.frame = frame;
    
    frame = _storeImageView.frame;
    frame.origin.x = CGRectGetMaxX(_storeLabel.frame)+2;
    _storeImageView.frame = frame;
    
    frame = _filterLabel.frame;
    frame.size.width = [_filterLabel.text widthWithFont:_filterLabel.font constrainedToHeight:CGRectGetHeight(_filterLabel.frame)];
    frame.origin.x = CGRectGetMinX(_filterButton.frame) + (CGRectGetWidth(_filterButton.frame) - CGRectGetWidth(frame))/2.f;
    _filterLabel.frame = frame;
    
    frame = _filterImageView.frame;
    frame.origin.x = CGRectGetMaxX(_filterLabel.frame)+2;
    _filterImageView.frame = frame;
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [self tableViewWithFrame:CGRectMake(0, 104+_xMargin, kWindowWidth, CGRectGetHeight(self.viewController.view.frame)-40) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
        _tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    selectedBtn.selected = NO;
    selectedBtn = nil;
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
        //        [self showSort];
    }
}

- (void)clickFilterButton:(UIButton*)btn{
    _isFilter = YES;
    if ([_delegate respondsToSelector:@selector(clickProductFilterView:returnData:IsGrid:IsFilter:actionType:)]) {
        [_delegate clickProductFilterView:self returnData:_selectedData IsGrid:_isGrid IsFilter:_isFilter actionType:FilterViewActionFilter];
    }
    _isFilter = NO;
}

- (void)clickButton:(UIButton *)btn{
    if (btn == _filterButton) {
        [self showFilter];
    }else if (btn == _gridButton){
        [self showGrid];
    }else{
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
            selectedBtn = btn;
            selectedBtn.selected = YES;
            [self reloadData];
        }
    }
}

- (void)onClearStore:(id)sender{
    _selectedData.pStore = nil;
    
    if ([_delegate respondsToSelector:@selector(clickProductFilterView:returnData:IsGrid:IsFilter:actionType:)]) {
        [_delegate clickProductFilterView:self returnData:_selectedData IsGrid:_isGrid IsFilter:_isFilter actionType:FilterViewActionStore];
    }
    
    selectedBtn.selected = NO;
    selectedBtn = nil;
    [self showSort];
    
}

- (BOOL)isShow{
    return !self.tableView.hidden;
}

- (void)showFilter{
    if ([self isShow]) {
        selectedBtn.selected = NO;
        selectedBtn = nil;
        [self showSort];
    }
    _isFilter = YES;
    [self.gridButton setImage:[UIImage imageNamed:_isGrid?@"icon-grid.png":@"icon-list.png"] forState:UIControlStateNormal];
    if ([_delegate respondsToSelector:@selector(clickProductFilterView:returnData:IsGrid:IsFilter:actionType:)]) {
        [_delegate clickProductFilterView:self returnData:_selectedData IsGrid:_isGrid IsFilter:_isFilter actionType:FilterViewActionFilter];
    }
    _isFilter = NO;
}

- (void)showGrid{
    if ([self isShow]) {
        selectedBtn.selected = NO;
        selectedBtn = nil;
        [self showSort];
    }
    _isGrid = !_isGrid;
    [self.gridButton setImage:[UIImage imageNamed:_isGrid?@"icon-grid.png":@"icon-list.png"] forState:UIControlStateNormal];
    if ([_delegate respondsToSelector:@selector(clickProductFilterView:returnData:IsGrid:IsFilter:actionType:)]) {
        [_delegate clickProductFilterView:self returnData:_selectedData IsGrid:_isGrid IsFilter:_isFilter actionType:FilterViewActionGrid];
    }
}

- (void)showSort{
    BOOL isHide = !self.tableView.hidden;
    
    _tableView.hidden = isHide;
    _tableView.alpha = isHide ? 1 : 0;
    [self reloadData];
    
    [UIView animateWithDuration:.2 animations:^{
        _tableView.alpha = isHide ? 0 : 1;
    } completion:^(BOOL finished) {
        _tableView.hidden = isHide;
    }];
    if (isHide) {
        _sortButton.selected = NO;
        _filterButton.selected = NO;
        selectedBtn = nil;
    }
}

- (void)reloadData{
    _tableView.tableFooterView = [[UIView alloc] init];
    
    if (_sortButton.selected) {
        _sortLabel.textColor = kBlueColor;
        _sortImageView.image = [UIImage imageNamed:@"product-arrow-up.png"];
    }else{
        _sortLabel.textColor = [UIColor blackColor];
        _sortImageView.image = [UIImage imageNamed:@"product-arrow-down.png"];
    }
    
    if (_storeButton.selected) {
        _storeLabel.textColor = kBlueColor;
        _storeImageView.image = [UIImage imageNamed:@"product-arrow-up.png"];
    }else{
        _storeLabel.textColor = [UIColor blackColor];
        _storeImageView.image = [UIImage imageNamed:@"product-arrow-down.png"];
    }
    _storeLabel.text = _selectedData.pStore?_selectedData.pStore.storeName:@"选择门店";
    
    if (selectedBtn && selectedBtn == _storeButton && _selectedData.pStore) {
        _tableView.tableFooterView = _clearStoreView;
    }
    
    [self layoutFrame];
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (selectedBtn == _sortButton) {
        return [self.defaultData.sortList count];
    }else if(selectedBtn == _storeButton){
        return [self.defaultData.storeList count];
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
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (selectedBtn == _sortButton) {
        ProductSort *sort = self.defaultData.sortList[indexPath.row];
        cell.textLabel.text = sort.name;
        if (_selectedData.sort>0 && _selectedData.sort == sort.sort) {
            cell.textLabel.textColor = kBlueColor;
        }
    }else if(selectedBtn == _storeButton){
        ProductStore *store = self.defaultData.storeList[indexPath.row];
        cell.textLabel.text = store.storeName;
        if (_selectedData.pStore && [_selectedData.pStore.storeName isEqualToString:store.storeName]) {
            cell.textLabel.textColor = kBlueColor;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedBtn == _sortButton) {
        ProductSort *sort = self.defaultData.sortList[indexPath.row];
        _selectedData.sort = sort.sort;
    }else if(selectedBtn == _storeButton){
        ProductStore *store = self.defaultData.storeList[indexPath.row];
        _selectedData.pStore = store;
    }
    if ([_delegate respondsToSelector:@selector(clickProductFilterView:returnData:IsGrid:IsFilter:actionType:)]) {
        [_delegate clickProductFilterView:self returnData:_selectedData IsGrid:_isGrid IsFilter:_isFilter actionType:FilterViewActionSort];
    }
    selectedBtn.selected = NO;
    selectedBtn = nil;
    _isFilter = NO;
    [self showSort];
}

@end
