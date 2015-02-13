//
//  OrderPhotoViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/2/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderPhotoViewController.h"
#import "JROrder.h"
#import "OrderPhotoBrowserViewController.h"

@interface OrderPhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIView *emptyView;

@end

@implementation OrderPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _type?@"效果图":@"户型图";
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"OrderPhotoCell"];
    if (_needLoadData) {
        [self loadData];
    }
}

- (void)loadData{
    [self showHUD];
    NSDictionary *param = @{@"tid": _order.type?_order.designTid:_order.measureTid,
                            @"userType": [[ALTheme sharedTheme]userType]
                            };
    [[ALEngine shareEngine]  pathURL:JR_ORDER_DETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            [self hideHUD];
            [_order buildUpWithValueForDetail:data];
            NSArray *rows = _type?_order.fileSrc:_order.measurefileSrc;
            _emptyView.hidden = rows.count != 0;
            [_collectionView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_type) {
        return _order.fileSrc.count;
    }else{
        return _order.measurefileSrc.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"OrderPhotoCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:5555];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
        imageView.tag = 5555;
        [cell.contentView addSubview:imageView];
    }
    NSArray *rows = _type?_order.fileSrc:_order.measurefileSrc;
    [imageView setImageWithURLString:rows[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderPhotoBrowserViewController *vc = [[OrderPhotoBrowserViewController alloc] initWithPhotos:_type?_order.fileSrc:_order.measurefileSrc andStartWithPhotoAtIndex:indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
