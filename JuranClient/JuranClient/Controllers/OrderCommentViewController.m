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

@interface OrderCommentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *footerView;

@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;
@property (nonatomic, strong) IBOutlet ASPlaceholderTextView *contentTextView;

@property (nonatomic, strong) IBOutlet CommentStarView *capacityPointView;
@property (nonatomic, strong) IBOutlet CommentStarView *servicePointView;

@property (nonatomic, strong) IBOutlet UIView *toolView;

@property (nonatomic, strong) IBOutlet UILabel *orderNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *mobileNumLabel;
@property (nonatomic, strong) IBOutlet UIImageView *idImageView;
@property (nonatomic, strong) IBOutlet UIImageView *userLevelImageView;

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
    
    _toolView.frame = CGRectMake(0, kWindowHeightWithoutNavigationBar - 40, kWindowWidth, 40);
    [self.view addSubview:_toolView];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
//    NSDictionary *info = [notification userInfo];
//    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
//    CGSize keyboardSize = [value CGRectValue].size;
    
//    CGRect contentFrame = [self.view convertRect:_contentTextView.frame fromView:self.tableView];
    
    
    CGRect frame = _tableView.frame;
    frame.origin.y = 0 - 217 + (kWindowHeight > 500?88:0);
    _tableView.frame = frame;
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    
    _tableView.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBar - 40);
}


@end
