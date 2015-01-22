//
//  CaseEditStyleViewController.m
//  JuranClient
//
//  Created by Kowloon on 15/1/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CaseEditStyleViewController.h"
#import "ALGetPhoto.h"
#import "JRCaseImage.h"

@interface CaseEditStyleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sections;

@end

@implementation CaseEditStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"案例图片管理";
    
    if (!_caseImage) {
        self.caseImage = [[JRCaseImage alloc] init];
    }
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onAdd) title:_caseImage.image || _caseImage.imageUrl.length > 0 ? @"完成" : @"下一步" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *k = self.sections[section][@"v"];
    NSArray *rows = [[DefaultData sharedData] objectForKey:k];
    return [rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    headerView.backgroundColor = RGBColor(202, 202, 202);
    UILabel *titleLabel = [headerView labelWithFrame:CGRectMake(10, 0, 300, 30) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    titleLabel.text = [self.sections[section] objectForKey:@"k"];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    NSString *k = _sections[indexPath.section][@"v"];
    NSArray *rows = [[DefaultData sharedData] objectForKey:k];
    cell.textLabel.text = rows[indexPath.row][@"k"];
    
    NSString *v = indexPath.section == 0 ? _caseImage.picType : _caseImage.picRoom;
    
    if ([v isEqualToString:rows[indexPath.row][@"v"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *k = self.sections[indexPath.section][@"v"];
    NSArray *rows = [[DefaultData sharedData] objectForKey:k];
    NSString *v = rows[indexPath.row][@"v"];
    
    if (indexPath.section == 0) {
        _caseImage.picType = v;
    }else{
        _caseImage.picRoom = v;
    }
    
    [_tableView reloadData];
}

- (NSArray *)sections{
    if (!_sections) {
        _sections = @[@{@"k":@"图片类型",@"v":@"picType"},
  @{@"k":@"空间类型",@"v":@"projectRoom"}];
    }
    
    return _sections;
}

- (void)onAdd{
    if (_caseImage.image || _caseImage.imageUrl.length > 0) {
        if (_block) {
            _block(_caseImage);
        }
        
        [super back:nil];
    }else{
        [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
            UIImage *image = [images firstObject];
            _caseImage.image = image;
            if (_block) {
                _block(_caseImage);
            }
            
            [super back:nil];
        }];
    }
    
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
