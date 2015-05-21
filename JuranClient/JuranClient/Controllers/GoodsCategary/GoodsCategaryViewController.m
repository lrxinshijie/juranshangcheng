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
#import "DataItem.h"
#import "CustomBrandView.h"
#import "CategaryTableViewCell.h"
#import "pinyin.h"
#import "UserLocation.h"
#import "AppDelegate.h"
#import "NaviStoreSelCityViewController.h"
#import "JRAreaInfo.h"
#import "UIViewController+Menu.h"
#import "ProductListViewController.h"
#import "ProductFilterData.h"
#import "ProductSeletedFilter.h"


@interface GoodsCategaryViewController ()<UITableViewDataSource,UITableViewDelegate,CustomSecLevelViewDelegate,CustomThirdLevelCellDelegate,CustomShopViewDelegate,UIScrollViewDelegate>
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

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UITableView *fistLevelTableView;
@property (strong, nonatomic) IBOutlet UILabel *viewTitle;

@property (strong, nonatomic) NSMutableArray * dateArray_firstLevel;
@property (strong, nonatomic) NSMutableArray * dataArray_secondLevel;
@property (strong, nonatomic) NSMutableArray * dataArray_thirdLevel;

//记录一级类目点击的Button
@property (strong, nonatomic) CategaryTableViewCell * old_cell;
@property (assign, nonatomic) int old_cell_location;
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

@property (strong, nonatomic) NSMutableIndexSet * old_IndexSet;
@property (assign, nonatomic) int cellCount;

@property (assign, nonatomic) CategaryStyle vcStyle;

@property (assign, nonatomic) int pageNo;
@property (strong, nonatomic) NSString * brandName;

@property (strong, nonatomic) NSString * parentCodeProduct;

@end

@implementation GoodsCategaryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isPopNavHide:(BOOL)hide style:(CategaryStyle)style
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.isPopNavHide = hide;
        _finalDataArray = [NSMutableArray arrayWithCapacity:0];
        _old_location.viewNum = -1;
        _old_location.index = Location_None;
        _old_view = nil;
        _vcStyle = style;
        _pageNo = 1;
        _parentCodeProduct = @"";
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:self.isPopNavHide];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_vcStyle == CategaryStyle_Goods) {
        _viewTitle.text = @"商品所在地:北京市";
    }else if (_vcStyle == CategaryStyle_Shop){
        _viewTitle.text = @"品牌所在地:北京市";
    }
    [self.navigationController setNavigationBarHidden:YES];
    [self.listTableView setContentSize:CGSizeMake(243, 500)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始状态没有cell。
    self.cellCount = 0;
    //初始化数组什么的
    [self initData];
    if (self.vcStyle == CategaryStyle_Shop) {
        
        [self requestDataForBrandClass];
        
    }else if (self.vcStyle == CategaryStyle_Goods){
        
        [self requestDataWithRequestID:@"-1" city:self.locationButton.titleLabel.text level:1];
    }
    
    [self setLocation];
    
    __weak GoodsCategaryViewController * wSelf = self;
    [_listTableView addHeaderWithCallback:^{
        if (wSelf.vcStyle == CategaryStyle_Shop) {
            wSelf.pageNo = 1;
            [wSelf requestDataForBrand:wSelf.brandName pageNo:wSelf.pageNo];
        }
    }];
    [_listTableView addFooterWithCallback:^{
        if (wSelf.vcStyle == CategaryStyle_Shop) {
            wSelf.pageNo++;
            [wSelf requestDataForBrand:wSelf.brandName pageNo:wSelf.pageNo];
        }
    }];
    
    
}

- (void)setLocation
{
    if (ApplicationDelegate.gLocation.isSuccessLocation) {
        [self.locationButton setTitle:ApplicationDelegate.gLocation.cityName forState:UIControlStateNormal];
    }else{
        
    }
}

