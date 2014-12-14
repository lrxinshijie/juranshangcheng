//
//  FilterViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/7.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *rows;

- (IBAction)onDone:(id)sender;

@end

@implementation FilterViewController

- (void)dealloc{
    _tableView.delegate = nil; _tableView.dataSource = nil; _tableView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"筛选";
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 50, 30) target:self action:@selector(onCancel) title:@"取消" backgroundImage:nil];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.rows[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
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
    cell.textLabel.text = self.rows[indexPath.section][indexPath.row][@"k"];
    NSString *k = _sections[indexPath.section][@"v"];
    NSString *v = [_selecteds objectForKey:k];
    if ([v isEqualToString:self.rows[indexPath.section][indexPath.row][@"v"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *v = self.rows[indexPath.section][indexPath.row][@"v"];
    NSString *k = self.sections[indexPath.section][@"v"];
    if ([v isEqualToString:[_selecteds objectForKey:k]]) {
        v = @"";
    }
    
    [_selecteds setObject:v forKey:k];
    [_tableView reloadData];
}

- (void)onCancel{
    [super back:nil];
}

- (IBAction)onDone:(id)sender{
    
    if ([_delegate respondsToSelector:@selector(clickFilterViewReturnData:)]) {
        [_delegate clickFilterViewReturnData:_selecteds];
    }
    
    [super back:nil];
}

#pragma mark - DataSource
- (NSArray *)sections{
    if (!_sections) {
        if (_type == FilterViewTypeCase) {
            _sections = @[CELLDICTIONARYBUILT(@"擅长风格", @"style"),
                          CELLDICTIONARYBUILT(@"户型", @"roomType"),
                          CELLDICTIONARYBUILT(@"面积", @"houseArea")];
        }else if (_type == FilterViewTypeDesigner) {
            _sections = @[CELLDICTIONARYBUILT(@"擅长风格", @"style"),
                          CELLDICTIONARYBUILT(@"从业年限", @"experience"),
                          CELLDICTIONARYBUILT(@"实名认证", @"isRealNameAuth"),
                          CELLDICTIONARYBUILT(@"设计师称号", @"levelCode")
                          ];
        }else if (_type == FilterViewTypeQuestion){
            _sections = @[CELLDICTIONARYBUILT(@"问题分类", @"questionType"),
                          CELLDICTIONARYBUILT(@"是否回答", @"status")
                          ];
        }
        
    }
    
    return _sections;
}

- (NSArray *)rows{
    if (!_rows) {
        if (_type == FilterViewTypeCase) {
            _rows = @[
                      @[@{@"k":@"混搭",@"v":@"mashup"},
                        @{@"k":@"欧式",@"v":@"european"},
                        @{@"k":@"混搭",@"v":@"mashup"},
                        @{@"k":@"中式",@"v":@"chinese"},
                        @{@"k":@"新古典",@"v":@"newClassical"},
                        @{@"k":@"东南亚",@"v":@"eastSourthAsia"},
                        @{@"k":@"美式",@"v":@"america"},
                        @{@"k":@"田园",@"v":@"countryside"},
                        @{@"k":@"地中海",@"v":@"mediterranean"},
                        @{@"k":@"韩式",@"v":@"kora"},
                        @{@"k":@"日式",@"v":@"japanese"},
                        @{@"k":@"现代",@"v":@"modern"},
                        @{@"k":@"其他",@"v":@"other"}],
                      @[@{@"k":@"一室",@"v":@"1"},
                        @{@"k":@"两室",@"v":@"2"},
                        @{@"k":@"三室",@"v":@"3"},
                        @{@"k":@"四室",@"v":@"4"},
                        @{@"k":@"五室",@"v":@"5"},
                        @{@"k":@"LOFT",@"v":@"loft"},
                        @{@"k":@"别墅",@"v":@"villadom"},
                        @{@"k":@"其他",@"v":@"other"},
                        @{@"k":@"小户型",@"v":@"little"}],
                      @[@{@"k":@"60m2以下",@"v":@"AREA_0"},
                        @{@"k":@"60-80m2",@"v":@"AREA_60"},
                        @{@"k":@"80-120m2",@"v":@"AREA_80"},
                        @{@"k":@"120m2以上",@"v":@"AREA_120"}]
                      ];
        }else if (_type == FilterViewTypeDesigner){
            _rows = @[@[@{@"k":@"混搭",@"v":@"mashup"},
                        @{@"k":@"欧式",@"v":@"european"},
                        @{@"k":@"中式",@"v":@"chinese"},
                        @{@"k":@"新古典",@"v":@"newClassical"},
                        @{@"k":@"东南亚",@"v":@"eastSourthAsia"},
                        @{@"k":@"美式",@"v":@"america"},
                        @{@"k":@"田园",@"v":@"countryside"},
                        @{@"k":@"地中海",@"v":@"mediterranean"},
                        @{@"k":@"韩式",@"v":@"kora"},
                        @{@"k":@"日式",@"v":@"japanese"},
                        @{@"k":@"现代",@"v":@"modern"},
                        @{@"k":@"其他",@"v":@"other"},],
                      @[@{@"k":@"2年以下",@"v":@"0,2"},
                      @{@"k":@"2-5年",@"v":@"2,5"},
                      @{@"k":@"6-10年",@"v":@"6,10"},
                        @{@"k":@"10年以上",@"v":@"10"}],
                      @[@{@"k":@"已实名认证",@"v":@"auth"},
                        @{@"k":@"未实名认证",@"v":@"unauth"}],
                      @[@{@"k":@"优秀",@"v":@"design_one"},
                        @{@"k":@"普通",@"v":@"design_two"},
                        @{@"k":@"资深",@"v":@"design_three"},
                        @{@"k":@"首席",@"v":@"design_four"},
                        @{@"k":@"主任",@"v":@"design_five"},
                        ]
                      ];
        }else if (_type == FilterViewTypeQuestion){
            _rows = @[@[@{@"k":@"账户管理",@"v":@"account"},
                        @{@"k":@"设计疑惑",@"v":@"design"},
                        @{@"k":@"装修前后",@"v":@"decoration"},
                        @{@"k":@"商品选购",@"v":@"goods"},
                        @{@"k":@"DIY工具使用困境",@"v":@"diy"},
                        @{@"k":@"其他",@"v":@"other"}],
                      @[@{@"k":@"默认",@"v":@""},
                        @{@"k":@"未解决",@"v":@"unresolved"},
                        @{@"k":@"已解决",@"v":@"resolved"}]
                      ];
        }
        
    }
    return _rows;
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
