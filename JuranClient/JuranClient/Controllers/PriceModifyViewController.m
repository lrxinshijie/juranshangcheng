//
//  PriceModifyViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "PriceModifyViewController.h"
#import "PriceModifyCell.h"
#import "JRDesigner.h"

@interface PriceModifyViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) IBOutlet UIView *designView;
@property (nonatomic, strong) IBOutlet UIView *measureView;

@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, strong) IBOutlet UITextField *measureTextField;
@property (nonatomic, strong) IBOutlet UITextField *designMinTextField;
@property (nonatomic, strong) IBOutlet UITextField *designMaxTextField;

@end

@implementation PriceModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];

    if (_type == 0) {
        self.navigationItem.title = @"设计费用";
        self.titles = @[@"面议", @"元/平米"];
        if (_designer.faceToFace) {
            _selectedRow = 1;
            self.designMaxTextField.text = [NSString stringWithFormat:@"%d",(NSInteger)_designer.designFeeMax];
            self.designMinTextField.text = [NSString stringWithFormat:@"%d",(NSInteger)_designer.designFeeMin];
        }
    }else if (_type == 1){
        self.navigationItem.title = @"量房费用";
        self.titles = @[@"免费", @"元"];
        if (_designer.freeMeasure) {
            _selectedRow = 1;
            self.measureTextField.text = [NSString stringWithFormat:@"%d", (NSInteger)_designer.priceMeasure];
        }
    }
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSave) title:@"保存" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.f];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSave{
    if (_type == 0) {
        if (_selectedRow) {
            if (_designMaxTextField.text.length == 0) {
                [self showTip:@"请输入最高设计费用"];
                return;
            }
            if (_designMinTextField.text.length == 0) {
                [self showTip:@"请输入最低设计费用"];
                return;
            }
            if (_designMinTextField.text.integerValue > _designMaxTextField.text.integerValue) {
                [self showTip:@"最低费用不能高于最高费用"];
                return;
            }
        }
        _designer.faceToFace = [NSString stringWithFormat:@"%d", _selectedRow];
        _designer.designFeeMax = [_designMaxTextField.text floatValue];
        _designer.designFeeMin = [_designMinTextField.text floatValue];
    }else if (_type == 1){
        if (_selectedRow) {
            if (_measureTextField.text.length == 0) {
                [self showTip:@"请输入量房费"];
                return;
            }
        }
        _designer.freeMeasure = [NSString stringWithFormat:@"%d", _selectedRow];
        _designer.priceMeasure = [_measureTextField.text floatValue];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.selectedRow != 1) {
        self.selectedRow = 1;
        [_tableView reloadData];
    }
    return YES;
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PriceModifyCell";
    PriceModifyCell *cell = [[PriceModifyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.detailTextLabel.text = _titles[indexPath.row];
    if (indexPath.row == 1) {
        if (_type == 0) {
            [_designView removeFromSuperview];
            CGRect frame = _designView.frame;
            frame.origin = CGPointMake(60, 0);
            _designView.frame = frame;
            [cell.contentView addSubview:_designView];
        }else if (_type == 1){
            [_measureView removeFromSuperview];
            CGRect frame = _measureView.frame;
            frame.origin = CGPointMake(60, 0);
            _measureView.frame = frame;
            [cell.contentView addSubview:_measureView];
        }
    }
    if (indexPath.row == _selectedRow) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_circle_selected.png"];
    }else{
        cell.iconImageView.image = [UIImage imageNamed:@"icon_circle_unselected.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectedRow != indexPath.row) {
        _selectedRow = indexPath.row;
        [tableView reloadData];
    }
}

@end
