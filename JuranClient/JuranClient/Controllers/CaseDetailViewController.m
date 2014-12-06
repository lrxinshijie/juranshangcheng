//
//  CaseDetailViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "JRCase.h"
#import "DesignerCell.h"
#import "JRDesigner.h"
#import "JRComment.h"
#import "CommentCell.h"
#import "DesignerDetailViewController.h"
#import "ShareView.h"

@interface CaseDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CommentCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) JRDesigner *designer;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) IBOutlet UIView *designerView;
@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailLabel;

@property (nonatomic, strong) IBOutlet UIView *commentView;
@property (nonatomic, strong) IBOutlet UITextField *commentTextField;

@property (nonatomic, strong) JRComment *selectComment;

- (IBAction)onSend:(id)sender;

@end

@implementation CaseDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"方案描述";
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"nav-icon-share"] rightBarButtonItemAction:@selector(onShare)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    self.keys = @[@"地区", @"楼盘", @"户型", @"风格", @"面积", @"参考", @"描述"];
    self.values = @[@"", @"", @"", @"", @"", @"", @""];
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(237, 237, 237);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    self.comments = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadComment];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadComment];
    }];
    
    CGRect frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
    
    [self.view addSubview:_commentView];
    
    self.values = @[[NSString stringWithFormat:@"%@-%@",_jrCase.cityName, _jrCase.districtName],
                    _jrCase.neighbourhoods,
                    _jrCase.roomType,
                    _jrCase.styleString,
                    [NSString stringWithFormat:@"%d平米",_jrCase.houseArea],
                    [NSString stringWithFormat:@"￥%d万元",_jrCase.projectPrice],
                    _jrCase.desc
                    ];
    _nameLabel.text = _jrCase.nickName;
    _detailLabel.text = _jrCase.stylesName;
    [_avtarImageView setImageWithURLString:_jrCase.headUrl];
    
    [_tableView headerBeginRefreshing];
    
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.cornerRadius = CGRectGetWidth(_avtarImageView.frame) / 2;
}

- (void)loadData{
    
//    NSDictionary *param = @{@"projectId": _jrCase.projectId};
//    [self showHUD];
//    [[ALEngine shareEngine] pathURL:JR_PRODETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
//        [self hideHUD];
//        if (!error) {
//            self.jrCase = [_jrCase buildDetailWithDictionary:data];
//            self.values = @[[NSString stringWithFormat:@"%@-%@",_jrCase.cityName, _jrCase.districtName],
//                            _jrCase.neighbourhoods,
//                            _jrCase.roomType,
//                            _jrCase.styleString,
//                            [NSString stringWithFormat:@"%d平米",_jrCase.houseArea],
//                            [NSString stringWithFormat:@"￥%d万元",_jrCase.projectPrice],
//                            _jrCase.desc
//                            ];
//            _nameLabel.text = _jrCase.nickName;
//            _detailLabel.text = _jrCase.tags;
//            [_avtarImageView setImageWithURLString:_jrCase.headUrl];
//        }
//        
//        [self loadComment];
//        [_tableView reloadData];
//    }];
}

- (void)loadComment{
    NSDictionary *param = @{@"projectId": _jrCase.projectId,
                            @"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": @"20"};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_CASE_COMMENT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *commentList = [data objectForKey:@"commentList"];
            NSMutableArray *rows = [JRComment buildUpWithValue:commentList];
            if (_currentPage > 1) {
                [_comments addObjectsFromArray:rows];
            }else{
                self.comments = rows;
            }
        }
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return [_keys count];
    }else{
        return [_comments count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 1){
        return 44;
    }else{
        JRComment *comment = [_comments objectAtIndex:indexPath.row];
        NSString *content = comment.commentContent;
        CGFloat height = [content heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:290];
        
        if (comment.replyList.count > 0) {
            CGFloat replyHeight = 25;
            if (comment.unfold) {
                replyHeight = 35;
                for (JRComment *reply in comment.replyList) {
                    NSString *name = [NSString stringWithFormat:@"%@：", reply.nickName];
                    NSString *content = [NSString stringWithFormat:@"%@%@", name, reply.replyContent];
                    replyHeight += [content heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:290];
                    replyHeight += 30;
                }
            }
            height += replyHeight;
        }
        
        
        return 73+height;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"DesignerCell";
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            [cell addSubview:_designerView];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
    }else if (indexPath.section == 1){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 1, 310, 43)];
            view.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:view];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        cell.textLabel.text = [_keys objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_values objectAtIndex:indexPath.row];
        return cell;
    }else{
        static NSString *CellIdentifier = @"CommentCell";
        CommentCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nibs firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        JRComment *commnet = [_comments objectAtIndex:indexPath.row];
        [cell fillCellWithComment:commnet];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 35;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        cell.backgroundColor = [UIColor clearColor];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 35)];
    headerView.backgroundColor = _tableView.backgroundColor;
    UILabel *label = [headerView labelWithFrame:CGRectMake(10, 0, kWindowWidth-20, 35) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    if (section == 1) {
        label.text = @"方案描述";
    }else{
        label.text = @"评论";
    }
    [headerView addSubview:label];
    return headerView;
}

- (void)onShare{
    [[ShareView sharedView] showWithContent:_jrCase.desc image:[[Public imageURL:_jrCase.imageUrl] absoluteString] title:_jrCase.title url:@""];
}

- (IBAction)onSend:(id)sender{
    [_commentTextField resignFirstResponder];
    
    if (![self checkLogin]) {
        return;
    }
    
    NSString *comment = _commentTextField.text;
    if (comment.length == 0) {
        [self showTip:@"评论内容不能为空"];
        return;
    }
    
    NSDictionary *param = @{@"projectId": _jrCase.projectId,
                            @"commentContent": comment};
    if (_selectComment) {
        param = @{@"projectId": _jrCase.projectId,
                  @"commentContent": comment,
                  @"commentId": [NSString stringWithFormat:@"%d", _selectComment.commentId]
                  };
    }
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_ADD_COMMENT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _commentTextField.text = @"";
            self.currentPage = 1;
            [self loadComment];
            self.selectComment = nil;
        }

    }];
}

- (void)clickCellComment:(CommentCell *)cell{
    self.selectComment = cell.comment;
    [_commentTextField becomeFirstResponder];
}

- (void)clickCellUnfold:(CommentCell *)cell{
    [_tableView reloadData];
}

- (void)setSelectComment:(JRComment *)selectComment{
    _selectComment = selectComment;
    if (_selectComment) {
        _commentTextField.placeholder = [NSString stringWithFormat:@"回复%@:", _selectComment.nickName];
    }else{
        _commentTextField.placeholder = @"写评论";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
        JRDesigner *designer = [[JRDesigner alloc] init];
        designer.userId = _jrCase.userId;
        detailVC.designer = designer;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self onSend:nil];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_selectComment && textField.text.length == 0) {
        self.selectComment = nil;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGRect frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame) - keyboardSize.height;
    _commentView.frame = frame;
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    
    CGRect frame = _commentView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _commentView.frame = frame;
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
