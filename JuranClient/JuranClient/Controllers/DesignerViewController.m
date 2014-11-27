//
//  DesignerViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DesignerViewController.h"
#import "DesignerDetailViewController.h"
#import "DesignerCell.h"
#import "JRDesigner.h"

@interface DesignerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation DesignerViewController

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
    
    self.navigationItem.title = @"设计师";
    
    _tableView.tableFooterView = [[UIView alloc] init];
    [self loadData];
    
}

- (void)loadData{
    _datas = [NSMutableArray array];
    for (NSInteger i = 0; i < 6; i++) {
        [_datas addObject:[[JRDesigner alloc] init]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DesignerCell";
    DesignerCell *cell = (DesignerCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (DesignerCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRDesigner *c = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithDesigner:c];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
    detailVC.designer = _datas[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
