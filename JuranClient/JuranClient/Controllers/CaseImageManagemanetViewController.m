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
#import "CreateCaseSuccessViewController.h"

@interface CaseImageManagemanetViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageURLs;

@end

@implementation CaseImageManagemanetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onIntroduce:) title:_jrCase.projectId.length == 0 ? @"提交" : @"方案介绍" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.imageURLs = [NSMutableArray array];
    self.caseImages = [NSMutableArray array];
    
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
    if (_jrCase.projectId.length == 0) {
        if (!_roomTypeImage) {
            [self showTip:@"户型图不能为空"];
            return;
        }
        
        if (_caseImages.count == 0) {
            [self showTip:@"效果图不能为空"];
            return;
        }
        
        [self submitCase];
    }else{
        CaseIntroduceViewController *vc = [[CaseIntroduceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)submitCase{
    if (![self checkLogin]) {
        return;
    }
    
    self.imageURLs = [NSMutableArray array];
    
    [self showHUDFromTitle:@"上传户型图..."];
    [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":_roomTypeImage} responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            _jrCase.roomTypeImageUrl = [data objectForKey:@"imgUrl"];
            [self uploadCaseImage:0];
        }else{
            [self hideHUD];
        }
    }];
}

- (void)uploadCaseImage:(NSInteger)idx{
    ASLog(@"upload idx:%d", idx);
    
    UIImage *image = [_caseImages objectAtTheIndex:idx];
    [self setHUDTitle:[NSString stringWithFormat:@"上传效果图%d/%d...", idx+1,[_caseImages count]]];
    
    if (image) {
        [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":image} responseHandler:^(NSError *error, id data, NSDictionary *other) {
            if (!error) {
                [_imageURLs addObject:@{@"imageUrl":[data objectForKey:@"imgUrl"],@"frontFlag":idx == 0 ? @(1) : @(0),@"picType":@"03"}];
                NSInteger ind = idx + 1;
                [self uploadCaseImage:ind];
            }else{
                [self hideHUD];
            }
        }];
    }else{
        NSDictionary *param = @{@"areaInfo": [_jrCase.areaInfo dictionaryValue],
                                @"neighbourhoods": _jrCase.neighbourhoods,
                                @"roomNum": _jrCase.roomNum,
                                @"livingroomCount": _jrCase.livingroomCount,
                                @"bathroomCount": _jrCase.bathroomCount,
                                @"renovationStyle": _jrCase.projectStyle,
                                @"houseArea": _jrCase.houseArea,
                                @"budget": _jrCase.projectPrice,
                                @"budgetUnit": @"million",
                                @"description": _jrCase.desc,
                                @"roomTypeImageUrl": _jrCase.roomTypeImageUrl,
                                @"imageList": _imageURLs,
                                @"title": _jrCase.title};
        [[ALEngine shareEngine] pathURL:JR_CREATE_PROJECT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
            [self hideHUD];
            if (!error) {
                CreateCaseSuccessViewController *cv = [[CreateCaseSuccessViewController alloc] init];
                [self.navigationController pushViewController:cv animated:YES];
            }
        }];
    }
    
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _roomTypeImage ? 2 : 1;
    }else{
        return _caseImages.count + 1;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseImageCollectionCell";
    CaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 1) {
        [cell setImage:_roomTypeImage];
    }else if (indexPath.section == 1 && indexPath.row > 0){
        [cell setImage:_caseImages[indexPath.row-1]];
    }else{
        [cell setImage:[UIImage imageNamed:@"icon_add_image"]];
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
            [header setTitle:[NSString stringWithFormat:@"上传案例图（最多%d/20张）", _caseImages.count] lineHidden:NO];
        }
    }
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (!_roomTypeImage) {
            [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
                self.roomTypeImage = images.firstObject;
                [_collectionView reloadData];
            }];
        }else{
            [self showTip:@"户型图只限一张"];
        }
    }else if (indexPath.section == 1 && indexPath.row == 0){
        if (_caseImages.count < 20) {
            [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:20-_caseImages.count Handler:^(NSArray *images) {
                [_caseImages addObjectsFromArray:images];
                [_collectionView reloadData];
            }];
        }else{
            [self showTip:@"案例图片最多只能20张"];
        }
    }
}

@end
