//
//  PrivateMessageDetailViewController.m
//  JuranClient
//
//  Created by Kowloon on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PrivateMessageDetailViewController.h"
#import "PrivateMessage.h"
#import "UIBubbleTableView.h"

@interface PrivateMessageDetailViewController () <UIBubbleTableViewDataSource>

@property (nonatomic, strong) IBOutlet UIBubbleTableView *tableView;
@property (nonatomic, strong) IBOutlet UITextField *contentTextField;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

- (IBAction)onSend:(id)sender;

@end

@implementation PrivateMessageDetailViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [self configureLeftBarButtonUniformly];
    self.view.backgroundColor = kViewBackgroundColor;
    self.navigationItem.title = @"我的私信";
    

    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [self.tableView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    [self.tableView headerBeginRefreshing];
}

- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],
                            @"onePageCount": kOnePageCount,
                            @"privateLetterId": [NSString stringWithFormat:@"%d", _message.letterId]};
    
    [[ALEngine shareEngine] pathURL:JR_PRIVATE_DETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *privateLetterList = [data objectForKey:@"privateLetterList"];
            NSMutableArray *rows = [PrivateMessageDetail buildUpWithValue:privateLetterList];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = rows;
            }
            
            [self.tableView reloadData];
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    }];
}

- (IBAction)onSend:(id)sender{
    
}

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView{
    return [_datas count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row{
    PrivateMessageDetail *detail = [_datas objectAtIndex:row];
    NSDate *date = [NSDate dateFromString:detail.publishTime dateFormat:kDateFormatHorizontalLineLong];
    
    NSBubbleData *bubble = [NSBubbleData dataWithText:detail.content date:date type:detail.fromUserId == [JRUser currentUser].userId ? BubbleTypeMine : BubbleTypeSomeoneElse];
    return bubble;
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
