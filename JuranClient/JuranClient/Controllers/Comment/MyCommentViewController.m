//
//  MyCommentViewController.m
//  JuranClient
//
//  Created by 123 on 15/11/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//
//#prama mark 我的点评页面

#import "MyCommentViewController.h"
#import "MyCommentCell.h"


@interface MyCommentViewController ()<UITableViewDataSource,UITableViewDelegate,JRSegmentControlDelegate,MyCommentCellDelegate,UIAlertViewDelegate>
{
    UIButton *btn;
    NSMutableArray *array;
    int count;
    
}


@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的点评";
    count=0;
    [self initUI];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    [_tableView headerBeginRefreshing];
    
    //[self.tableView setEditing:YES];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}
-(void)initUI
{

    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(10, 10, 45, 40);
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitleColor:RGBColor(116, 116, 116) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(CanEditCell) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    _segment.showUnderLine = YES;
    _segment.delegate = self;
    [_segment setTitleList:@[@"商品点评", @"店铺点评"]];
    
    _InActionType=ENUM_ProductType;
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(-30, CGRectGetHeight(_segment.frame), kWindowWidth+30, kWindowHeightWithoutNavigationBar - CGRectGetHeight(_segment.frame)) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];


}

- (void)loadData{
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSInteger userId=[JRUser currentUser].userId;
    [param setValue:@(userId) forKey:@"userId"];
    [param setObject:@(_currentPage) forKey:@"currentPage"];
    [param setObject:kOnePageCount forKey:@"pageSize"];
    [param setValue:@(_InActionType) forKey:@"type"];

    [self showHUD];

    
    [[ALEngine shareEngine] pathURL:JR_GETREVIEW_PAGE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];

        if (!error) {
            [array removeAllObjects];

            NSArray *commentList = [data objectForKey:@"reviewDtoList"];
            NSMutableArray *rows = [JRShopOrProduceComment buildUpWithValue:commentList];
            
            
            
            if (_currentPage > 1) {
                
                [array addObjectsFromArray:rows];
            }else{
                array = rows;
            }
            
        }
        else
        {
            //添加失败
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    }];
}

#pragma mark - JRSegmentControl

- (void)segmentControl:(JRSegmentControl *)segment changedSelectedIndex:(NSInteger)index{
    // _collectionView.hidden = index != 0;
    //_tableView.hidden = index == 0;
    if (array.count > 0) {
        [array removeAllObjects];
        //[_collectionView reloadData];
        [_tableView reloadData];
    }
    
    if(index==1)
    {
        _InActionType=ENUM_ShopType;

    }
    else
    {
        _InActionType=ENUM_ProductType;

    }
    
    [_btnDelete setTitle:@"删除" forState:UIControlStateNormal];
    count=0;
    [_tableView headerBeginRefreshing];
    
}



-(void)CanEditCell
{
    
//    [self.tableView setEditing:(!self.tableView.isEditing) ];
//
    CGRect rect=self.tableView.frame;
    
    if(rect.origin.x<0)
    {
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        self.tableView.frame=CGRectMake(0, CGRectGetHeight(_segment.frame), kWindowWidth, kWindowHeightWithoutNavigationBar - CGRectGetHeight(_segment.frame));
        
        _footerView.frame=CGRectMake(0, kWindowHeightWithoutNavigationBar-48, kWindowWidth,48 );
        [self.view addSubview:_footerView];
        
        [self.view bringSubviewToFront:_footerView];
//        self.tableView.tableFooterView=_footerView;
        
    }
    else
    {
        self.tableView.frame=CGRectMake(-30, CGRectGetHeight(_segment.frame), kWindowWidth+30, kWindowHeightWithoutNavigationBar - CGRectGetHeight(_segment.frame));
//        self.tableView.tableFooterView=nil;
        [_footerView removeFromSuperview];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setSelectedItem:(NSInteger)i
{
    count+=i;
    [_btnDelete setTitle:[NSString stringWithFormat:@"删除(%d)",count] forState:UIControlStateNormal];
}





- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}








-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MyCommentCell";
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (MyCommentCell *)[nibs firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:[array objectAtIndex:indexPath.section]];
//    [cell setData:[array objectAtIndex:indexPath.row]];
    cell.delegate=self;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JRShopOrProduceComment *model=(JRShopOrProduceComment *)[array objectAtIndex:indexPath.section];
    
    NSString *content = model.content;
    CGFloat height = [content heightWithFont:[UIFont systemFontOfSize:12] constrainedToWidth:257];
    
    if(model.imgList && model.imgList.count>0)
    {
        height += 65;

    }
    return height+70+10;//67+
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}


- (void)DeleteData{
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSMutableArray *arrayDeleteList=[NSMutableArray array];
    for (JRShopOrProduceComment *model in array) {
        if(model.isDelete)
        {
            [ arrayDeleteList addObject:@(model.id)];
        }
    }
   
    [param setObject:arrayDeleteList forKey:@"idList"];
    

    
    [[ALEngine shareEngine] pathURL:JR_DeleteReview parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            [self showTip:@"删除成功!"];
            [self loadData];
            count=0;
            [_btnDelete setTitle:@"删除" forState:UIControlStateNormal];

        }
      
       
        
    }];
}



- (IBAction)btnDeleteClick:(id)sender {
//
    if(count==0)
    {
        [self showTip:@"请选择要删除的点评"];
        return;
    }
    
 UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除么？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alter.delegate=self;
    [alter show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: //no应该做的事
             break;
        case 1://yes应该做的事
            [self DeleteData];

            break;
    }
}
@end
