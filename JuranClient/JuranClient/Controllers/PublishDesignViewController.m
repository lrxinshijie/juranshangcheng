//
//  PublishDesignViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PublishDesignViewController.h"
#import "JRDemand.h"
#import "JRAreaInfo.h"
#import "BaseAddressViewController.h"
#import "DemandEditTextViewController.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetMultiPicker.h"
#import "ALGetPhoto.h"
#import "MyDemandViewController.h"

@interface PublishDesignViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) JRDemand *demand;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) UIImage *fileImage;
@property (nonatomic, strong) NSString *fileImageURL;


@end

@implementation PublishDesignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"需求发布";
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSubmit) title:@"确认发布" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 12, 60, 45)];
    _photoImageView.image = [UIImage imageNamed:@"publish_image_default"];
    
    self.keys = @[@"姓名",@"联系电话",@"房屋类型",@"装修预算",@"房屋面积",@"风格",@"项目地址",@"小区名称",@"户型",@"户型图上传"];
    self.values = @[@"请填写您的姓名",@"必须是11位数字",@"两居室", @"必须是整数",@"必须是数字(平方米)",@"地中海",@"石家庄",@"2-32个汉字",@"三室一厅一卫",@"可选"];
    self.demand = [[JRDemand alloc] init];
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = _headerView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData{
    self.values = @[_demand.contactsName,_demand.contactsMobile, _demand.houseTypeString, _demand.budget,_demand.houseArea == 0 ? @"" : [NSString stringWithFormat:@"%d",_demand.houseArea],_demand.renovationStyleString,_demand.areaInfo.title,_demand.neighbourhoods,_demand.roomNumString,@"可选"];
    
    if (_fileImage) {
        _photoImageView.image = _fileImage;
    }
    
    [_tableView reloadData];
}

- (void)onSubmit{
    if (![self checkLogin]) {
        return;
    }
    
    if (_demand.contactsName.length == 0) {
        [self showTip:@"姓名不能为空"];
        return;
    }
    
    if (_demand.contactsMobile.length == 0) {
        [self showTip:@"联系电话不能为空"];
        return;
    }
    
    if (_demand.houseType.length == 0) {
        [self showTip:@"房室类型不能为空"];
        return;
    }
    
    if (_demand.budget.length == 0) {
        [self showTip:@"装修预算不能为空"];
        return;
    }
    
    if (_demand.houseArea == 0) {
        [self showTip:@"房屋面积不能为空"];
        return;
    }
    
    if (_demand.renovationStyle.length == 0) {
        [self showTip:@"风格不能为空"];
        return;
    }
    
    if (_demand.areaInfo.cityCode.length == 0) {
        [self showTip:@"项目地址不能为空"];
        return;
    }
    
    if (_demand.neighbourhoods.length == 0) {
        [self showTip:@"小区名称不能为空"];
        return;
    }
    
    if (_demand.roomNumString.length == 0) {
        [self showTip:@"户型名称不能为空"];
        return;
    }
    
    [self showHUD];
    
    if (_fileImage) {
        [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":_fileImage} responseHandler:^(NSError *error, id data, NSDictionary *other) {
            if (!error) {
                _demand.roomTypeImgUrl = [data objectForKey:@"imgUrl"];
                [self submitDemand];
            }
        }];
    }else{
        [self submitDemand];
    }
    
}

