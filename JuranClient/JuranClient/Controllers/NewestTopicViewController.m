//
//  NewestTopicViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "NewestTopicViewController.h"
#import "CommentCell.h"
#import "JRTopic.h"
#import "JRComment.h"

@interface NewestTopicViewController ()<UITableViewDataSource, UITableViewDelegate, CommentCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JRTopic *topic;

@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *viewCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentCountLabel;

@end

@implementation NewestTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"最新话题";
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [self reloadData];
}

- (void)loadData{
    
}

- (void)reloadData{
    [self setupTableHeaderView];
    _tableView.tableHeaderView = _tableHeaderView;
    [_tableView reloadData];
}

- (void)setupTableHeaderView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JRComment *comment = [_topic.commitList objectAtIndex:indexPath.row];
    NSString *content = comment.commentContent;
    CGFloat height = [content heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:290];
    
    if (comment.replyList.count > 0) {
        CGFloat replyHeight = 25;
        if (comment.unfold) {
            replyHeight = 35;
            for (JRComment *reply in comment.replyList) {
                NSString *name = [NSString stringWithFormat:@"%@：", reply.nickName];
                NSString *content = [NSString stringWithFormat:@"%@%@", name, reply.replyContent];
                replyHeight += [content heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:290];
                replyHeight += 30;
            }
        }
        height += replyHeight;
    }
    
    
    return 73+height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    JRComment *commnet = [_topic.commitList objectAtIndex:indexPath.row];
    [cell fillCellWithComment:commnet];
    
    return cell;
}


@end
