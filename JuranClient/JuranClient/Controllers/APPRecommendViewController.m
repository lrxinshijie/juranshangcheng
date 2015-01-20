//
//  APPRecommendViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-16.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "APPRecommendViewController.h"

@interface APPRecommendViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation APPRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"其他APP推荐";
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [self.view addSubview:_tableView];
//    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    
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
#ifdef kJuranDesigner
    NSString *scope = @"2";
#else
    NSString *scope = @"1";
#endif
    NSDictionary *param = @{@"type": @"IOS",
                            @"appScope": scope,
                            @"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": kOnePageCount};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_OTHER_APP parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"No"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSMutableArray *rows = [NSMutableArray arrayWithArray:[data objectForKey:@"otherAppRespList"]];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = rows;
            }
            
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AppRecommendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 15.f;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    }
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellIndicator.png"]];
    NSDictionary *dict = _datas[indexPath.row];
    
    [cell.imageView setImageWithURLString:@"img/54b49ba9ed50bbb025bcfbad.img"];//[dict getStringValueForKey:@"image" defaultValue:@""]
    cell.textLabel.text = [dict getStringValueForKey:@"name" defaultValue:@""];
    cell.detailTextLabel.text = [dict getStringValueForKey:@"memo" defaultValue:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = _datas[indexPath.row];
    NSString *url = [dict getStringValueForKey:@"url" defaultValue:@""];
    if (url.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
