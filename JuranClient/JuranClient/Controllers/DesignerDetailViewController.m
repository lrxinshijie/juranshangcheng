//
//  DesignerDetailViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DesignerDetailViewController.h"
#import "JRSegmentControl.h"
#import "SelfIntrodutionCell.h"
#import "TATopicCell.h"
#import "CaseCell.h"
#import "JRDesigner.h"
#import "JRUser.h"
#import "ShareView.h"

@interface DesignerDetailViewController ()<UITableViewDataSource, UITableViewDelegate, JRSegmentControlDelegate, SelfIntroductionCellDelegate>
{
    NSArray *personDatas;
}
@property (nonatomic, weak) IBOutlet UIView *toolBar;
@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) IBOutlet JRSegmentControl *segment;
@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UIView *headView;
@property (nonatomic, weak) IBOutlet UILabel *fansCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *popularityLabel;
@property (nonatomic, weak) IBOutlet UILabel *pictureCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *diyProjectCountLabel;
@property (nonatomic, weak) IBOutlet UIImageView *followImageView;
@property (nonatomic, weak) IBOutlet UILabel *followTitleLabel;
@property (nonatomic, strong) SelfIntrodutionCell *introductionCell;
@property (nonatomic, strong) TATopicCell *topicCell;
@property (nonatomic, strong) ShareView *shareView;

@end

@implementation DesignerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = _designer.nickName;
    
    personDatas = @[@"毕业院校", @"量房费", @"设计费用", @"从业年限", @"擅长风格"];
    [self setupUI];
    [self loadData];
}


- (void)setupUI{
    [_segment setTitleList:@[@"作品案例", @"个人资料", @"TA参与的话题"]];
    _segment.delegate = self;
    
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height/2.f;
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = _headView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0f];
    [self.view addSubview:_tableView];
    
    _toolBar.frame = CGRectMake(0, kWindowHeightWithoutNavigationBar - 49, _toolBar.frame.size.width, _toolBar.frame.size.height);
    [self.view addSubview:_toolBar];
    
    _shareView = [[ShareView alloc] init];
    

    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [_tableView addGestureRecognizer: leftSwipeGestureRecognizer];
    [_tableView addGestureRecognizer: rightSwipeGestureRecognizer];
}


- (void)reloadData{
    _fansCountLabel.text = [NSString stringWithFormat:@"%i", _designer.fansCount];
    _nameLabel.text = _designer.nickName;
    _followImageView.image = [UIImage imageNamed:_designer.isFollowed?@"menu_icon_cancel_follow":@"menu_icon_guanzhu.png"];
    _followTitleLabel.text = _designer.isFollowed?@"取消关注":@"关注";
    [_tableView reloadData];
}

- (void)loadData{
    NSDictionary *param = @{@"userId": [NSString stringWithFormat:@"%i", _designer.userId]};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_DESIGNERDETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _designer = [_designer buildDetailWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            }
        }
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target Action

- (IBAction)doFollow:(id)sender{
    if (![self checkLogin]) {
        return;
    }
    ASLog(@"关注");
    NSDictionary *param = @{@"userId": [NSString stringWithFormat:@"%i", _designer.userId]};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_FOLLOWDESIGNER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            
        }
    }];
}

- (void)nextAction{
    
}

//预约
- (IBAction)doMakeAppointment:(id)sender{
    ASLog(@"预约");
}

//私信
- (IBAction)doPrivateLetter:(id)sender{
    ASLog(@"私信");
}

//分享
- (IBAction)doShare:(id)sender{
    ASLog(@"分享");
    [_shareView showWithContent:@"" image:@"" title:@"" url:@""];
}

