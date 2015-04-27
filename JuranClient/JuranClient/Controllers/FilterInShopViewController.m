//
//  FilterInShopViewController.m
//  JuranClient
//
//  Created by 彭川 on 15/4/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "FilterInShopViewController.h"

@interface FilterInShopViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int selectedSection;
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) NSMutableArray *openSatusList;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) long selFilterCode;
@end

@implementation FilterInShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"商品分类";
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    NSDictionary *param = @{@"shopId": [NSString stringWithFormat:@"%@",@"1002"]};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SHOP_CLASSIFICATION parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _dataList = [FilterInShop buildUpWithValueForList:[data objectForKey:@"childrenCats"]];
            for (FilterInShop *filter in _dataList) {
                filter.childList = [FilterInShop buildUpWithValueForList:filter.childList];
                FilterInShop *all = [[FilterInShop alloc]init];
                all.name = @"全部";
                all.parentId = filter.parentId;
                all.depth = filter.depth;
                all.Id = filter.Id;
                all.childList = filter.childList;
                [filter.childList insertObject:all atIndex:0];
            }
            _openSatusList = [[NSMutableArray alloc] init];
            for (int i=0; i<_dataList.count; i++) {
                [_openSatusList addObject:@(NO)];
            }
            _selectedSection = 0;
            _selectedIndex = 0;
            [_tableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FilterInShop *filter = [_dataList objectAtIndex:section];
    if ([[_openSatusList objectAtIndex:section] boolValue]) {
        return filter.childList.count;
    }else {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UIView *line;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    line = [[UIView alloc]initWithFrame:CGRectMake(0, 37.5, kWindowWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:line];
    FilterInShop *filters = [_dataList objectAtIndex:[indexPath section]];
    FilterInShop *filter = [filters.childList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",filter.name];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 38)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = headerView.frame;
    FilterInShop *filters = [_dataList objectAtIndex:section];
    [titleButton setTitle:[NSString stringWithFormat:@"%@",filters.name] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    titleButton.tag = 6666+section;
    [titleButton addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:titleButton];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 37.5, kWindowWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:line];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(295, 16, 11, 6)];
    imageView.backgroundColor = [UIColor whiteColor];
    if ([[_openSatusList objectAtIndex:section] integerValue]==0) {
        imageView.image = [UIImage imageNamed:@"filter-icon-dropdown-1.png"];
    }else{
        imageView.image = [UIImage imageNamed:@"filter-icon-dropdown-2.png"];
    }
    [headerView addSubview:imageView];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FilterInShop *filters = [_dataList objectAtIndex:[indexPath section]];
    FilterInShop *filter = [filters.childList objectAtIndex:[indexPath row]];
    if (_block) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"filter id = %ld",filter.Id);
        _block(filter.Id);
    }
}

- (void)headerViewClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int section = btn.tag-6666;
    if ([[_openSatusList objectAtIndex:section] boolValue]) {
        [_openSatusList replaceObjectAtIndex:section withObject:@(NO)];
    }else {
        [_openSatusList replaceObjectAtIndex:section withObject:@(YES)];
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setFinishBlock:(FilterSelected)finished{
    self.block = finished;
}

@end

@implementation FilterInShop

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _name = [dict getStringValueForKey:@"name" defaultValue:@""];
            _parentId = [dict getIntValueForKey:@"parentId" defaultValue:0];
            _depth = [dict getIntValueForKey:@"depth" defaultValue:0];
            _Id = [dict getIntValueForKey:@"id" defaultValue:0];
            _childList = [dict objectForKey:@"goodsClassDtoList"];
        }
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            FilterInShop *filter = [[FilterInShop alloc]initWithDictionary:obj];
            [retVal addObject:filter];
        }
    }
    return retVal;
}

@end