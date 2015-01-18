//
//  WikiViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "WikiViewController.h"
#import "FilterView.h"
#import "JRWiki.h"
#import "WikiCell.h"
#import "JRWebViewController.h"

@interface WikiViewController ()<UITableViewDataSource, UITableViewDelegate, FilterViewDelegate>{
}

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) NSArray *filterSections;

@property (nonatomic, strong) IBOutlet UIView *emptyView;

@end

@implementation WikiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"家装百科";
    
    self.filterView = [[FilterView alloc] initWithType:FilterViewTypeWiki defaultData:_filterData];
    _filterView.delegate = self;
    [self.view addSubview:_filterView];
    
#ifdef kJuranDesigner
    CGRect frame = CGRectMake(0, 44, kWindowWidth, kWindowHeightWithoutNavigationBarAndTabbar - 44);
#else
    CGRect frame = CGRectMake(0, 44, kWindowWidth, kWindowHeightWithoutNavigationBar - 44);
#endif
    
    
    self.tableView = [self.view tableViewWithFrame:frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    [_tableView headerBeginRefreshing];
    
    _emptyView.hidden = YES;
    _emptyView.center = _tableView.center;
    [self.view addSubview:_emptyView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_filterView isShow]) {
        [_filterView showSort];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (NSMutableDictionary *)filterData{
    if (!_filterData) {
        
        NSDictionary *param = [[DefaultData sharedData] objectForKey:@"wikiDefaultParam"];
        _filterData = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    return _filterData;
}


- (void)clickFilterView:(FilterView *)view actionType:(FilterViewAction)action returnData:(NSDictionary *)data{
    [data.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [_filterData setObject:data[key] forKey:key];
    }];
    
    [_tableView headerBeginRefreshing];
}

- (NSArray*)sectionDatasForFilterView:(FilterView *)view{
    return _filterSections;
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": kOnePageCount}];
    [param addEntriesFromDictionary:self.filterData];
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_KNOWLEDGE_LIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            
            NSMutableArray *rows = [JRWiki buildUpWithValue:[data objectForKey:@"knowledgeList"]];
            
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = rows;
            }
            [_tableView reloadData];
        }
        _emptyView.hidden = _datas.count != 0;
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"WikiCell";
    WikiCell *cell = (WikiCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (WikiCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRWiki *wiki = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithWiki:wiki];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JRWebViewController *vc = [[JRWebViewController alloc] init];
    vc.title = @"家装百科";
    JRWiki *wiki = [_datas objectAtIndex:indexPath.row];
//    vc.htmlString = wiki.content;
    vc.urlString = [NSString stringWithFormat:@"http://apph5.juran.cn/wikis/%d", wiki.wikiId];
    wiki.browseCount++;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
