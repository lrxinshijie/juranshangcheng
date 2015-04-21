//
//  PreDisclosureInfoViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/4/20.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "PreDisclosureInfoViewController.h"

@interface PreDisclosureInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *remarkView;
@property (nonatomic, strong) IBOutlet UILabel *remarkLabel;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;

@end

@implementation PreDisclosureInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"预交底信息";
    
    self.keys = @[@"消费者", @"消费者联系方式", @"预交底日期", @"设计师", @"设计师联系方式", @"施工承接方", @"施工队队长", @"工长联系方式", @"班长", @"班长联系方式", @"监理", @"监理联系方式", @"备注"];
    self.values = @[@"消费者", @"消费者联系方式", @"预交底日期", @"设计师", @"设计师联系方式", @"施工承接方", @"施工队队长", @"工长联系方式", @"班长", @"班长联系方式", @"监理", @"监理联系方式", @"备注啥地是可怜的减肥了开始交电费了空间是理科的分解开连锁店交罚款了SD卡放假了开始将对方考虑几十块了对方即可了解谁可怜的房间克里斯多几分快乐圣诞节快乐放假快乐圣诞节罚款了数量都放假了快速减肥了是减肥了空间是理科的房价来看方了急死了都放假了快速减肥来看"];
    [self setupUI];
}

- (void)setupUI{
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _keys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _keys.count - 1) {
        NSString *remark = _values[indexPath.row];
        CGFloat height = [remark heightWithFont:_remarkLabel.font constrainedToWidth:CGRectGetWidth(_remarkLabel.frame)];
        return 70 + (height<20?0:(height - 20));
    }else{
        return 44;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"PreDisclosuerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize+2];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *view = [cell.contentView viewWithTag:5555];
    if (view) {
        [view removeFromSuperview];
    }
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    if (indexPath.row == _keys.count - 1) {
        _remarkLabel.text = _values[indexPath.row];
        CGRect frame = _remarkLabel.frame;
        CGFloat height = [_remarkLabel.text heightWithFont:_remarkLabel.font constrainedToWidth:CGRectGetWidth(_remarkLabel.frame)];
        frame.size.height = (height < 20?20:height);
        _remarkLabel.frame = frame;
        
        frame = _remarkView.frame;
        frame.size.height = CGRectGetMaxY(_remarkLabel.frame)+12;
        _remarkView.frame = frame;
        
        [cell.contentView addSubview:_remarkView];
    }else{
        cell.textLabel.text = _keys[indexPath.row];
        cell.detailTextLabel.text = _values[indexPath.row];
    }
    if (indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 11) {
        cell.detailTextLabel.textColor = kBlueColor;
    }
    return cell;
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