- (void)handleSwipes:(UISwipeGestureRecognizer*) gesture{
    NSInteger index = _segment.selectedIndex;
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (index + 1 >= _segment.numberOfSegments) {
            return;
        }else{
            _segment.selectedIndex = index+1;
        }
    }else if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (index - 1 < 0) {
            return;
        }else{
            _segment.selectedIndex = index-1;
        }
    }
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == _segment.selectedIndex) {
        return 10;
    }else if (1 == _segment.selectedIndex){
        return 6;
    }else{
        return 13;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _segment;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == _segment.selectedIndex) {
        return 275;
    }else if (1 == _segment.selectedIndex){
        if (indexPath.row == 0) {
            return self.introductionCell.frame.size.height;
        }else{
            return 44;
        }
    }else{
        [self.topicCell setDatas:nil];
        return self.topicCell.frame.size.height;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *personalDataStr = @"personalDataCell";
    UITableViewCell *cell = nil;
    if (0 == _segment.selectedIndex) {
        static NSString *caseIdentifier = @"CaseCell";
        cell = (CaseCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:caseIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:caseIdentifier owner:self options:nil];
            cell = (CaseCell *)[nibs firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        JRCase *c = [_datas objectAtIndex:indexPath.row];
//        [cell fillCellWithCase:c];
        
        return cell;
    }else if (1 == _segment.selectedIndex){
        if (0 == indexPath.row) {
            [self.introductionCell setContent:_designer.selfIntroduction];
            cell = self.introductionCell;
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:personalDataStr];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:personalDataStr];
                cell.backgroundColor = [UIColor clearColor];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 1, 310, 42)];
                view.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:view];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.textLabel.textColor = RGBColor(24, 24, 24);
                cell.accessoryView = nil;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.textColor = RGBColor(75, 75, 75);
            }
            cell.textLabel.text = personDatas[indexPath.row-1];
            if (1 == indexPath.row) {
                cell.detailTextLabel.text = _designer.granuate;
            }else if (4 == indexPath.row){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d年", _designer.experience];
            }else if (5 == indexPath.row){
                cell.detailTextLabel.text = [_designer styleNamesWithType:1];
            }else if (2 == indexPath.row){
                CGRect frame = CGRectMake(0, 0, 100, 30);
                UIView *view = [[UIView alloc] initWithFrame:frame];
                view.backgroundColor = [UIColor clearColor];
                UILabel *label = [cell.contentView labelWithFrame:frame text:@"元" textColor:RGBColor(75, 75, 75) textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:kSystemFontSize]];
                [view addSubview:label];
                frame.size.width -= kSystemFontSize;
                label = [cell.contentView labelWithFrame:frame text:[NSString stringWithFormat:@"%d", _designer.priceMeasure] textColor:RGBColor(73, 129, 189) textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:kSystemFontSize]];
                [view addSubview:label];
                cell.accessoryView = view;
            }else if (3 == indexPath.row){
                CGRect frame = CGRectMake(0, 0, 150, 30);
                UIView *view = [[UIView alloc] initWithFrame:frame];
                view.backgroundColor = [UIColor clearColor];
                UILabel *label = [cell.contentView labelWithFrame:frame text:@"元/平方米" textColor:RGBColor(75, 75, 75) textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:kSystemFontSize]];
                [view addSubview:label];
                frame.size.width -= kSystemFontSize * 4.5f;
                label = [cell.contentView labelWithFrame:frame text:[NSString stringWithFormat:@"%d-%d", _designer.designFeeMin, _designer.designFeeMax]  textColor:RGBColor(73, 129, 189) textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:kSystemFontSize]];
                [view addSubview:label];
                cell.accessoryView = view;
            }
        }
    }else{
        static NSString *taTopicIdentifier = @"TATopicCell";
        cell = (TATopicCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:taTopicIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:taTopicIdentifier owner:self options:nil];
            cell = (TATopicCell *)[nibs firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [(TATopicCell*)cell setDatas:nil];
    }
    return cell;
}


#pragma mark - JRSegmentControlDelegate

- (void)segmentControl:(JRSegmentControl *)segment changedSelectedIndex:(NSInteger)index{
    [_tableView reloadData];
}

#pragma mark - SelfIntroductionCellDelegate

- (void)heightChanged:(SelfIntrodutionCell *)cell{
    if (cell == self.introductionCell) {
        [_tableView reloadData];
    }
}

#pragma mark - Set/Get


- (SelfIntrodutionCell*)introductionCell{
    if (!_introductionCell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SelfIntrodutionCell" owner:self options:nil];
        _introductionCell = (SelfIntrodutionCell*)[nibs firstObject];
        _introductionCell.delegate = self;
    }
    return _introductionCell;
}

- (TATopicCell*)topicCell{
    if (!_topicCell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"TATopicCell" owner:self options:nil];
        _topicCell = (TATopicCell*)[nibs firstObject];
    }
    return _topicCell;
}

@end