- (void)submitDemand{
    NSDictionary *param = @{@"contactsName": _demand.contactsName,
                            @"houseType": _demand.houseType,
                            @"contactsMobile": _demand.contactsMobile,
                            @"houseArea": [NSString stringWithFormat:@"%d", _demand.houseArea],
                            @"budget": _demand.budget,
                            @"budgetUnit": @"million",
                            @"renovationStyle": _demand.renovationStyle,
                            @"neighbourhoods": _demand.neighbourhoods,
                            @"roomNum":_demand.roomNum,
                            @"livingroomCount":_demand.livingroomCount,
                            @"bathroomCount":_demand.bathroomCount,
                            @"areaInfo": [_demand.areaInfo dictionaryValue],
                            @"roomTypeImgUrl": _demand.roomTypeImgUrl
                            };

    [[ALEngine shareEngine] pathURL:JR_PUBLISH_DESIGN parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self showTip:@"发布需求成功"];
            self.demand = [[JRDemand alloc] init];
            self.fileImage = nil;
            _photoImageView.image = [UIImage imageNamed:@"publish_image_default"];
            [self reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MyDemandViewController *vc = [[MyDemandViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_keys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 9) {
        return 70;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == [_keys count]-1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ImageCell"];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = [_keys objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_values objectAtIndex:indexPath.row];
    if (indexPath.row == 9) {
        [_photoImageView removeFromSuperview];
        [cell addSubview:_photoImageView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 6) {
        BaseAddressViewController *vc = [[BaseAddressViewController alloc] init];
        [vc setAreaInfo:_demand.areaInfo andAddressSelected:^(id data) {
            
        }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7){
        DemandEditTextViewController *vc = [[DemandEditTextViewController alloc] init];
        vc.demand = _demand;
        vc.editType = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2 || indexPath.row == 5){
        NSMutableArray *rows = [NSMutableArray array];
        __block NSInteger ind = 0;
        if (indexPath.row == 2) {
            NSArray *houseType = [[DefaultData sharedData] houseType];
            [houseType enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
                [rows addObject:[row objectForKey:@"k"]];
                if ([[row objectForKey:@"v"] isEqualToString:_demand.houseType]) {
                    ind = idx;
                }
            }];
        }else if (indexPath.row == 5){
            NSArray *renovationStyle = [[DefaultData sharedData] renovationStyle];
            [renovationStyle enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
                [rows addObject:[row objectForKey:@"k"]];
                if ([[row objectForKey:@"v"] isEqualToString:_demand.renovationStyle]) {
                    ind = idx;
                }
            }];
        }
        
        [ActionSheetStringPicker showPickerWithTitle:nil rows:rows initialSelection:ind doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            if (indexPath.row == 2) {
                NSArray *houseType = [[DefaultData sharedData] houseType];
                _demand.houseType = [[houseType objectAtIndex:selectedIndex] objectForKey:@"v"];
            }else if (indexPath.row == 5){
                NSArray *renovationStyle = [[DefaultData sharedData] renovationStyle];
                _demand.renovationStyle = [[renovationStyle objectAtIndex:selectedIndex] objectForKey:@"v"];
            }
            
            
            [self reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:[UIApplication sharedApplication].keyWindow];
    }else if (indexPath.row == 8){
        NSMutableArray *rows = [NSMutableArray array];
        NSMutableArray *selects = [NSMutableArray array];
        
        NSMutableArray *datas = [NSMutableArray array];
        __block NSInteger ind = 0;
        NSArray *roomNum = [[DefaultData sharedData] roomNum];
        [roomNum enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [datas addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_demand.roomNum]) {
                ind = idx;
            }
        }];
        [rows addObject:datas];
        [selects addObject:@(ind)];
        
        ind = 0;
        NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
        datas = [NSMutableArray array];
        [livingroomCount enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [datas addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_demand.livingroomCount]) {
                ind = idx;
            }
        }];
        [rows addObject:datas];
        [selects addObject:@(ind)];
        
        ind = 0;
        NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
        datas = [NSMutableArray array];
        [bathroomCount enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
            [datas addObject:[row objectForKey:@"k"]];
            if ([[row objectForKey:@"v"] isEqualToString:_demand.bathroomCount]) {
                ind = idx;
            }
        }];
        [rows addObject:datas];
        [selects addObject:@(ind)];
        
        [ActionSheetMultiPicker showPickerWithTitle:nil rows:rows initialSelection:selects doneBlock:^(ActionSheetMultiPicker *picker, NSArray *selectedIndexs, NSArray *selectedValues) {
            NSArray *roomNum = [[DefaultData sharedData] roomNum];
            _demand.roomNum = [[roomNum objectAtIndex:[selectedIndexs[0] integerValue]] objectForKey:@"v"];
            
            NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
            _demand.livingroomCount = [[livingroomCount objectAtIndex:[selectedIndexs[1] integerValue]] objectForKey:@"v"];
            
            NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
            _demand.bathroomCount = [[bathroomCount objectAtIndex:[selectedIndexs[2] integerValue]] objectForKey:@"v"];
            
            [self reloadData];
        } cancelBlock:^(ActionSheetMultiPicker *picker) {
            
        } origin:[UIApplication sharedApplication].keyWindow];
    }else if (indexPath.row == 9){
        [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:YES MaxNumber:1 Handler:^(NSArray *images) {
            self.fileImage = [images firstObject];
            [self reloadData];
        }];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
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
