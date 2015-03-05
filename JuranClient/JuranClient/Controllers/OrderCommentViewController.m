//
//  OrderCommentViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/2/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderCommentViewController.h"
#import "CommentStarView.h"
#import "JROrder.h"
#import "JRDesigner.h"
#import "DesignerDetailViewController.h"

@interface OrderCommentViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CommentStarViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *footerView;

@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;
@property (nonatomic, strong) IBOutlet ASPlaceholderTextView *contentTextView;

@property (nonatomic, strong) IBOutlet CommentStarView *capacityPointView;
@property (nonatomic, strong) IBOutlet CommentStarView *servicePointView;
@property (nonatomic, strong) IBOutlet UILabel *capacityLabel;
@property (nonatomic, strong) IBOutlet UILabel *serviceLabel;

@property (nonatomic, strong) IBOutlet UIView *toolView;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UIButton *anonymityButton;

@property (nonatomic, strong) IBOutlet UILabel *orderNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *mobileNumLabel;
@property (nonatomic, strong) IBOutlet UIImageView *idImageView;
@property (nonatomic, strong) IBOutlet UIImageView *userLevelImageView;

@property (nonatomic, assign) BOOL isAnonymity;

@end

@implementation OrderCommentViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"订单评价";
    self.isAnonymity = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBar - 40) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = CGRectGetHeight(_headerImageView.frame)/2.f;
    
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.layer.borderColor = RGBColor(241, 241, 241).CGColor;
    _contentTextView.layer.borderWidth = 1.f;
//    CGSize size = _contentTextView.contentSize;
//    size.width -= 100;
//    _contentTextView.contentSize = size;
//    _contentTextView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    size = _contentTextView.contentSize;
    
    _toolView.frame = CGRectMake(0, kWindowHeightWithoutNavigationBar - 40, kWindowWidth, 40);
    [self.view addSubview:_toolView];
    
    _contentTextView.placeholder = @"请输入10-200字之间\n商品质量是否符合描述？快来分享你的购物心得吧～";
    _submitButton.layer.borderColor = RGBColor(35, 62, 143).CGColor;
    _submitButton.layer.borderWidth = 1.f;
    
    _capacityPointView.delegate = self;
    _servicePointView.delegate = self;
    _capacityPointView.selectedIndex = 4;
    _servicePointView.selectedIndex = 4;
}



#pragma mark - Target Action

- (IBAction)onSubmit:(id)sender{
    if (_capacityPointView.selectedIndex == 0) {
        [self showTip:@"请选择实力评分！"];
        return;
    }
    if (_servicePointView.selectedIndex == 0) {
        [self showTip:@"请选择服务评价！"];
        return;
    }
    if (_contentTextView.text.length < 10) {
        [self showTip:@"请输入10-200字的评价内容！"];
        return;
    }
    [self showHUD];
    NSDictionary *param = @{@"tid": _order.type?_order.designTid:_order.measureTid,
                            @"capacityPoint": [NSString stringWithFormat:@"%d", _capacityPointView.selectedIndex],
                            @"servicePoint": [NSString stringWithFormat:@"%d", _servicePointView.selectedIndex],
                            @"type": [NSString stringWithFormat:@"%d", _order.type],
                            @"content": _contentTextView.text,
                            @"ifAnony": [NSString stringWithFormat:@"%d", _isAnonymity]
                            };
    [[ALEngine shareEngine]  pathURL:JR_TRADE_APPRAISE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self showTip:@"评价成功!"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameOrderReloadData object:@""];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (IBAction)onAnonymity:(id)sender{
    _isAnonymity = !_isAnonymity;
    [_anonymityButton setImage:[UIImage imageNamed:_isAnonymity?@"order_point_selected.png":@"order_point_unselected.png"] forState:UIControlStateNormal];
}

- (IBAction)onDesignerView:(id)sender{
    DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
//    detailVC.designer = _datas[indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - CommentStarViewDelegate

- (void)didSelectedStarView:(CommentStarView *)starView{
    if (starView == _capacityPointView) {
        self.capacityLabel.text = [NSString stringWithFormat:@"%d星", starView.selectedIndex];
    }else if (starView == _servicePointView){
        self.serviceLabel.text = [NSString stringWithFormat:@"%d星", starView.selectedIndex];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 110;
    }else if (indexPath.row == 1) {
        return 270;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"OrderDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSmallSystemFontSize];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.clipsToBounds = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = @"";
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    UIView *view = [cell.contentView viewWithTag:5555];
    if (view) {
        [view removeFromSuperview];
    }
    if (indexPath.row == 0) {
        _orderNumberLabel.text = [NSString stringWithFormat:@"设计订单：%@", _order.designTid];
        [_headerImageView setImageWithURLString:_order.headUrl];
        _nameLabel.text = _order.decoratorName;
        _mobileNumLabel.text = _order.decoratorMobile;
        
        CGRect frame = _nameLabel.frame;
        CGFloat width = [_nameLabel.text widthWithFont:_nameLabel.font constrainedToHeight:CGRectGetHeight(frame)];
        if (width > 136) {
            width = 136;
        }
        frame.size.width = width;
        _nameLabel.frame = frame;
        
        frame = _idImageView.frame;
        frame.origin.x = CGRectGetMaxX(_nameLabel.frame) + 10;
        _idImageView.frame = frame;
        _idImageView.hidden = !_order.isAuth;
        
        _userLevelImageView.image = [UIImage imageNamed:[JRDesigner userLevelImage:_order.levelCode]];
        frame = _userLevelImageView.frame;
        if (_idImageView.hidden) {
            frame.origin.x = CGRectGetMaxX(_nameLabel.frame) + 10;
        }else{
            frame.origin.x = CGRectGetMaxX(_idImageView.frame) + 10;
        }
        _userLevelImageView.frame = frame;
        [cell.contentView addSubview:self.headerView];
    }else if (indexPath.row == 1) {
        [cell.contentView addSubview:self.footerView];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_contentTextView resignFirstResponder];
}


- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
//    CGRect contentFrame = [self.view convertRect:_contentTextView.frame fromView:self.tableView];
    
    
    CGRect frame = _tableView.frame;
    frame.origin.y = 36 - keyboardSize.height + (kWindowHeight > 500?88:0);
    _tableView.frame = frame;
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    
    _tableView.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBar - 40);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > 200) {
        [self showTip:@"内容长度不能超过200个字!"];
        return NO;
    }
    return YES;
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
