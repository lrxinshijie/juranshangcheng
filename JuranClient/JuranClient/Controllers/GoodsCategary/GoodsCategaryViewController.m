//
//  GoodsCategaryViewController.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "GoodsCategaryViewController.h"
#import "SecondLevelItem.h"
#import "CustomSecLevelView.h"
#import "CustomThirdLevelCell.h"

@interface GoodsCategaryViewController ()<UITableViewDataSource,UITableViewDelegate,CustomSecLevelViewDelegate,CustomThirdLevelCellDelegate>
{
    //记录数组位置
    int cslv_i;
    //记录行数
    int cslv_lineNum;
    //记录上次所有字符串长度和
    int cslv_strLength;
    //记录上次折行的i的取值(统一为下一行的第一个的i的取值)
    int cslv_turnLoc;
}

@property (strong, nonatomic) IBOutlet UIButton *locationButton;
@property (strong, nonatomic) IBOutlet UIButton *fir_btn;
@property (strong, nonatomic) IBOutlet UIButton *sec_btn;
@property (strong, nonatomic) IBOutlet UIButton *th_btn;
@property (strong, nonatomic) IBOutlet UIButton *for_btn;

@property (strong, nonatomic) IBOutlet UIView *fir_line;
@property (strong, nonatomic) IBOutlet UIView *sec_line;
@property (strong, nonatomic) IBOutlet UIView *th_line;
@property (strong, nonatomic) IBOutlet UIView *for_line;

@property (strong, nonatomic) IBOutlet UIView *fir_line_across;
@property (strong, nonatomic) IBOutlet UIView *sec_line_across;
@property (strong, nonatomic) IBOutlet UIView *th_line_across;
@property (strong, nonatomic) IBOutlet UIView *for_line_across;

@property (strong, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) NSMutableArray * dateArray_firstLevel;
@property (strong, nonatomic) NSMutableArray * dataArray_secondLevel;
@property (strong, nonatomic) NSMutableArray * dataArray_thirdLevel;

//记录一级类目点击的Button
@property (strong, nonatomic) UIButton * old_btn;
@property (assign, nonatomic) BOOL isPopNavHide;
@property (assign, nonatomic) NSInteger sectionNumber;

@property (strong, nonatomic) CustomSecLevelView * old_view;
@property (assign, nonatomic) struct SelectLocation old_location;
@property (assign, nonatomic) int oldScrollOffSet;
@property (assign, nonatomic) int currentSection;

//tableview需要返回的位置
@property (assign, nonatomic) BOOL needBack;
@property (assign, nonatomic) CGPoint tablePoint;

@property (strong, nonatomic) NSMutableArray * finalDataArray;

@property (assign, nonatomic) int cellCount;



@property (assign, nonatomic) BOOL test;


@end

@implementation GoodsCategaryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isPopNavHide:(BOOL)hide
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.isPopNavHide = hide;
        _finalDataArray = [NSMutableArray arrayWithCapacity:0];
        _old_location.viewNum = -1;
        _old_location.index = Location_None;
        _old_view = nil;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    //下面两句是等页面初次进入是默认选中一级类目的第一个标签，此处配置其UI
    self.old_btn = self.fir_btn;
    self.fir_line.hidden = YES;
    //初始状态没有cell。
    self.cellCount = 0;
    //TODO:测试数据
    [self JiaShuJu];
    
    
    
    [self initUI];
    
}

- (void)JiaShuJu
{
    self.sectionNumber = -1;
    self.dateArray_firstLevel = [NSMutableArray arrayWithArray:@[@"11",@"22",@"33"]];
    self.dataArray_secondLevel = [NSMutableArray arrayWithCapacity:0];
    self.dataArray_thirdLevel = [NSMutableArray arrayWithCapacity:0];
    
    
    for (int i = 0; i<9; i++) {
        SecondLevelItem * item = [[SecondLevelItem alloc] init];
        item.lImage = @"aaa";
        item.lText = [NSString stringWithFormat:@"%@",@"aaaa"];
        item.mImage = @"aaa";
        item.mText = [NSString stringWithFormat:@"%@",@"aaaa"];
        item.rImage = @"aaa";
        item.rText = [NSString stringWithFormat:@"%@",@"aaaa"];
        item.isSelect = NO;
        item.selectLocation = Location_None;
        
        [self.dataArray_secondLevel addObject:item];
    }
}