- (void)resetLocation
{
    if (ApplicationDelegate.gLocation.isSuccessLocation) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"已定位到当前位置" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        
    }else{
        NaviStoreSelCityViewController *vc = [[NaviStoreSelCityViewController alloc] init];
        __weak GoodsCategaryViewController * wSelf = self;
        [vc setFinishBlock:^(JRAreaInfo *areaInfo) {
            ApplicationDelegate.gLocation.cityName = areaInfo.cityName;
            [wSelf.locationButton setTitle:ApplicationDelegate.gLocation.cityName forState:UIControlStateNormal];
            if (wSelf.vcStyle == CategaryStyle_Shop) {
                
                [wSelf requestDataForBrandClass];
                
            }else if (wSelf.vcStyle == CategaryStyle_Goods){
                
                [wSelf requestDataWithRequestID:@"-1" city:wSelf.locationButton.titleLabel.text level:1];
            }
        }];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)initData
{
    self.sectionNumber = -1;
    self.dateArray_firstLevel = [NSMutableArray arrayWithCapacity:0];
    self.dataArray_secondLevel = [NSMutableArray arrayWithCapacity:0];
    self.dataArray_thirdLevel = [NSMutableArray arrayWithCapacity:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)locationButtonDidClick:(id)sender {
    
    //首先修改地址，
    [self resetLocation];
    //完成之后重新请求
    
}

- (IBAction)goBackButtonDidClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)moreFunctionButtonDidClick:(id)sender {
    
     [self showAppMenu:nil];
    
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _listTableView) {
        //多少段
        return self.dataArray_secondLevel.count;
        
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _listTableView) {
        return CellHeight;
    }else{
        return 51;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _listTableView) {
        if (section == self.currentSection) {
            return self.cellCount;
        }
        return 0;
    }else{
        return self.dateArray_firstLevel.count;
    }
}

