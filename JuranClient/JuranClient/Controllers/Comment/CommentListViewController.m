//
//  CommentListViewController.m
//  JuranClient
//
//  Created by 123 on 15/11/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CommentListViewController.h"
#import "AddCommentViewController.h"
#import "JRShopOrProduceComment.h"
#import "AddReplyViewController.h"

#define kCommentViewHeight 30

@interface CommentListViewController ()
{
    NSMutableArray *array;
}

@property (nonatomic, assign) NSInteger currentPage;
@property (strong, nonatomic) IBOutlet UIView *emptyView;

@end

@implementation CommentListViewController

- (void)viewDidLoad {
    //[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [super viewDidLoad];
    
    
    self.navigationItem.title =(_InActionType==ENUM_ProductType? @"商品点评":@"店铺点评");
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"我要点评" style:UIBarButtonItemStyleBordered target:self action:@selector(addCommentClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], UITextAttributeFont, RGBColor(80, 130, 191), UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
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
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
}

-(void)refreshPage
{
    [_tableView headerBeginRefreshing];
    
}




- (void)loadData{
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    //NSInteger userId=[JRUser currentUser].userId;
    NSInteger type=_InActionType;
    NSInteger relId=_relId;//11
    
    
    [param setValue:@(type) forKey:@"type"];
    
    [param setValue:@(relId) forKey:@"relId"];
    [param setObject:@(_currentPage) forKey:@"currentPage"];
    [param setObject:kOnePageCount forKey:@"pageSize"];
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
            
           
            [self.tableView reloadData];

        }
        
        
        [_emptyView removeFromSuperview];
        if(array.count == 0) {
            _emptyView.center = CGPointMake(_tableView.center.x, 200);
            [_tableView addSubview:_emptyView];
        }

        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentListCell";
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CommentListCell *)[nibs firstObject];
    }
    
    cell.delegate = self;
    //    cell.labTitle.text=([self.goodsName isEqual:@""]?self.shopName:self.goodsName);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:[array objectAtIndex:indexPath.section]];
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return array.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JRShopOrProduceComment *model=(JRShopOrProduceComment *)[array objectAtIndex:indexPath.section];
    
    
    NSString *content = model.content;
    CGFloat height = [content heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:293];
    
    if(model.imgList && model.imgList.count>0)
    {
        height += 65;
        
    }
    return height+91+30;//67+
}



-(void)clickCellComment:(CommentListCell *)cell
{
    if(cell.model.arrReplyList.count==0)
    {
        if (![self checkLogin:^{
            
            
        }]) {
            return;
        }
    }
    
    AddReplyViewController *reply=[[AddReplyViewController alloc] init];
    reply.commentModel=[[JRShopOrProduceComment alloc] init];
    reply.commentModel=cell.model ;
    reply.hidesBottomBarWhenPushed=YES;
    reply.id=cell.model.id;
    [self.navigationController pushViewController:reply animated:YES];
}

-(void)clickVote:(CommentListCell *)cell
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@(cell.model.id) forKey:@"id"];
    
    [[ALEngine shareEngine] pathURL:JR_VoteReview parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
        
            [self loadData];
        }
    }];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)addCommentClick {
    
    if (![self checkLogin:^{
        
    }]) {
        return;
    }
    AddCommentViewController *add=[[AddCommentViewController alloc] init];
    add.hidesBottomBarWhenPushed=YES;
    add.relId=self.relId;
    add.InActionType=_InActionType;
    [self.navigationController pushViewController:add animated:YES];
    
   
}



@end
