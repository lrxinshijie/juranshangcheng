//
//  BaseAddressViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-7.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "BaseAddressViewController.h"
#import "pinyin.h"
#import "JRAreaInfo.h"

@interface BaseAddressViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger type;
    NSArray *sortedProvinceKeys;
    NSMutableDictionary *provinceDic;
    NSDictionary *cityDic;
    NSDictionary *districtDic;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JRAreaInfo *areaInfo;

@end

@implementation BaseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"地区";

    type = 0;
//    _areaInfo.provinceCode = @"";
//    _areaInfo.cityCode = @"";
//    _areaInfo.districtCode = @"";
    
    self.areaInfo = [[JRAreaInfo alloc] init];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    [self loadData];
}

- (void)loadData{
    NSDictionary *param = @{@"provinceCode": _areaInfo.provinceCode,
                            @"cityCode": _areaInfo.cityCode};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_ALLAREA_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"No"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if (type == 0) {
                [self parseProvince:data[@"regions"]];
            }else if (type == 1){
                cityDic = data[@"regions"];
            }else{
                districtDic = data[@"regions"];
                if (districtDic.allKeys.count == 0) {
                    [self commit];
                }
            }
            [self reloadData];
        }
    }];
}

/*
- (void)modifyMemberDetail{
    NSDictionary *param = @{@"areaInfo": @{@"provinceCode": provinceCode,
                              @"cityCode": cityCode,
                              @"districtCode": districtCode
                              }};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_EDIT_MEMBERINFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
//            _memberDetail.provinceCode = provinceCode;
//            _memberDetail.provinceName = provinceName;
//            _memberDetail.cityCode = cityCode;
//            _memberDetail.cityName = cityDic[cityCode];
//            _memberDetail.districtCode = districtCode;
//            _memberDetail.districtName = districtDic[districtCode];
            
            _areaInfo.provinceCode = provinceCode;
            _areaInfo.provinceName = provinceName;
            _areaInfo.cityCode = cityCode;
            _areaInfo.cityName = cityDic[cityCode];
            _areaInfo.districtCode = districtCode;
            _areaInfo.districtName = districtDic[districtCode];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}*/

- (void)setFinishBlock:(AddressSelected)finished{
    self.block = finished;
}

- (void)commit{
    if (_block) {
        _block(_areaInfo);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)parseProvince:(NSDictionary*)dic{
    provinceDic = [NSMutableDictionary dictionary];
    for (NSString *key in dic.allKeys) {
        NSString *value = [dic objectForKey:key];
        char first = pinyinFirstLetter([value characterAtIndex:0]);
        NSMutableArray *proValues = [provinceDic objectForKey:[NSString stringWithFormat:@"%c", first - 32]];
        if (proValues == nil) {
            proValues = [NSMutableArray array];
            [proValues addObject:@{key:value}];
        }else{
            [proValues addObject:@{key:value}];
        }
        [provinceDic setObject:proValues forKey:[NSString stringWithFormat:@"%c", first - 32]];
    }
    sortedProvinceKeys = [provinceDic.allKeys sortedArrayUsingSelector:@selector(compare:)];
}

- (void)reloadData{
    [_tableView reloadData];
}

- (void)back:(id)sender{
    if (type == 0) {
        [super back:sender];
    }else if (type == 1){
        type = 0;
        _areaInfo.provinceCode = @"";
        [_tableView reloadData];
    }else{
        type = 1;
        _areaInfo.cityCode = @"";
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return sortedProvinceKeys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger i = 0;
    for (NSString *str in sortedProvinceKeys) {
        if ([title isEqualToString:str]) {
            return i;
        }
        i++;
    }
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (type == 0) {
        return [NSString stringWithFormat:@"  %@", sortedProvinceKeys[section]];
    }
    return @"  全部";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (type == 0) {
        return sortedProvinceKeys.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (type == 0) {
        NSMutableArray *datas = provinceDic[sortedProvinceKeys[section]];
        return datas.count;
    }else if (type == 1){
        return cityDic.allKeys.count;
    }else{
        return districtDic.allKeys.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"BaseAddressCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
    }
    cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 8, 15) image:[UIImage imageNamed:@"cellIndicator.png"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (type == 0) {
        NSMutableArray *datas = provinceDic[sortedProvinceKeys[indexPath.section]];
        NSDictionary *dic = datas[indexPath.row];
        cell.textLabel.text = dic.allValues.firstObject;
    }else if (type == 1){
        cell.textLabel.text = cityDic.allValues[indexPath.row];
    }else{
        cell.textLabel.text = districtDic.allValues[indexPath.row];
        cell.accessoryView = nil;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (type == 0) {
        NSMutableArray *datas = provinceDic[sortedProvinceKeys[indexPath.section]];
        NSDictionary *dic = datas[indexPath.row];
        _areaInfo.provinceCode = dic.allKeys.firstObject;
        _areaInfo.provinceName = dic.allValues.firstObject;
        type = 1;
        [self loadData];
    }else if (type == 1){
        _areaInfo.cityCode = cityDic.allKeys[indexPath.row];
        _areaInfo.cityName = cityDic.allValues[indexPath.row];
        type = 2;
        [self loadData];
    }else{
        _areaInfo.districtCode = districtDic.allKeys[indexPath.row];
        _areaInfo.districtName = districtDic.allValues[indexPath.row];
        [self commit];
    }
}




@end
