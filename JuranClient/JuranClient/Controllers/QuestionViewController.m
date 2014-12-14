//
//  QuestionViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "QuestionViewController.h"
#import "NewQuestionViewController.h"
#import "FilterView.h"
#import "JRQuestion.h"
#import "QuestionCell.h"
#import "QuestionDetailViewController.h"

@interface QuestionViewController ()<UITableViewDataSource, UITableViewDelegate, FilterViewDelegate>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) NSMutableDictionary *filterData;
@property (nonatomic, strong) QuestionCell *questionCell;
@property (nonatomic, strong) IBOutlet UIView *askView;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"答疑解惑";
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    CGRect frame = _askView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _askView.frame = frame;
    [self.view addSubview:_askView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    self.filterView = [[FilterView alloc] initWithType:FilterViewTypeQuestion defaultData:_filterData];
    _filterView.delegate = self;
    _tableView.tableHeaderView = _filterView;
    
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

- (void)clickFilterView:(FilterView *)view actionType:(FilterViewAction)action returnData:(NSDictionary *)data{
    [data.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [_filterData setObject:data[key] forKey:key];
    }];
    
    [_tableView headerBeginRefreshing];
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": @"10"}];
    [param addEntriesFromDictionary:self.filterData];
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_QUESTIONLIST parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *designerList = [data objectForKey:@"questionList"];
            NSMutableArray *rows = [JRQuestion buildUpWithValue:designerList];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = [JRQuestion buildUpWithValue:designerList];
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
    return self.questionCell.contentView.frame.size.height;
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

@end