//计算cell的个数
- (int)calculateCellNumber
{
    NSString * str;
    if (cslv_i<self.dataArray_thirdLevel.count) {
        DataItem * item = [self.dataArray_thirdLevel objectAtIndex:cslv_i];
        str = item.name;
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
    if (tableView == _listTableView) {
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
    }else{
        
        static NSString * cellID = @"CategaryTableViewCell";
        CategaryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CategaryTableViewCell" owner:self options:nil] lastObject];
        }
        
        [cell configCellUIWithItem:self.dateArray_firstLevel[indexPath.row]];
        if (!self.old_cell) {
            self.old_cell = cell;
            self.old_cell_location = (int)indexPath.row;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _listTableView) {
        
        if (self.vcStyle == CategaryStyle_Goods) {
            return 95;
        }else{
            return 83;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _listTableView) {
        
        if (self.vcStyle == CategaryStyle_Goods) {
            CustomSecLevelView * cView = [[[NSBundle mainBundle] loadNibNamed:@"CustomSecLevelView" owner:self options:nil] lastObject];
            cView.tag = 9000+section;
            cView.delegate = self;
            [cView initSecondLevelViewWithItem:self.dataArray_secondLevel[section]];
            
            return cView;
        }else if (self.vcStyle == CategaryStyle_Shop){
            
            CustomBrandView * csView = [[[NSBundle mainBundle] loadNibNamed:@"CustomBrandView" owner:self options:nil] lastObject];
            csView.delegate = self;
            [csView configViewUIWithItem:self.dataArray_secondLevel[section]];
            
            return csView;
            
        }
        
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _fistLevelTableView) {
        
        CategaryTableViewCell * cell = (CategaryTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        //请求数据
        if (self.vcStyle == CategaryStyle_Shop) {
            self.pageNo = 1;
            [self requestDataForBrand:cell.cell_id pageNo:self.pageNo];
        }else if (self.vcStyle == CategaryStyle_Goods){
            [self requestDataWithRequestID:cell.cell_id city:self.locationButton.titleLabel.text level:2];
        }
        
        if (self.old_cell) {
            [self.old_cell setCellTitleNormal];
            CategaryTableViewCellItem * item = self.dateArray_firstLevel[self.old_cell_location];
            item.isSelect = NO;
            
        }
        [cell setCellTitleSelect];
        int temp = (int)indexPath.row;
        CategaryTableViewCellItem * tempItem = self.dateArray_firstLevel[temp];
        tempItem.isSelect = YES;
        
        
        self.old_cell_location = (int)indexPath.row;
        self.old_cell = cell;
        
    }
}

#pragma mark - CustomSecLevelViewDelegate
- (void)secondLevelView:(CustomSecLevelView *)view didClickAtIndex:(struct SelectLocation)location requestID:(NSString *)rquestID
{
    self.parentCodeProduct = rquestID;
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
        
        SecondLevelItem * currentItem = [self.dataArray_secondLevel objectAtIndex:location.viewNum-9000];
        currentItem.isSelect = NO;
        currentItem.selectLocation = Location_None;
        if (location.index == Location_Left) {
            currentItem.lColor = NormalColor;
        }else if (location.index == Location_Middle){
            currentItem.mColor = NormalColor;
        }else if (location.index == Location_Right){
            currentItem.rColor = NormalColor;
        }
        
        _old_location.index = Location_None;
        _old_location.viewNum = -1;
        self.old_view = nil;
        
        [self refreashSectionAtIndexSet:indexSet sectionLocation:location];
        
    }else{
        //记录下需要刷新的section，用于请求完成之后刷新。
        self.old_IndexSet = indexSet;
        
        if (self.old_location.viewNum != -1) {
            SecondLevelItem * oldItem = [self.dataArray_secondLevel objectAtIndex:self.old_location.viewNum-9000];
            if (self.old_location.index == Location_Left) {
                oldItem.lColor = NormalColor;
            }else if (self.old_location.index == Location_Middle){
                oldItem.mColor = NormalColor;
            }else if (self.old_location.index == Location_Right){
                oldItem.rColor = NormalColor;
            }
        }
        
        
        SecondLevelItem * currentItem = [self.dataArray_secondLevel objectAtIndex:location.viewNum-9000];
        currentItem.isSelect = YES;
        currentItem.selectLocation = location.index;
        if (location.index == Location_Left) {
            currentItem.lColor = SelectColor;
        }else if (location.index == Location_Middle){
            currentItem.mColor = SelectColor;
        }else if (location.index == Location_Right){
            currentItem.rColor = SelectColor;
        }
        
        self.old_view = view;
        self.old_location = location;
        
        //请求数据
        [self requestDataWithRequestID:rquestID city:self.locationButton.titleLabel.text level:3];
    }
    
    
    
   
}

- (void)refreashSectionAtIndexSet:(NSIndexSet *)indexSet sectionLocation:(struct SelectLocation)location
{
    [_listTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    int distance = (location.viewNum-9000+1)*95+self.cellCount*31-self.listTableView.contentOffset.y-([UIScreen mainScreen].bounds.size.height - 64);
    if (distance>0) {
        [self.listTableView setContentOffset:CGPointMake(0, self.listTableView.contentOffset.y+distance+10) animated:YES];
    }
}

//其中level表示请求的是第几级类目，取值1、2、3。
- (void)requestDataWithRequestID:(NSString *)requestID city:(NSString *)city level:(int)level
{
    NSDictionary * dict = @{@"cityName":city, @"upperCategoryCode":requestID};
    
    __weak GoodsCategaryViewController * wSelf = self;
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GOODS_CATEGARY parameters:dict HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [wSelf hideHUD];
        if (!error) {
            
            //处理data
            NSMutableArray * dataArr;
            if ([data isKindOfClass:[NSDictionary class]]) {
                
                if (([(NSDictionary *)data objectForKey:@"categoryList"] == nil) || ([[(NSDictionary *)data objectForKey:@"categoryList"] isKindOfClass:[NSNull class]])) {
                    
                    dataArr = [NSMutableArray arrayWithArray:@[]];
                    
                }else{
                    
                    dataArr = [NSMutableArray arrayWithArray:[(NSDictionary *)data objectForKey:@"categoryList"]];
                    
                }
                
            }
            
            if (level == 1) {
                //请求一级类目完成，立马请求二级类目
                [wSelf.dateArray_firstLevel removeAllObjects];
                [wSelf.dataArray_secondLevel removeAllObjects];
                [wSelf.dataArray_thirdLevel removeAllObjects];
                [wSelf.finalDataArray removeAllObjects];
                
                for (int i=0; i<dataArr.count; i++) {
                    CategaryTableViewCellItem * dItem = [CategaryTableViewCellItem createCategaryTableViewCellItemWithDictionary:dataArr[i]];
                    if (i == 0){
                        dItem.isSelect = YES;
                    }
                    [wSelf.dateArray_firstLevel addObject:dItem];
                }
                
                [wSelf showHUD];
                CategaryTableViewCellItem * dataItem = wSelf.dateArray_firstLevel[0];
                [wSelf requestDataWithRequestID:dataItem.code city:city level:2];
                [wSelf.fistLevelTableView reloadData];
                
            }else if (level == 2){
                //请求二级类目完成
                [wSelf.dataArray_secondLevel removeAllObjects];
                [wSelf.dataArray_thirdLevel removeAllObjects];
                [wSelf.finalDataArray removeAllObjects];
                
                NSMutableArray * tempArr = [NSMutableArray arrayWithCapacity:0];
                for (int i=0; i<dataArr.count; i++) {
                    DataItem * dItem = [DataItem createDataItemWithDictionary:dataArr[i]];
                    [tempArr addObject:dItem];
                }
                
                int count = tempArr.count/3;
                if (tempArr.count%3 != 0) {
                    count += 1;
                }
                
                for (int j = 0; j<count; j++) {
                    
                    SecondLevelItem * sItem = [[SecondLevelItem alloc] initSecondLevelItem];
                    
                    if (j == count-1) {
                        
                        if (tempArr.count>j*3) {
                            DataItem * dItem1 = tempArr[j*3];
                            sItem.lImage = dItem1.imgStr;
                            sItem.lText = dItem1.name;
                            sItem.lID = dItem1.categoryCode;
                        }
                        
                        if (tempArr.count>(j*3+1)) {
                            DataItem * dItem2 = tempArr[j*3+1];
                            sItem.mImage = dItem2.imgStr;
                            sItem.mText = dItem2.name;
                            sItem.mID = dItem2.categoryCode;
                        }
                        
                        if (tempArr.count>(j*3+2)) {
                            DataItem * dItem3 = tempArr[j*3+2];
                            sItem.rImage = dItem3.imgStr;
                            sItem.rText = dItem3.name;
                            sItem.rID = dItem3.categoryCode;
                        }
                        
                    }else{
                        
                        DataItem * dItem1 = tempArr[j*3];
                        DataItem * dItem2 = tempArr[j*3+1];
                        DataItem * dItem3 = tempArr[j*3+2];
                        
                        sItem.lImage = dItem1.imgStr;
                        sItem.lText = dItem1.name;
                        sItem.lID = dItem1.categoryCode;
                        sItem.mImage = dItem2.imgStr;
                        sItem.mText = dItem2.name;
                        sItem.mID = dItem2.categoryCode;
                        sItem.rImage = dItem3.imgStr;
                        sItem.rText = dItem3.name;
                        sItem.rID = dItem3.categoryCode;
                        
                    }
                    
                    [wSelf.dataArray_secondLevel addObject:sItem];
                    
                }
                _old_location.viewNum = -1;
                _old_location.index = Location_None;
                wSelf.old_view = nil;
                wSelf.cellCount = 0;
                [wSelf.listTableView reloadData];
                
                
            }else if (level == 3){
                //请求三级类目完成
                [wSelf.dataArray_thirdLevel removeAllObjects];
                [wSelf.finalDataArray removeAllObjects];
                
                for (int i=0; i<dataArr.count; i++) {
                    DataItem * dItem = [DataItem createDataItemWithDictionary:dataArr[i]];
                    [wSelf.dataArray_thirdLevel addObject:dItem];
                }
                
                //计算多少有个cell
                wSelf.cellCount = [wSelf calculateCellNumber];
                [wSelf cleanData];
                
                
                //刷新section
                [wSelf refreashSectionAtIndexSet:wSelf.old_IndexSet sectionLocation:self.old_location];
                
            }
            
        }
        
    }];
    
}

#pragma mark - CustomThirdLevelCellDelegate
- (void)thirdLevelItemDidSelectedWithCatCode:(NSString *)catCode CatName:(NSString *)catName ParentCode:(NSString *)parentCode UrlContent:(NSString *)urlContent
{
    //商品的
//    NSLog(@"%@",msg);
    ProductListViewController *vc = [[ProductListViewController alloc]init];
    vc.selectedFilter = [[ProductSelectedFilter alloc]init];
    vc.selectedFilter.isInShop = NO;
    vc.selectedFilter.sort = 9;
    vc.selectedFilter.keyword = @"";
    vc.selectedFilter.pCategory = [[ProductCategory alloc]init];
    vc.selectedFilter.pCategory.catCode = catCode;
    vc.selectedFilter.pCategory.catName = catName;
    //传参过来的ParentCode暂时无用，暂不使用。
    vc.selectedFilter.pCategory.parentCode = self.parentCodeProduct;
    vc.selectedFilter.pCategory.urlContent = urlContent;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CustomShopViewDelegate
- (void)shopViewItemDidClickWithCode:(NSString *)brandCode Name:(NSString *)brandName ID:(long)brandID
{
    //品牌
    ProductListViewController *vc = [[ProductListViewController alloc]init];
    vc.selectedFilter = [[ProductSelectedFilter alloc]init];
    vc.selectedFilter.isInShop = NO;
    vc.selectedFilter.sort = 9;
    vc.selectedFilter.keyword = @"";
    vc.selectedFilter.pBrand = [[ProductBrand alloc]init];
    vc.selectedFilter.pBrand.catCode = brandCode;
    vc.selectedFilter.pBrand.brandId = brandID;
    vc.selectedFilter.pBrand.brandName = brandName;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 品牌分类的东西
- (void)requestDataForBrandClass
{
    //http://54.223.161.28:8080/mall/brandClassification.json
    __weak GoodsCategaryViewController * wSelf = self;
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_BRAND_CLASS parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [wSelf hideHUD];
        [wSelf.dateArray_firstLevel removeAllObjects];
        [wSelf.dataArray_secondLevel removeAllObjects];
        
        NSMutableArray * tempArr = [NSMutableArray arrayWithCapacity:0];
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            
            if (([(NSDictionary *)data objectForKey:@"getAttriList"] == nil) || ([[(NSDictionary *)data objectForKey:@"getAttriList"] isKindOfClass:[NSNull class]])) {
                
                [tempArr addObjectsFromArray:@[]];
                
            }else{
                
                [tempArr addObjectsFromArray:[(NSDictionary*)data objectForKey:@"getAttriList"]];
                
            }
            
        }
        for (int i=0; i<tempArr.count; i++) {
            CategaryTableViewCellItem * item = [CategaryTableViewCellItem createCategaryTableViewCellItemWithDictionary:tempArr[i]];
            if (i == 0) {
                item.isSelect = YES;
            }
            [wSelf.dateArray_firstLevel addObject:item];
            if (i == 0) {
                [wSelf requestDataForBrand:item.code pageNo:wSelf.pageNo];
            }
            
        }
        
        [wSelf.fistLevelTableView reloadData];
        
    }];
    
    
}