- (void)initUI
{
    [self configFirstLevelItem];
}

- (void)configFirstLevelItem
{
    switch (self.dateArray_firstLevel.count) {
        case 1:
        {
            self.fir_btn.hidden = NO;
            self.fir_line_across.hidden = NO;
            [self.fir_btn setTitle:self.dateArray_firstLevel[0] forState:UIControlStateNormal];
            
            self.sec_btn.hidden = YES;
            self.sec_line_across.hidden = YES;
            
            self.th_btn.hidden = YES;
            self.th_line_across.hidden = YES;
            
            self.for_btn.hidden = YES;
            self.for_line_across.hidden = YES;
        }
            break;
        case 2:
        {
            self.fir_btn.hidden = NO;
            self.fir_line_across.hidden = NO;
            [self.fir_btn setTitle:self.dateArray_firstLevel[0] forState:UIControlStateNormal];
            
            self.sec_btn.hidden = NO;
            self.sec_line_across.hidden = NO;
            [self.sec_btn setTitle:self.dateArray_firstLevel[1] forState:UIControlStateNormal];
            
            self.th_btn.hidden = YES;
            self.th_line_across.hidden = YES;
            
            self.for_btn.hidden = YES;
            self.for_line_across.hidden = YES;
        }
            break;
        case 3:
        {
            self.fir_btn.hidden = NO;
            self.fir_line_across.hidden = NO;
            [self.fir_btn setTitle:self.dateArray_firstLevel[0] forState:UIControlStateNormal];
            
            self.sec_btn.hidden = NO;
            self.sec_line_across.hidden = NO;
            [self.sec_btn setTitle:self.dateArray_firstLevel[1] forState:UIControlStateNormal];
            
            self.th_btn.hidden = NO;
            self.th_line_across.hidden = NO;
            [self.th_btn setTitle:self.dateArray_firstLevel[2] forState:UIControlStateNormal];
            
            self.for_btn.hidden = YES;
            self.for_line_across.hidden = YES;
        }
            break;
        case 4:
        {
            self.fir_btn.hidden = NO;
            self.fir_line_across.hidden = NO;
            [self.fir_btn setTitle:self.dateArray_firstLevel[0] forState:UIControlStateNormal];
            
            self.sec_btn.hidden = NO;
            self.sec_line_across.hidden = NO;
            [self.sec_btn setTitle:self.dateArray_firstLevel[1] forState:UIControlStateNormal];
            
            self.th_btn.hidden = NO;
            self.th_line_across.hidden = NO;
            [self.th_btn setTitle:self.dateArray_firstLevel[2] forState:UIControlStateNormal];
            
            self.for_btn.hidden = NO;
            self.for_line_across.hidden = NO;
            [self.for_btn setTitle:self.dateArray_firstLevel[3] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)locationButtonDidClick:(id)sender {
    
}

- (IBAction)goBackButtonDidClick:(id)sender {
    
    [self.navigationController setNavigationBarHidden:self.isPopNavHide];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)moreFunctionButtonDidClick:(id)sender {
    
}

- (IBAction)firstLevelItemDidSelect:(id)sender {
    //6780 6781 6782 6783
    UIButton * button = (UIButton *)sender;
    if (self.old_btn == button) {
        return;
    }
    
    //TODO:重新做数组
    [button setBackgroundColor:[UIColor whiteColor]];
    [self.old_btn setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0]];
    switch (button.tag-6780) {
        case 0:
            self.fir_line.hidden = YES;
            break;
        case 1:
            self.sec_line.hidden = YES;
            break;
        case 2:
            self.th_line.hidden = YES;
            break;
        case 3:
            self.for_line.hidden = YES;
            break;
        default:
            break;
    }
    
    switch (self.old_btn.tag-6780) {
        case 0:
            self.fir_line.hidden = NO;
            break;
        case 1:
            self.sec_line.hidden = NO;
            break;
        case 2:
            self.th_line.hidden = NO;
            break;
        case 3:
            self.for_line.hidden = NO;
            break;
        default:
            break;
    }
    
    
    self.old_btn = button;
    
    [self initUI];
    
}


#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //多少段
    return self.dataArray_secondLevel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.currentSection) {
        return self.cellCount;
    }
    return 0;
}

