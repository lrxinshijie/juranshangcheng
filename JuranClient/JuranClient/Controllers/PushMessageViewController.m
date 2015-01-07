//
//  PushMessageViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PushMessageViewController.h"
#import "JRPushInfoMsg.h"
#import "PushMessageCell.h"
#import "PushMsgDetailViewController.h"

@interface PushMessageViewController ()<UITableViewDataSource, UITableViewDelegate, PushMessageCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) PushMessageCell *msgCell;

@property (nonatomic, strong) IBOutlet UIView *emptyView;

@end

@implementation PushMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"系统消息";
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(setAllReaded:) title:@"全部已读" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
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

- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": kOnePageCount};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_MSG_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *list = [data objectForKey:@"webMessageList"];
            NSMutableArray *rows = [JRPushInfoMsg buildUpWithValue:list];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                
                self.datas = [JRPushInfoMsg buildUpWithValue:list];
            }
            
            [_tableView reloadData];
        }
        _emptyView.hidden = _datas.count != 0;
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
    
//    _datas = [NSMutableArray array];
//    for (NSInteger i = 0; i < 4; i++) {
//        JRPushInfoMsg *msg = [[JRPushInfoMsg alloc] init];
//        msg.isUnread = YES;
//        msg.gmtCreate = @"2014-09-20";
//        msg.msgTitle = @"了深刻的减肥了快速的减肥了空间受到了空间罚款了数据的";
//        msg.msgAbstract = @"地方可接受接受了顺路收到了放假了快速减肥了就是浪费快递解放路口设计的法律框架上来看对方就两款手机的弗兰克对方就两款手机的法律框架上来的快放假快乐暑假的开发监考老师的减肥接受了顺路收到了放假了快速减肥了就是浪费快递解放路口设计的法律框架上来看对方就两款手机的弗兰克对方就两款手机的法律框架上来的快放假快乐暑假的开发监考老师的减肥接受了顺路收到了放假了快速减肥了就是浪费快递解放路口设计的法律框架上来看对方就两款手机的弗兰克对方就两款手机的法律框架上来的快放假快乐暑假的开发监考老师的减肥接受了顺路收到了放假了快速减肥了就是浪费快递解放路口设计的法律框架上来看对方就两款手机的弗兰克对方就两款手机的法律框架上来的快放假快乐暑假的开发监考老师的减肥了顺路收到了放假了快速减肥了就是浪费快递解放路口设计的法律框架上来看对方就两款手机的弗兰克对方就两款手机的法律框架上来的快放假快乐暑假的开发监考老师的减肥";
//        [_datas addObject:msg];
//    }
//    [_tableView reloadData];
}

- (void)setAllReaded:(id)sender{
    [self submitReadMsg:nil];
}

- (void)submitReadMsg:(JRPushInfoMsg*)msg{
    NSDictionary *param = nil;
    if (msg) {
        param = @{@"msgId": [NSString stringWithFormat:@"%d", msg.msgId]};
    }
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SET_MSG_READ parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if (msg) {
                msg.isUnread = NO;
            }else{
                for (JRPushInfoMsg *msg in _datas) {
                    msg.isUnread = NO;
                }
            }
            [_tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JRPushInfoMsg *msg = _datas[indexPath.row];
    [self.msgCell fillCellWithMsg:msg];
    return self.msgCell.frame.size.height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PushMessageCell";
    PushMessageCell *cell = (PushMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (PushMessageCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    JRPushInfoMsg *msg = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithMsg:msg];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_datas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (PushMessageCell*)msgCell{
    if (!_msgCell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"PushMessageCell" owner:self options:nil];
        _msgCell = (PushMessageCell *)[nibs firstObject];
    }
    return _msgCell;
}

#pragma mark - PushMessageCellDelegate

- (void)changeCellExpand:(PushMessageCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    JRPushInfoMsg *msg = _datas[indexPath.row];
    if (msg.isUnread) {
        [self submitReadMsg:msg];
    }
}

- (void)didSelectedDetail:(PushMessageCell *)cell andPushMsg:(JRPushInfoMsg *)msg{
    PushMsgDetailViewController *vc = [[PushMsgDetailViewController alloc] init];
    vc.pushInfo = msg;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
