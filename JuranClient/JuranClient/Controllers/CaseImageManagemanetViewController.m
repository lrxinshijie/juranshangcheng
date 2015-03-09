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
#import "CaseManagementViewController.h"

@interface CaseImageManagemanetViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageURLs;

@end

@implementation CaseImageManagemanetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onIntroduce:) title:@"提交" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
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
    
    if (_jrCase.imageList.count == 0) {
        [self showTip:@"效果图不能为空"];
        return;
    }
    
    [self submitCase];
}

- (void)submitCase{
    if (![self checkLogin]) {
        return;
    }
    
    self.imageURLs = [NSMutableArray array];
    
    
    if (_jrCase.roomTypeImage && _jrCase.roomTypeImageUrl.length == 0) {
        [self showHUDFromTitle:@"上传户型图..."];
        [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":_jrCase.roomTypeImage} responseHandler:^(NSError *error, id data, NSDictionary *other) {
            if (!error) {
                _jrCase.roomTypeImageUrl = [data objectForKey:@"imgUrl"];
                [self uploadCaseImage:0];
            }else{
                [self hideHUD];
            }
        }];
    }else{
        [self showHUDFromTitle:@""];
        [self uploadCaseImage:0];
    }
}

- (void)uploadCaseImage:(NSInteger)idx{
    ASLog(@"upload idx:%d", idx);
    
    JRCaseImage *caseImage = [_jrCase.imageList objectAtTheIndex:idx];

    if (caseImage) {
        [self setHUDTitle:[NSString stringWithFormat:@"上传效果图%d/%d...", idx+1,[_jrCase.imageList count]]];
        if (caseImage.imageUrl.length > 0) {
            [_imageURLs addObject:[caseImage dictionaryValue]];
            NSInteger ind = idx + 1;
            [self uploadCaseImage:ind];
        }else{
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
        }
        
    }else{
        NSMutableDictionary *param =[NSMutableDictionary dictionaryWithDictionary:
                                    @{@"areaInfo": [_jrCase.areaInfo dictionaryValue],
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
                                @"title": _jrCase.title}];
        if (_jrCase.projectId.length > 0) {
            [param setObject:_jrCase.projectId forKey:@"projectId"];
        }
        [[ALEngine shareEngine] pathURL:_jrCase.projectId.length > 0 ? JR_EDIT_PROJECT : JR_CREATE_PROJECT parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
            [self hideHUD];
            if (!error) {
                if (_jrCase.projectId.length > 0) {
                    CaseManagementViewController *cm = (CaseManagementViewController *)[self.navigationController.viewControllers objectAtTheIndex:1];
                    if (cm && [cm isKindOfClass:[CaseManagementViewController class]]) {
                        [cm refreshView];
                        [self.navigationController popToViewController:cm animated:YES];
                    }
                }else{
                    CreateCaseSuccessViewController *cv = [[CreateCaseSuccessViewController alloc] init];
                    [self.navigationController pushViewController:cv animated:YES];
                }
                
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
        return _jrCase.roomTypeImage || _jrCase.roomTypeImageUrl.length > 0 ? 2 : 1 ;
    }else{
        return _jrCase.imageList.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseImageCollectionCell";
    CaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (_jrCase.roomTypeImage) {
            [cell setImage:_jrCase.roomTypeImage];
        }else{
            [cell.imageView setImageWithURLString:_jrCase.roomTypeImageUrl Editing:YES];
        }
    }else if (indexPath.section == 1 && indexPath.row > 0){
        JRCaseImage *caseImage = _jrCase.imageList[indexPath.row-1];
        if (caseImage.image) {
            [cell setImage:caseImage.image];
        }else{
            [cell.imageView setImageWithURLString:caseImage.imageUrl Editing:YES];
        }
        
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
            [header setTitle:[NSString stringWithFormat:@"上传案例图（最多%d/20张）", _jrCase.imageList.count] lineHidden:NO];
        }
    }
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (!_jrCase.roomTypeImage && _jrCase.roomTypeImageUrl.length == 0) {
                [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
                    _jrCase.roomTypeImage = [images firstObject];
                    _jrCase.roomTypeImageUrl = @"";
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
                
                _jrCase.roomTypeImage = nil;
                _jrCase.roomTypeImageUrl = @"";
                [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
            }];
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            if (_jrCase.imageList.count < 20) {
                CaseEditStyleViewController *ce = [[CaseEditStyleViewController alloc] init];
                ce.block = ^(JRCaseImage *image){
                    if (_jrCase.imageList.count == 0) {
                        image.frontFlag = YES;
                    }
                    
                    [_jrCase.imageList addObject:image];
                    [_collectionView reloadData];
                };
                [self.navigationController pushViewController:ce animated:YES];
                
            }else{
                [self showTip:@"案例图片最多只能20张"];
            }
        }else{
            CaseImagePreviewViewController *ci = [[CaseImagePreviewViewController alloc] init];
            ci.caseImage = [_jrCase.imageList objectAtIndex:indexPath.row-1];
            ci.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            ci.block = ^(JRCaseImage *image, CaseImageEvent event){
                if (event == CaseImageEventChange) {
                    [_collectionView reloadData];
                }else if (event == CaseImageEventCover){
                    [_jrCase.imageList enumerateObjectsUsingBlock:^(JRCaseImage *caseImage, NSUInteger idx, BOOL *stop) {
                        caseImage.frontFlag = NO;
                    }];
                    
                    image.frontFlag = YES;
                    
                }else if (event == CaseImageEventDelete){
                    [_jrCase.imageList removeObject:image];
                    [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    if (image.frontFlag) {
                        JRCaseImage *caseImage = [_jrCase.imageList firstObject];
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
