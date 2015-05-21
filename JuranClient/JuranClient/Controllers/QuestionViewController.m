//
//  QuestionViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "QuestionViewController.h"
#import "NewQuestionViewController.h"
#import "QuestionFilterView.h"
#import "JRQuestion.h"
#import "QuestionCell.h"
#import "QuestionDetailViewController.h"

@interface QuestionViewController ()<UITableViewDataSource, UITableViewDelegate, QuestionFilterViewDelegate, UIScrollViewDelegate>{
    CGFloat startOffsetY;
}

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) QuestionFilterView *filterView;
@property (nonatomic, strong) NSMutableDictionary *filterData;
@property (nonatomic, strong) QuestionCell *questionCell;
@property (nonatomic, strong) IBOutlet UIView *askView;

@property (nonatomic, strong) IBOutlet UIView *emptyView;

@end

@implementation QuestionViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataNotification:) name:kNotificationNameQuestionReloadData object:nil];
    
    if (!_isSearchResult) {
#ifdef kJuranDesigner
        self.navigationItem.title = @"问答";
#else
         self.navigationItem.title = @"答疑解惑";
#endif
        [self configureSearch];
    }else{
        self.navigationItem.title = @"搜索结果";
    }
    self.filterView = [[QuestionFilterView alloc] initWithDefaultData:_filterData];
    _filterView.delegate = self;
    [self.view addSubview:_filterView];
    
    
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, 44, kWindowWidth, (_isSearchResult?kWindowHeightWithoutNavigationBar:kWindowHeightWithoutNavigationBarAndTabbar) - 44) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    if (!_isSearchResult) {
        CGRect frame = _askView.frame;
        frame.origin.y = CGRectGetMaxY(_tableView.frame);
        _askView.frame = frame;
        [self.view addSubview:_askView];
    }
    
    _emptyView.hidden = YES;
    _emptyView.center = _tableView.center;
    [self.view addSubview:_emptyView];
    
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

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureMore];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_filterView isShow]) {
        [_filterView showSort];
    }
}

- (void)reloadDataNotification:(NSNotification*)notification{
    [_tableView headerBeginRefreshing];
}

- (NSMutableDictionary *)filterData{
    if (!_filterData) {
        _filterData = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                      @"questionType": @"",
                                                                      @"status": @""}];
    }
    return _filterData;
}

- (void)clickQuestionFilterView:(QuestionFilterView *)view returnData:(NSDictionary *)data{
    [data.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [_filterData setObject:data[key] forKey:key];
    }];
    
    [_tableView headerBeginRefreshing];
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": kOnePageCount}];
    if (_isSearchResult) {
        [param setObject:_searchKeyWord forKey:@"keyword"];
    }
    [param addEntriesFromDictionary:self.filterData];
    NSString *url = _isSearchResult?JR_SEARCH_QUESTION:JR_GET_QUESTIONLIST;
    [self showHUD];
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *designerList = [data objectForKey:@"questionList"];
            NSMutableArray *rows = [JRQuestion buildUpWithValue:designerList];
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

- (IBAction)doAsk:(id)sender{
    if (![self checkLogin:^{
    }]) {
        return;
    }
    NewQuestionViewController *vc = [[NewQuestionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"QuestionCell";
    QuestionCell *cell = (QuestionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (QuestionCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRQuestion *q = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithQuestion:q];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JRQuestion *q = [_datas objectAtIndex:indexPath.row];
    [self.questionCell fillCellWithQuestion:q];
    return self.questionCell.contentView.frame.size.height + ((indexPath.row == _datas.count - 1)?5:0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JRQuestion *q = [_datas objectAtIndex:indexPath.row];
    QuestionDetailViewController *vc = [[QuestionDetailViewController alloc] init];
    vc.question = q;
    vc.isResolved = [q isResolved];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QuestionCell*)questionCell{
    if (!_questionCell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QuestionCell" owner:self options:nil];
        _questionCell = (QuestionCell *)[nibs firstObject];
    }
    return _questionCell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    startOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0 && y < 44) {
        [scrollView setContentOffset:CGPointMake(0, startOffsetY > y ? 0 : 44) animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0 && y < 44) {
        [scrollView setContentOffset:CGPointMake(0, startOffsetY > y ? 0 : 44) animated:YES];
    }
}

@end
