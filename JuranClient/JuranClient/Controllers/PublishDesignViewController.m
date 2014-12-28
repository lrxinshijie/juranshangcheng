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
#import "TextFieldCell.h"

@interface PublishDesignViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *fileImage;
@property (nonatomic, strong) NSString *fileImageURL;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) UITextField *selectedTextField;


@end

@implementation PublishDesignViewController

- (void)dealloc{
    _tableView.delegate = nil; _tableView.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = _demand ? @"修改需求" : @"需求发布";
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSubmit) title:_demand ? @"保存" : @"确认发布" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 12, 60, 45)];
    _photoImageView.image = [UIImage imageNamed:@"publish_image_default"];
    
    self.keys = @[@"姓名",@"联系电话",@"房屋类型",@"装修预算(万元)",@"房屋面积(㎡)",@"风格",@"项目地址",@"小区名称",@"户型",@"户型图(可选)"];
    self.placeholders = @[@"请输入姓名",@"请输入11位手机号",@"房屋类型", @"请输入数字",@"请输入数字",@"请选择",@"请选择",@"请输入文字",@"请选择",@"可选"];
    
    BOOL flag = self.navigationController.tabBarController.tabBar.hidden;
    self.tableView = [self.view tableViewWithFrame:flag?kContentFrameWithoutNavigationBar:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = _headerView;
    
    if (!_demand) {
        self.demand = [[JRDemand alloc] init];
    }
    
    [self loadAd];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)loadAd{
    NSDictionary *param = @{@"adCode": @"app_consume_req_page",
                            @"areaCode": @"110000",
                            @"type": @(7)};
    [self showHUD];
    
    [[ALEngine shareEngine] pathURL:JR_GET_BANNER_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *bannerList = [data objectForKey:@"bannerList"];
            NSDictionary *list = [bannerList firstObject];
            if (list) {
                [_imageView setImageWithURLString:[list objectForKey:@"mediaCode"]];
            }
        }
    }];
}

- (void)reloadData{
    self.values = @[_demand.contactsName,_demand.contactsMobile, _demand.houseTypeString, _demand.budget,_demand.houseArea,_demand.renovationStyleString,_demand.areaInfo.title,_demand.neighbourhoods,_demand.roomNumString,@"可选"];
    
    if (_fileImage) {
        _photoImageView.image = _fileImage;
    }else if (_demand.designReqId.length > 0){
        [_photoImageView setImageWithURLString:_demand.roomTypeImgUrl];
    }
    
    [_tableView reloadData];
}

- (void)onSubmit{
    [_selectedTextField resignFirstResponder];
    
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
            }else{
                [self hideHUD];
            }
        }];
    }else{
        [self submitDemand];
    }
    
}

- (void)submitDemand{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"contactsName": _demand.contactsName,
                                                                                 @"houseType": _demand.houseType,
                                                                                 @"contactsMobile": _demand.contactsMobile,
                                                                                 @"houseArea": _demand.houseArea,
                                                                                 @"budget": _demand.budget,
                                                                                 @"budgetUnit": @"million",
                                                                                 @"renovationStyle": _demand.renovationStyle,
                                                                                 @"neighbourhoods": _demand.neighbourhoods,
                                                                                 @"roomNum":_demand.roomNum,
                                                                                 @"livingroomCount":_demand.livingroomCount,
                                                                                 @"bathroomCount":_demand.bathroomCount,
                                                                                 @"areaInfo": [_demand.areaInfo dictionaryValue],
                                                                                 @"newRoomTypeUrl": _demand.neRoomTypeImgUrl,
                                                                                 @"oldRoomTypeUrl": _demand.oldRoomTypeImgUrl,
                                                                                 @"roomTypeId": _demand.roomTypeId
                                                                                 }];
    
    if (_demand.designReqId.length > 0) {
        [param setObject:_demand.designReqId forKey:@"designReqId"];
    }
    
    [[ALEngine shareEngine] pathURL:JR_PUBLISH_DESIGN parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if (_demand.designReqId.length > 0) {
                [self showTip:@"需求修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameMyDemandReloadData object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self showTip:@"发布需求成功"];
                self.demand = [[JRDemand alloc] init];
                self.fileImage = nil;
                _photoImageView.image = [UIImage imageNamed:@"publish_image_default"];
                [self reloadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.navigationController.tabBarController.tabBar.hidden) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameMyDemandReloadData object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        MyDemandViewController *vc = [[MyDemandViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                });
            }
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
    if (indexPath.row == [_keys count] - 1) {
        static NSString *CellIdentifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ImageCell"];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
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
    static NSString *CellIdentifier = @"TextFieldCell";
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (TextFieldCell *)[nibs firstObject];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textField.enabled = YES;
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    if (indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 8) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textField.enabled = NO;
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.titleLabel.text = [_keys objectAtIndex:indexPath.row];
    cell.textField.placeholder = [_placeholders objectAtIndex:indexPath.row];
    cell.textField.text = [_values objectAtIndex:indexPath.row];
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    
    if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4){
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_selectedTextField resignFirstResponder];
    
    if (indexPath.row == 6) {
        BaseAddressViewController *vc = [[BaseAddressViewController alloc] init];
        [vc setFinishBlock:^(JRAreaInfo *areaInfo) {
            _demand.areaInfo = areaInfo;
        }];
        
        vc.hidesBottomBarWhenPushed = YES;
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
        [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isContainsEmoji]) {
        return NO;
    }
    
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == DemandEditContactsMobile && value.length > kPhoneMaxNumber) {
        return NO;
    }else if (textField.tag == DemandEditContactsMobile && value.length > 32){
        return NO;
    }else if (textField.tag == DemandEditBudget){
        double budget = [value doubleValue];
        if (budget < 0 || budget > 99999) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.selectedTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        _demand.contactsName = textField.text;
    }else if (textField.tag == 1){
        _demand.contactsMobile = textField.text;
    }else if (textField.tag == 3){
        _demand.budget = textField.text;
    }else if (textField.tag == 4){
        _demand.houseArea = textField.text;
    }else if (textField.tag == 7){
        _demand.neighbourhoods = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSTimeInterval animation = animationDuration;
    
    //视图移动的动画开始
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animation];
    CGRect frame = _tableView.frame;
    frame.size.height = kWindowHeightWithoutNavigationBar - keyboardSize.height;
    _tableView.frame = frame;
    
    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    BOOL flag = self.navigationController.tabBarController.tabBar.hidden;
    _tableView.frame = flag ? kContentFrameWithoutNavigationBar : kContentFrameWithoutNavigationBarAndTabBar;
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
