//
//  SubjectDetailViewController.m
//  JuranClient
//
//  Created by Kowloon on 14/12/2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SubjectDetailViewController.h"
#import "CaseCell.h"
#import "JRSubject.h"
#import "JRCase.h"
#import "JRPhotoScrollViewController.h"
#import "ShareView.h"

@interface SubjectDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;

@end

@implementation SubjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBColor(236, 236, 236);
    [self.view addSubview:_tableView];
    
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"nav-icon-share"] rightBarButtonItemAction:@selector(onShare)];
    
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

- (void)onShare{
    [[ShareView sharedView] showWithContent:_subject.subjectContent image:[[Public imageURL:_subject.subjectUrl] absoluteString] title:_subject.subjectName url:@""];
}

- (void)loadData{
    NSDictionary *param = @{@"id": [NSString stringWithFormat:@"%d",_subject.key],
                            @"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": kOnePageCount};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SUBJECT_DETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSDictionary *info = [data objectForKey:@"infoSubjectDetailResp"];
            NSMutableArray *rows = [JRCase buildUpWithValue:[info objectForKey:@"projectGeneralDtoList"]];
            if (_currentPage == 1) {
                self.datas = rows;
                _subject.subjectName = [info objectForKey:@"subjectName"];
                _subject.subjectUrl = [info objectForKey:@"subjectUrl"];
                _subject.subjectContent = [info objectForKey:@"subjectContent"];
                self.navigationItem.title = _subject.subjectName;
                [_photoImageView setImageWithURLString:_subject.subjectUrl];
                _contentLabel.text = _subject.subjectContent;
                CGRect frame = _contentLabel.frame;
                frame.size.height = [_subject.subjectContent heightWithFont:_contentLabel.font constrainedToWidth:CGRectGetWidth(frame)];
                _contentLabel.frame = frame;
                frame = _headerView.frame;
                frame.size.height = CGRectGetMaxY(_contentLabel.frame) + 10;
                _headerView.frame = frame;
                self.tableView.tableHeaderView = _headerView;
                
            }else{
                [_datas addObjectsFromArray:rows];
            }
            
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [_datas count] - 1) {
        return 275;
    }
    
    return 270;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseCell";
    CaseCell *cell = (CaseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CaseCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRCase *c = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithCase:c];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JRCase *cs = [_datas objectAtIndex:indexPath.row];

    JRPhotoScrollViewController *vc = [[JRPhotoScrollViewController alloc] initWithJRCase:cs andStartWithPhotoAtIndex:0];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
