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
#import "CaseEditStyleViewController.h"
#import "JRCaseImage.h"
#import "CaseImagePreviewViewController.h"
#import "UIActionSheet+Blocks.h"

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
    
    if (_jrCase.projectId.length > 0) {
        [self showHUD];
        [_jrCase loadDetail:^(BOOL result) {
            [self hideHUD];
            
            if (result) {
                [_collectionView reloadData];
            }else{
                [super back:nil];
            }
            
        }];
    }
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
        vc.jrCase = _jrCase;
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
    
    JRCaseImage *caseImage = [_caseImages objectAtTheIndex:idx];

    if (caseImage) {
        [self setHUDTitle:[NSString stringWithFormat:@"上传效果图%d/%d...", idx+1,[_caseImages count]]];
        [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":caseImage.image} responseHandler:^(NSError *error, id data, NSDictionary *other) {
            if (!error) {
                caseImage.imageUrl = [data objectForKey:@"imgUrl"];
                [_imageURLs addObject:[caseImage dictionaryValue]];
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
    if (_jrCase.projectId.length > 0) {
        if (section == 0) {
            return 1;
        }else{
            return _jrCase.detailImageList.count;
        }
    }else{
        if (section == 0) {
            return _roomTypeImage ? 2 : 1;
        }else{
            return _caseImages.count + 1;
        }
    }
    
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseImageCollectionCell";
    CaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_jrCase.projectId.length > 0) {
        if (indexPath.section == 0) {
            [cell.imageView setImageWithURLString:_jrCase.frontImgUrl];
        }else{
            [cell.imageView setImageWithURLString:_jrCase.detailImageList[indexPath.row]];
        }
    }else{
        if (indexPath.section == 0 && indexPath.row == 1) {
            [cell setImage:_roomTypeImage];
        }else if (indexPath.section == 1 && indexPath.row > 0){
            JRCaseImage *caseImage = _caseImages[indexPath.row-1];
            [cell setImage:caseImage.image];
        }else{
            [cell setImage:[UIImage imageNamed:@"icon_add_image"]];
        }
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
    if (_jrCase.projectId.length > 0) {
        return;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (!_roomTypeImage) {
                [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
                    self.roomTypeImage = [images firstObject];
                    [_collectionView reloadData];
                }];
            }else{
                [self showTip:@"户型图只限一张"];
            }
        }else{
            [UIActionSheet showInView:[UIApplication sharedApplication].keyWindow withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"删除"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == [actionSheet cancelButtonIndex]) {
                    return ;
                }
                
                self.roomTypeImage = nil;
                [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
            }];
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            if (_caseImages.count < 20) {
                CaseEditStyleViewController *ce = [[CaseEditStyleViewController alloc] init];
                ce.block = ^(JRCaseImage *image){
                    if (_caseImages.count == 0) {
                        image.frontFlag = YES;
                    }
                    
                    [_caseImages addObject:image];
                    [_collectionView reloadData];
                };
                [self.navigationController pushViewController:ce animated:YES];
                
            }else{
                [self showTip:@"案例图片最多只能20张"];
            }
        }else{
            CaseImagePreviewViewController *ci = [[CaseImagePreviewViewController alloc] init];
            ci.caseImage = [_caseImages objectAtIndex:indexPath.row-1];
            ci.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            ci.block = ^(JRCaseImage *image, CaseImageEvent event){
                if (event == CaseImageEventChange) {
                    [_collectionView reloadData];
                }else if (event == CaseImageEventCover){
                    [_caseImages enumerateObjectsUsingBlock:^(JRCaseImage *caseImage, NSUInteger idx, BOOL *stop) {
                        caseImage.frontFlag = NO;
                    }];
                    
                    image.frontFlag = YES;
                    
                }else if (event == CaseImageEventDelete){
                    [_caseImages removeObject:image];
                    [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    if (image.frontFlag) {
                        JRCaseImage *caseImage = [_caseImages firstObject];
                        if (caseImage) {
                            caseImage.frontFlag = YES;
                        }
                    }
                    
                }
            };
            [self presentViewController:ci animated:YES completion:nil];
        }
        
    }
}

@end
