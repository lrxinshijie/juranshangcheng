//
//  CaseImageManagemanetViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/3.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CaseImageManagemanetViewController.h"
#import "CaseImageCollectionCell.h"
#import "CaseImageHeaderView.h"
#import "ALGetPhoto.h"
#import "CaseIntroduceViewController.h"

@interface CaseImageManagemanetViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation CaseImageManagemanetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onIntroduce:) title:@"方案介绍" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    _roomTypeImages = [NSMutableArray array];
    _caseImages = [NSMutableArray array];
    
    
    [_roomTypeImages addObject:[[UIImage alloc] init]];
    [_caseImages addObject:[[UIImage alloc] init]];
    
    self.navigationItem.title = @"案例图片管理";
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.alwaysBounceVertical = YES;

    
    [_collectionView registerNib:[UINib nibWithNibName:@"CaseImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CaseImageCollectionCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"CaseImageHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CaseImageHeaderView"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onIntroduce:(id)sender{
    CaseIntroduceViewController *vc = [[CaseIntroduceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _roomTypeImages.count;
    }else{
        return _caseImages.count;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseImageCollectionCell";
    CaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell setImage:_roomTypeImages[indexPath.row]];
    }else if (indexPath.section == 1){
        [cell setImage:_caseImages[indexPath.row]];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    static NSString *headerIdentifier = @"CaseImageHeaderView";
    CaseImageHeaderView *header = nil;
    if([kind isEqual:UICollectionElementKindSectionHeader]){
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            [header setTitle:@"上传户型图（只限1张）" lineHidden:YES];
        }else{
            [header setTitle:[NSString stringWithFormat:@"上传案例图（最多%d/20张）", _caseImages.count - 1] lineHidden:NO];
        }
    }
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (_roomTypeImages.count <= 1) {
            [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
                [_roomTypeImages addObject:images.firstObject];
                [_collectionView reloadData];
            }];
        }else{
            [self showTip:@"户型图只限一张"];
        }
    }else if (indexPath.section == 1 && indexPath.row == 0){
        if (_caseImages.count < 21) {
            [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:21-_caseImages.count Handler:^(NSArray *images) {
                [_caseImages addObjectsFromArray:images];
                [_collectionView reloadData];
            }];
        }else{
            [self showTip:@"案例图片最多只能20张"];
        }
    }
}

@end
