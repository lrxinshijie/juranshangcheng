//
//  InteractionViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "InteractionViewController.h"
#import "InteractionCell.h"
#import "JRPhotoScrollViewController.h"
#import "NewestTopicViewController.h"
#import "JRTopic.h"

@interface InteractionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *caseDatas;
@property (nonatomic, strong) NSMutableArray *topicDatas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;

@property (nonatomic, strong) IBOutlet UIView *emptyView;


@end

@implementation InteractionViewController

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
    
    self.navigationItem.title = @"互动管理";
    
    [self.view addSubview:_headView];
    
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame), kWindowWidth, kWindowHeightWithoutNavigationBar - CGRectGetMaxY(_headView.frame)) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    
    _emptyView.center = _tableView.center;
    _emptyView.hidden = YES;
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

- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": kOnePageCount};
    [self showHUD];
    NSString *url = _segment.selectedSegmentIndex == 0 ? JR_INTERACT_PROJECT : JR_INTERACT_TOPIC;
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if (_segment.selectedSegmentIndex == 0) {
                NSArray *datas = [data objectForKey:@"commentList"];
                if (_currentPage > 1) {
                    [_caseDatas addObjectsFromArray:datas];
                }else{
                    self.caseDatas = [NSMutableArray arrayWithArray:datas];
                }
            }else{
                NSArray *datas = [data objectForKey:@"commentList"];
                if (_currentPage > 1) {
                    [_topicDatas addObjectsFromArray:datas];
                }else{
                    self.topicDatas = [NSMutableArray arrayWithArray:datas];
                }
            }
            
            [self reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
}

- (void)reloadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        _emptyView.hidden = YES;
        [_tableView reloadData];
        if (_segment.selectedSegmentIndex == 0) {
            _emptyView.hidden = _caseDatas.count != 0;
        }else{
            _emptyView.hidden = _topicDatas.count != 0;
        }
    });
}

- (IBAction)segmentValueChange:(id)sender{
    self.navigationItem.title = _segment.selectedSegmentIndex == 0?@"互动管理":@"我的评论";
    _currentPage = 1;
    [self loadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _segment.selectedSegmentIndex == 0?_caseDatas.count:_topicDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedSegmentIndex == 0) {
        return 145 + (indexPath.row == (_caseDatas.count-1)?5:0);
    }else{
        return 145 + (indexPath.row == (_topicDatas.count-1)?5:0);
    }
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"InteractionCell";
    InteractionCell *cell = (InteractionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (InteractionCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_segment.selectedSegmentIndex == 0) {
        NSDictionary *q = _caseDatas[indexPath.row];
        [cell fillCellWithInteraction:q];
    }else{
        NSDictionary *q = _topicDatas[indexPath.row];
        [cell fillCellWithInteraction:q];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_segment.selectedSegmentIndex == 0) {
        NSDictionary *dict = [_caseDatas objectAtIndex:indexPath.row];
        JRCase *cs = [[JRCase alloc] init];
        cs.projectId = [dict getStringValueForKey:@"projectId" defaultValue:@""];
        JRPhotoScrollViewController *vc = [[JRPhotoScrollViewController alloc] initWithJRCase:cs andStartWithPhotoAtIndex:0];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSDictionary *dict = [_topicDatas objectAtIndex:indexPath.row];
        JRTopic *t = [[JRTopic alloc] init];
        t.topicId = [dict getStringValueForKey:@"topicId" defaultValue:@""];
        t.theme = [dict getStringValueForKey:@"topicTitle" defaultValue:@""];
        NewestTopicViewController *vc = [[NewestTopicViewController alloc] init];
        vc.topic = t;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