//- (NSString *)getFirstLetter:(NSString *)str
//{
//    NSMutableString * firstLetter = [NSMutableString stringWithString:@""];
//    for (int i=0; i<str.length; i++) {
//        [firstLetter appendString:[NSString stringWithFormat:@"%c",pinyinFirstLetter([str characterAtIndex:i])]];
//        str = [str substringFromIndex:1];
//    }
//    return firstLetter;
//}

- (void)requestDataForBrand:(NSString *)brandClass pageNo:(int)pageNo
{
    //http://54.223.161.28:8080/mall/getByBrandClassification.json
    [self showHUD];
    __weak GoodsCategaryViewController * wSelf = self;
    self.brandName = brandClass;
    NSDictionary * dict = @{@"brandTypeCode":brandClass,
                            @"pageNo":[NSString stringWithFormat:@"%d",self.pageNo],
                            @"onePageCount":kOnePageCount
                            };
    [[ALEngine shareEngine] pathURL:JR_BRAND_LIST parameters:dict HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [wSelf hideHUD];
        
        if (wSelf.pageNo == 1) {
            [wSelf.dataArray_secondLevel removeAllObjects];
        }
        
        NSMutableArray * tempArr = [NSMutableArray arrayWithCapacity:0];
        if ([data isKindOfClass:[NSDictionary class]]) {
            [tempArr addObjectsFromArray:[(NSDictionary *)data objectForKey:@"brandForMallDtoList"]];
        }
        int count = tempArr.count%2?tempArr.count/2+1:tempArr.count/2;
        for (int i=0; i<count; i++) {
            ShopViewItem * sItem = [[ShopViewItem alloc] init];
            
            if (i == count-1) {
                
                if (!(tempArr.count%2)) {
                    sItem.lImageURL = [tempArr[i*2] objectForKey:@"brandLogo"];
                    sItem.lText = [tempArr[i*2] objectForKey:@"brandName"];
                    sItem.lcode = [tempArr[i*2] objectForKey:@"brandCode"];
                    sItem.lid = [[tempArr[i*2] objectForKey:@"id"] longValue];
                    
                    sItem.rImageURL = [tempArr[i*2+1] objectForKey:@"brandLogo"];
                    sItem.rText = [tempArr[i*2+1] objectForKey:@"brandName"];
                    sItem.rcode = [tempArr[i*2+1] objectForKey:@"brandCode"];
                    sItem.rid = [[tempArr[i*2+1] objectForKey:@"id"] longValue];
                }else{
                    sItem.lImageURL = [tempArr[i*2] objectForKey:@"brandLogo"];
                    sItem.lText = [tempArr[i*2] objectForKey:@"brandName"];
                    sItem.lcode = [tempArr[i*2] objectForKey:@"brandCode"];
                    sItem.lid = [[tempArr[i*2] objectForKey:@"id"] longValue];
                }
                
            }else{
                
                sItem.lImageURL = [tempArr[i*2] objectForKey:@"brandLogo"];
                sItem.lText = [tempArr[i*2] objectForKey:@"brandName"];
                sItem.lcode = [tempArr[i*2] objectForKey:@"brandCode"];
                sItem.lid = [[tempArr[i*2] objectForKey:@"id"] longValue];
                
                sItem.rImageURL = [tempArr[i*2+1] objectForKey:@"brandLogo"];
                sItem.rText = [tempArr[i*2+1] objectForKey:@"brandName"];
                sItem.rcode = [tempArr[i*2+1] objectForKey:@"brandCode"];
                sItem.rid = [[tempArr[i*2+1] objectForKey:@"id"] longValue];
                
            }
            
            [wSelf.dataArray_secondLevel addObject:sItem];
            
        }
        
        [wSelf.listTableView headerEndRefreshing];
        [wSelf.listTableView footerEndRefreshing];
        [wSelf.listTableView reloadData];
    }];
    
    
}
















@end
