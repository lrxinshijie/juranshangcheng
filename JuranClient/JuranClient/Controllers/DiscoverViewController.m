//
//  DiscoverViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "DiscoverViewController.h"
#import "JRSegmentControl.h"

#import "NewQuestionViewController.h"
#import "QuestionFilterView.h"
#import "JRQuestion.h"
#import "QuestionCell.h"
#import "QuestionDetailViewController.h"

#import "WikiFilterViewController.h"
#import "WikiDetailViewController.h"
#import "JRWiki.h"
#import "WikiCell.h"

@interface DiscoverViewController ()<JRSegmentControlDelegate,UITableViewDataSource, UITableViewDelegate, QuestionFilterViewDelegate, WikiFilterViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) IBOutlet JRSegmentControl *segment;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *wikiFilterData;
@property (nonatomic, strong) UINavigationController *wikiFilterViewNav;

@property (nonatomic, strong) QuestionFilterView *quesgtionFilterView;
@property (nonatomic, strong) NSMutableDictionary *questionFilterData;
@property (nonatomic, strong) QuestionCell *questionCell;
@property (nonatomic, strong) IBOutlet UIView *questionHeaderView;


@property (nonatomic, strong) IBOutlet UIView *emptyView;

@end

@implementation DiscoverViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"发现";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveReloadNotification:) name:kNotificationNameQuestionReloadData object:nil];
    
    [self configureSearchAndMore];
    
    [self setupUI];
    
    [_tableView headerBeginRefreshing];
}

- (void)setupUI{
    [_segment setTitleList:@[@"专题", @"百科", @"问答", @"话题"]];
    _segment.delegate = self;
    
    self.quesgtionFilterView = [[QuestionFilterView alloc] initWithDefaultData:self.questionFilterData];
    _quesgtionFilterView.delegate = self;
    [_questionHeaderView addSubview:_quesgtionFilterView];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    _emptyView.hidden = YES;
    _emptyView.center = _tableView.center;
    [self.view addSubview:_emptyView];
}

- (void)recieveReloadNotification:(NSNotification*)noti{
    
}

- (void)reloadData{
    [_tableView reloadData];
    _emptyView.hidden = _datas.count != 0;
}

- (NSString *)urlString{
    if (_segment.selectedIndex == 0) {
        
    }else if (_segment.selectedIndex == 1){
        return JR_GET_KNOWLEDGE_LIST;
    }else if (_segment.selectedIndex == 2){
        return JR_GET_QUESTIONLIST;
    }else if (_segment.selectedIndex == 3){
        
    }
    return @"";
}

- (NSDictionary*)filterData{
    if (_segment.selectedIndex == 0) {
        
    }else if (_segment.selectedIndex == 1){
        return self.wikiFilterData;
    }else if (_segment.selectedIndex == 2){
        return self.questionFilterData;
    }else if (_segment.selectedIndex == 3){
        
    }
    return @{};
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": kOnePageCount}];
    [param addEntriesFromDictionary:[self filterData]];
    [self showHUD];
    [[ALEngine shareEngine] pathURL:[self urlString] parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSMutableArray *rows = nil;
            if (_segment.selectedIndex == 0) {
                
            }else if (_segment.selectedIndex == 1){
                rows = [JRWiki buildUpWithValue:[data objectForKey:@"knowledgeList"]];
            }else if (_segment.selectedIndex == 2){
                rows = [JRQuestion buildUpWithValue:[data objectForKey:@"questionList"]];
            }else if (_segment.selectedIndex == 3){
                
            }
            
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = rows;
            }
            
            [self reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

#pragma mark - JRSegmentControlDelegate

- (void)segmentControl:(JRSegmentControl *)segment changedSelectedIndex:(NSInteger)index{
    if (_datas) {
        [_datas removeAllObjects];
        [_tableView reloadData];
    }
    if (index == 0) {
        
    }else if (index == 1){
        _tableView.tableHeaderView = nil;
    }else if (index == 2){
        _tableView.tableHeaderView = _questionHeaderView;
        
    }else if (index == 3){
        
    }
    [_tableView headerBeginRefreshing];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedIndex == 0) {
        
    }else if (_segment.selectedIndex == 1){
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
    }else if (_segment.selectedIndex == 2){
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
    }else if (_segment.selectedIndex == 3){
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedIndex == 0) {
        
    }else if (_segment.selectedIndex == 1){
        return 80;
    }else if (_segment.selectedIndex == 2){
        JRQuestion *q = [_datas objectAtIndex:indexPath.row];
        [self.questionCell fillCellWithQuestion:q];
        return self.questionCell.contentView.frame.size.height + ((indexPath.row == _datas.count - 1)?5:0);
    }else if (_segment.selectedIndex == 3){
        
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedIndex == 0) {
        
    }else if (_segment.selectedIndex == 1){
        WikiDetailViewController *vc = [[WikiDetailViewController alloc] init];
        JRWiki *wiki = [_datas objectAtIndex:indexPath.row];
        vc.wiki = wiki;
        wiki.browseCount++;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_segment.selectedIndex == 2){
        JRQuestion *q = [_datas objectAtIndex:indexPath.row];
        QuestionDetailViewController *vc = [[QuestionDetailViewController alloc] init];
        vc.question = q;
        vc.hidesBottomBarWhenPushed = YES;
        vc.isResolved = [q isResolved];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_segment.selectedIndex == 3){
        
    }
    
}

#pragma mark - Target Action

- (IBAction)onAsk:(id)sender{
    if (![self checkLogin:^{
    }]) {
        return;
    }
    NewQuestionViewController *vc = [[NewQuestionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WikiFilterViewDelegate

- (void)clickWikiFilterViewReturnData:(NSDictionary *)data{
    [data.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [_wikiFilterData setObject:data[key] forKey:key];
    }];
    
    [_tableView headerBeginRefreshing];
}

#pragma mark - QuestionFilterViewDelegate

- (void)clickQuestionFilterView:(QuestionFilterView *)view returnData:(NSDictionary *)data{
    [data.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [_questionFilterData setObject:data[key] forKey:key];
    }];
    
    [_tableView headerBeginRefreshing];
}

#pragma mark - Set/Get

- (NSMutableDictionary *)questionFilterData{
    if (!_questionFilterData) {
        _questionFilterData = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                      @"questionType": @"",
                                                                      @"status": @""}];
    }
    return _questionFilterData;
}

- (NSMutableDictionary *)wikiFilterData{
    if (!_wikiFilterData) {
        
        NSDictionary *param = [[DefaultData sharedData] objectForKey:@"wikiDefaultParam"];
        _wikiFilterData = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    return _wikiFilterData;
}

- (QuestionCell*)questionCell{
    if (!_questionCell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QuestionCell" owner:self options:nil];
        _questionCell = (QuestionCell *)[nibs firstObject];
    }
    return _questionCell;
}

- (UINavigationController*)wikiFilterViewNav{
    if (!_wikiFilterViewNav) {
        WikiFilterViewController *filterViewController = [[WikiFilterViewController alloc] init];
        filterViewController.delegate = self;
        
        //            filterViewController.selecteds = [NSMutableDictionary dictionaryWithDictionary:_defaultData];
        _wikiFilterViewNav = [Public navigationControllerFromRootViewController:filterViewController];
    }
    return _wikiFilterViewNav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
