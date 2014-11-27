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

@interface DesignerDetailViewController ()<UITableViewDataSource, UITableViewDelegate, JRSegmentControlDelegate, SelfIntroductionCellDelegate>
{
    NSArray *personDatas;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet JRSegmentControl *segment;
@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, strong) SelfIntrodutionCell *introductionCell;
@property (nonatomic, strong) TATopicCell *topicCell;

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
    [self setupView];
    [self setupDatas];
}

- (void)setupView{
    [_segment setTitleList:@[@"作品案例", @"个人资料", @"TA参与的话题"]];
    _segment.delegate = self;
    
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height/2.f;
    _tableView.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0f];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TATopicCell" bundle:nil] forCellReuseIdentifier:@"TATopicCell"];
}

- (void)setupDatas{
    personDatas = @[@"毕业院校", @"量房费", @"设计费用", @"从业年限", @"擅长风格"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == _segment.selectedIndex) {
        return 0;
    }else if (1 == _segment.selectedIndex){
        return 6;
    }else{
        return 13;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == _segment.selectedIndex) {
        return 0;
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
        
    }else if (1 == _segment.selectedIndex){
        if (0 == indexPath.row) {
            [self.introductionCell setContent:@"深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大"];
            cell = self.introductionCell;
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:personalDataStr];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:personalDataStr];
                cell.backgroundColor = [UIColor clearColor];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 1, 310, 42)];
                view.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:view];
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                cell.accessoryView = nil;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }
            cell.textLabel.text = personDatas[indexPath.row-1];
            if (1 == indexPath.row) {
                cell.detailTextLabel.text = @"中央美术学院";
            }else if (4 == indexPath.row){
                cell.detailTextLabel.text = @"6年";
            }else if (5 == indexPath.row){
                cell.detailTextLabel.text = @"现代、中式、欧式";
            }else if (2 == indexPath.row){
                CGRect frame = CGRectMake(0, 0, 100, 30);
                UIView *view = [[UIView alloc] initWithFrame:frame];
                view.backgroundColor = [UIColor clearColor];
                UILabel *label = [cell.contentView labelWithFrame:frame text:@"元" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:kSystemFontSize]];
                [view addSubview:label];
                frame.size.width -= kSystemFontSize;
                label = [cell.contentView labelWithFrame:frame text:@"300" textColor:[UIColor blueColor] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:kSystemFontSize]];
                [view addSubview:label];
                cell.accessoryView = view;
            }else if (3 == indexPath.row){
                CGRect frame = CGRectMake(0, 0, 150, 30);
                UIView *view = [[UIView alloc] initWithFrame:frame];
                view.backgroundColor = [UIColor clearColor];
                UILabel *label = [cell.contentView labelWithFrame:frame text:@"元/平方米" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:kSystemFontSize]];
                [view addSubview:label];
                frame.size.width -= kSystemFontSize * 4.5f;
                label = [cell.contentView labelWithFrame:frame text:@"100-300" textColor:[UIColor blueColor] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:kSystemFontSize]];
                [view addSubview:label];
                cell.accessoryView = view;
            }
        }
    }else{
        cell = [_tableView dequeueReusableCellWithIdentifier:@"TATopicCell"];
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
        [_introductionCell setContent:@"深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大杰出青年设计师深圳十大"];
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
