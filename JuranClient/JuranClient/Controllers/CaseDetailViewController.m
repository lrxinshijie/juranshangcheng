//
//  CaseDetailViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "JRCase.h"
#import "DesignerCell.h"
#import "JRDesigner.h"

@interface CaseDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) JRDesigner *designer;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation CaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"方案描述";
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"nav-icon-share"] rightBarButtonItemAction:@selector(onShare)];
    
    self.keys = @[@"地区", @"楼盘", @"户型", @"风格", @"面积", @"参考", @"描述"];
    self.values = @[@"地区", @"楼盘", @"户型", @"风格", @"面积", @"参考", @"描述"];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    [self.view addSubview:_tableView];
    
    self.currentPage = 1;
    
    [self loadData];
}

- (void)loadData{
    NSDictionary *param = @{@"proejctId": _jrCase.projectId,
                            @"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": @"20"};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_CASE_COMMENT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *projectList = [data objectForKey:@"projectList"];
            NSMutableArray *rows = [JRCase buildUpWithValue:projectList];
            if (_currentPage > 1) {
                [_comments addObjectsFromArray:rows];
            }else{
                self.comments = [JRCase buildUpWithValue:projectList];
            }
            
            
        }
        [_tableView reloadData];
//        [_tableView headerEndRefreshing];
//        [_tableView footerEndRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return [_keys count];
    }else{
        return [_comments count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130;
    }else if (indexPath.section == 1){
        return 44;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"DesignerCell";
        DesignerCell *cell = (DesignerCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (DesignerCell *)[nibs firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell fillCellWithDesigner:_designer];
        return cell;
        
    }else if (indexPath.section == 1){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        cell.textLabel.text = [_keys objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_values objectAtIndex:indexPath.row];
//        cell.contentView.
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        return cell;
    }
    
    return nil;
}

- (void)onShare{
    
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
