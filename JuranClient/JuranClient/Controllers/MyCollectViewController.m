//
//  MyCollectViewController.m
//  JuranClient
//
//  Created by HuangKai on 15-4-14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "MyCollectViewController.h"
#import "JRCase.h"
#import "CaseCollectionCell.h"
#import "JRPhotoScrollViewController.h"
#import "JRSegmentControl.h"

@interface MyCollectViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JRSegmentControlDelegate>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet JRSegmentControl *segment;

@property (nonatomic, strong) IBOutlet UIView *emptyView;

@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"我的收藏";
    
    [self setupUI];
    
    [_collectionView headerBeginRefreshing];
}

- (void)setupUI{
    [_segment setTitleList:@[@"案例收藏" ,@"商品收藏", @"店铺收藏"]];
    
    _collectionView.backgroundColor = RGBColor(237, 237, 237);
    _collectionView.alwaysBounceVertical = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CaseCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CaseCollectionCell"];
    
    __weak typeof(self) weakSelf = self;
    [_collectionView addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_collectionView addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
    
    _emptyView.hidden = YES;
    [self.view addSubview:_emptyView];
    _emptyView.center = _collectionView.center;
}

- (void)loadData{
    NSDictionary *param = @{@"pageNo": [NSString stringWithFormat:@"%d", _currentPage],@"onePageCount": kOnePageCount, @"projectType" : @"01"};
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_FAV_PROJECT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSArray *projectList = [data objectForKey:@"projectGeneralDtoList"];
            NSMutableArray *rows = [JRCase buildUpWithValue:projectList];
            if (_currentPage > 1) {
                [_datas addObjectsFromArray:rows];
            }else{
                self.datas = rows;
            }
            
            [self reloadData];
        }
        
        [_collectionView headerEndRefreshing];
        [_collectionView footerEndRefreshing];
        
    }];
}

- (void)reloadData{
    if (_segment.selectedIndex == 0) {
        [_collectionView reloadData];
    }else if (_segment.selectedIndex == 1){
        
    }else if (_segment.selectedIndex == 2){
        
    }
    _emptyView.hidden = _datas.count != 0;
}

#pragma mark - JRSegmentControl

- (void)segmentControl:(JRSegmentControl *)segment changedSelectedIndex:(NSInteger)index{
    
}

#pragma mark - UICollectionViewDataSource/Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_datas count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseCollectionCell";
    CaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    JRCase *cs = [_datas objectAtIndex:indexPath.row];
    [cell fillCellWithCase:cs];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JRCase *cs = [_datas objectAtIndex:indexPath.row];
    
    JRPhotoScrollViewController *vc = [[JRPhotoScrollViewController alloc] initWithJRCase:cs andStartWithPhotoAtIndex:0];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
