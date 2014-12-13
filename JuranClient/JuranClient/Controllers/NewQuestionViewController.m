//
//  NewQuestionViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "NewQuestionViewController.h"

@interface NewQuestionViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger step;
    NSArray *types;
    NSInteger selectedType;
}
@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) IBOutlet UIView *titleView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet ASPlaceholderTextView *contentTextView;
@property (nonatomic, strong) IBOutlet UITextField *titleTextField;
@property (nonatomic, strong) IBOutlet UIView *commitedView;

@end

@implementation NewQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    types = @[@"DIY技巧", @"设计&搭配", @"施工&装修", @"商品&选购"];
    
    _rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onRightButton:) title:@"下一步" backgroundImage:nil];
    [_rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    step = 1;
    
    _contentTextView.placeholder = @"请输入详细的描述";
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame))];
    bgView.backgroundColor = RGBColor(241, 241, 241);
    CGPoint center = CGPointMake(bgView.center.x, 220);
    _commitedView.center = center;
    _commitedView.hidden = YES;
    [bgView addSubview:_commitedView];
    _tableView.backgroundView = bgView;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    [self reloadData];
}

- (void)reloadData{
    if (step == 1) {
        self.navigationItem.title = @"描述你的问题";
        [_rightButton setTitle:@"下一步" forState:UIControlStateNormal];
        _tableView.tableHeaderView = _titleView;
        _tableView.tableFooterView = _contentView;
    }else if (step == 2){
        self.navigationItem.title = @"为问题选择分类";
        [_rightButton setTitle:@"提交" forState:UIControlStateNormal];
        _tableView.tableHeaderView = nil;
        _tableView.tableFooterView = [[UIView alloc] init];
    }else if (step == 3){
        self.navigationItem.title = @"提交成功";
        self.navigationItem.rightBarButtonItem = nil;
        _tableView.tableHeaderView = nil;
        _tableView.tableFooterView = [[UIView alloc] init];
        _commitedView.hidden = NO;
    }
    [_tableView reloadData];
}

- (void)onRightButton:(id)sender{
    if (step == 1) {
        if (!(_titleTextField.text && _titleTextField.text.length > 0)) {
            [self showTip:@"请输入问题标题"];
            return;
        }
        if (!(_contentTextView.text && _contentTextView.text.length > 0)) {
            [self showTip:@"请输入问题标题"];
            return;
        }
        step = 2;
        [self reloadData];
    }else if (step == 2){
        [self commit];
    }
    
}

- (void)back:(id)sender{
    if (step == 3 || step == 1) {
        [super back:sender];
    }else if (step == 2){
        step = 1;
        [self reloadData];
    }
}

- (void)commit{
    NSDictionary *param = @{@"questionType": [NSString stringWithFormat:@"%d", selectedType],
                            @"title": _titleTextField.text,
                            @"content": _contentTextView.text
//                            @"imageInfo": @""
                            };
//    @"fileField": @"",
//    @"fileName": @"",
//    @"fileType": @""
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_PUBLISHQUESTION parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            step = 3;
            [self reloadData];
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  step == 2?types.count:0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"NewQuestionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = types[indexPath.row];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:selectedType == indexPath.row?@"question_type_selected":@"question_type_unselected"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (step == 2) {
        if (selectedType == indexPath.row) {
            return;
        }
        selectedType = indexPath.row;
        [_tableView reloadData];
    }
}


@end
