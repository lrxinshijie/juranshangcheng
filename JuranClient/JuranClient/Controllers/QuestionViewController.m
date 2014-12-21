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

@interface QuestionViewController ()<UITableViewDataSource, UITableViewDelegate, QuestionFilterViewDelegate, NewQuestionViewControllerDelegate, QuestionDetailViewControllerDelegate>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) QuestionFilterView *filterView;
@property (nonatomic, strong) NSMutableDictionary *filterData;
@property (nonatomic, strong) QuestionCell *questionCell;
@property (nonatomic, strong) IBOutlet UIView *askView;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    if (!_isSearchResult) {
        self.navigationItem.title = @"答疑解惑";
        [self configureSearch];
    }else{
        self.navigationItem.title = _searchKeyWord;
    }
    
    self.tableView = [self.view tableViewWithFrame:_isSearchResult? kContentFrameWithoutNavigationBar:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
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
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    self.filterView = [[QuestionFilterView alloc] initWithDefaultData:_filterData];
    _filterView.delegate = self;
    _tableView.tableHeaderView = _filterView;
    
    [_tableView headerBeginRefreshing];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_filterView isShow]) {
        [_filterView showSort];
    }
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
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        if (_currentPage == 1) {
            _tableView.contentOffset = CGPointMake(0, CGRectGetHeight(_filterView.frame));
        }
        
    }];
    
}

- (IBAction)doAsk:(id)sender{
    NewQuestionViewController *vc = [[NewQuestionViewController alloc] init];
    vc.delegate = self;
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
    vc.delegate = self;
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

#pragma mark - NewQuestionViewControllerDelegate

- (void)newQuestionViewController:(NewQuestionViewController *)vc{
    [_tableView headerBeginRefreshing];
}

#pragma mark - QuestionDetailViewControllerDelegate

- (void)valueChangedWithQuestionDetailViewController:(QuestionDetailViewController *)vc{
    [_tableView headerBeginRefreshing];
}

@end