//计算cell的个数
- (int)calculateCellNumber
{
    NSString * str;
    if (cslv_i<self.dataArray_thirdLevel.count) {
        str = [self.dataArray_thirdLevel objectAtIndex:cslv_i];
        cslv_strLength += str.length*11;
        
        if (cslv_strLength<213) {
            cslv_strLength += 20;
            cslv_i++;
            
        }else if (cslv_strLength == 213){
            cslv_lineNum++;
            cslv_i++;
            cslv_strLength = 0;
            
            NSMutableArray * tempArr = [NSMutableArray arrayWithCapacity:0];
            for (int j=cslv_turnLoc; j<cslv_i; j++) {
                [tempArr addObject:[self.dataArray_thirdLevel objectAtIndex:j]];
            }
            [self.finalDataArray addObject:tempArr];
            
            cslv_turnLoc = cslv_i;
        }else{
            
            cslv_lineNum++;
            cslv_strLength = 0;
            
            NSMutableArray * tempArr = [NSMutableArray arrayWithCapacity:0];
            for (int j=cslv_turnLoc; j<cslv_i; j++) {
                [tempArr addObject:[self.dataArray_thirdLevel objectAtIndex:j]];
            }
            [self.finalDataArray addObject:tempArr];
            
            cslv_turnLoc = cslv_i;
        }
        
        [self calculateCellNumber];
        
    }else{
        
        if (cslv_i == cslv_turnLoc) {
            //上一行最后一个正好是数组的最后一个数据
            
        }else if (cslv_i > cslv_turnLoc){
            //最后一行还没有排满，但是数组中没数据了
            cslv_lineNum++;
            NSMutableArray * tempArr = [NSMutableArray arrayWithCapacity:0];
            for (int j=cslv_turnLoc; j<cslv_i; j++) {
                [tempArr addObject:[self.dataArray_thirdLevel objectAtIndex:j]];
            }
            [self.finalDataArray addObject:tempArr];
        }
        
    }
    return cslv_lineNum;
}

- (void)cleanData
{
    cslv_i = 0;
    cslv_lineNum = 0;
    cslv_strLength = 0;
    cslv_turnLoc = 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"CustomThirdLevelCell";
    CustomThirdLevelCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomThirdLevelCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    [cell dynamicCreateUIWithData:[self.finalDataArray objectAtIndex:indexPath.row]];
    if (indexPath.row == self.finalDataArray.count-1) {
        [cell addLine];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 95;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomSecLevelView * cView = [[[NSBundle mainBundle] loadNibNamed:@"CustomSecLevelView" owner:self options:nil] lastObject];
    cView.tag = 9000+section;
    cView.delegate = self;
    [cView initSecondLevelViewWithItem:self.dataArray_secondLevel[section]];
    
    return cView;
}

#pragma mark - CustomSecLevelViewDelegate
- (void)secondLevelView:(CustomSecLevelView *)view didClickAtIndex:(struct SelectLocation)location
{
    //设置section，在最前边是因为还要调整上次收起的哪一行
    NSUInteger num = view.tag - 9000;
    self.currentSection = num;
    NSMutableIndexSet * indexSet = [[NSMutableIndexSet alloc] init];
    [indexSet addIndex:num];
    if (self.old_location.viewNum != -1) {
        [indexSet addIndex:self.old_location.viewNum-9000];
    }
    
    //获取上次的View的item和这次的item，用于修改是否展示被选中的尖尖
    if (_old_location.viewNum != -1) {
        SecondLevelItem * oldItem = [self.dataArray_secondLevel objectAtIndex:_old_location.viewNum-9000];
        oldItem.isSelect = NO;
        oldItem.selectLocation = Location_None;
    }
    
    
    
    if (self.old_location.index == location.index && self.old_location.viewNum == location.viewNum) {
        //点击的是同一个按钮，需要收起。
        
        [self.dataArray_thirdLevel removeAllObjects];
        [self.finalDataArray removeAllObjects];
        
        self.cellCount = 0;
        
        //修改字体颜色
        [view setTextNormalColor:location.index];
        
        SecondLevelItem * currentItem = [self.dataArray_secondLevel objectAtIndex:location.viewNum-9000];
        currentItem.isSelect = NO;
        currentItem.selectLocation = Location_None;
        
        _old_location.index = Location_None;
        _old_location.viewNum = -1;
        self.old_view = nil;
        
    }else{
        //请求数据
        [self requestData];
        
        //修改字体颜色
        [self.old_view setTextNormalColor:self.old_location.index];
        [view setTextSelectColor:location.index];
        
        SecondLevelItem * currentItem = [self.dataArray_secondLevel objectAtIndex:location.viewNum-9000];
        currentItem.isSelect = YES;
        currentItem.selectLocation = location.index;
        
        self.old_view = view;
        self.old_location = location;
    }
    
    [_listTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    int distance = (location.viewNum-9000+1)*95+self.cellCount*31-self.listTableView.contentOffset.y-([UIScreen mainScreen].bounds.size.height - 64);
    if (distance>0) {
        [self.listTableView setContentOffset:CGPointMake(0, self.listTableView.contentOffset.y+distance+10) animated:YES];
    }
    
   
}

- (void)requestData
{
    [self.dataArray_thirdLevel removeAllObjects];
    [self.finalDataArray removeAllObjects];
    if (self.test) {
        [self.dataArray_thirdLevel addObjectsFromArray:@[@"噶哈哈",@"噶哈哈哈",@"噶哈哈哈哈哈哈哈",@"噶哈哈哈哈哈",@"噶哈哈",@"噶哈哈哈哈哈哈",@"噶哈哈哈哈哈哈",@"噶哈哈哈哈哈",@"噶哈哈",@"噶哈",@"噶哈哈哈",@"噶哈哈哈哈",@"噶哈哈哈哈哈哈哈"]];
    }else{
        [self.dataArray_thirdLevel addObjectsFromArray:@[@"哈哈哈",@"哈哈哈哈",@"哈哈哈哈哈哈哈哈",@"哈哈哈哈哈哈",@"哈哈哈",@"哈哈哈哈哈哈哈",@"哈哈哈哈哈哈哈",@"哈哈哈哈哈哈",@"哈哈哈",@"哈哈",@"哈哈哈哈",@"哈哈哈哈哈",@"哈哈哈哈哈哈哈哈",@"哈哈哈哈哈哈哈哈",@"哈哈哈哈哈",@"哈哈哈哈",@"哈哈哈哈哈",@"哈哈哈哈哈",@"哈哈",@"哈哈哈"]];
    }
    self.test = !self.test;
    
    //计算多少有个cell
    self.cellCount = [self calculateCellNumber];
    [self cleanData];
}

#pragma mark - CustomThirdLevelCellDelegate
- (void)thirdLevelItemDidSelectedWithMessage:(NSString *)msg
{
    NSLog(@"%@",msg);
}






@end
