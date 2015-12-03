//
//  AddCommentViewController.m
//  JuranClient
//
//  Created by 123 on 15/11/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "AddCommentViewController.h"
#import "ALGetPhoto.h"
#import "JRUser.h"
#import "ImageViewCell.h"
#import "CommentListViewController.h"

#define  KremainCount 120
#define KplaceHolder @"您还满意么？请留下你的评价，最少评论5字"


@interface AddCommentViewController ()<UITextViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ImageViewCellDelete,CommentStarViewDelegate>
{
    NSString* filePath;
    // NSMutableArray *selectedPhotos;
    NSMutableArray *array;
    UIScrollView *imageScrollView;
    UIPageControl *pageControl;
    NSString *files;
}

@property(nonatomic,strong) NSMutableArray *selectedPhotos;
@end



@implementation AddCommentViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我要点评";
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(addCommentClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], UITextAttributeFont, RGBColor(80, 130, 191), UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    self.textView.delegate=self;
    self.textView.text=KplaceHolder;
    _textView.textColor=[UIColor lightGrayColor];
    self.labRemain.text=[NSString stringWithFormat:@"还可以写%d字",KremainCount];
    [_commentStarView setEnable:YES];
    _commentStarView.delegate=self;
    _selectedPhotos=[NSMutableArray array];
    
    
//    _collectionView.backgroundColor = [UIColor whiteColor];
    
//    [_collectionView registerNib:[UINib nibWithNibName:@"ImageViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCell"];
    
    
    [self.collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:@"ImageViewCell"];
        self.collectionView.backgroundColor=[UIColor whiteColor];
    // __block AddCommentViewController *blockSelf = self;
    array=[NSMutableArray array];
    [array addObject:@"image_addDefault.png"];
    // Do any additional setup after loading the view from its nib.
}


-(void)didSelectedStarView:(CommentStarView *)starView
{
    self.labStarCount.text = [NSString stringWithFormat:@"%d星", starView.selectedIndex];
    
}






- (void)addCommentClick{
    
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSInteger userId=[JRUser currentUser].userId;
    NSInteger type=_InActionType;
    NSInteger relId=self.relId;
    NSInteger rank=_commentStarView.selectedIndex;
    NSString *content=self.textView.text;
    if(content.length<5 || [content isEqualToString:KplaceHolder])
    {
        [self showTip:@"最少五个字"];
        return;
    }
    
    if(content.length>120)
    {
        [self showTip:@"最多120个字"];
        return;
    }
    
    if(rank==0)
    {
        [self showTip:@"星级不能为空"];
        return;
    }
    
    
    
    [param setValue:@(userId) forKey:@"userId"];
    [param setValue:@(type) forKey:@"type"];
    
    [param setValue:@(relId) forKey:@"relId"];
    
    [param setValue:@(rank) forKey:@"rank"];
    [param setValue:content forKey:@"content"];
    
    NSMutableString *imagePaths=[[NSMutableString alloc] init];
    
    int index=0;
    
    
    for (NSString *path in array) {
        
        if([path isEqualToString:@"image_addDefault.png"])
        {
            continue;
        }
        
        if(index==array.count-1)
        {
            [imagePaths appendFormat:@"%@",path ];
            
        }
        else
        {
            [imagePaths appendFormat:@"%@|",path ];
        }
        index++;
    }
    
    
    
    
    [param setValue:imagePaths forKey:@"files"];
    
    [self showHUD];

    
            [[ALEngine shareEngine] pathURL:JR_ADDREVIEW parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self  responseHandler:^(NSError *error, id data, NSDictionary *other) {
                [self hideHUD];

                if (!error) {
//                    [self.navigationController popViewControllerAnimated:YES];
                    
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[CommentListViewController class]]) {
                            CommentListViewController *com=(CommentListViewController *)temp;
                            [com refreshPage];

                            [self.navigationController popToViewController:com animated:YES];
                            break;
                        }
                    }
                }
    

            }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uploadImage:(UIButton *)btnDelete image:(UIImage *)image
{
    [self showHUDFromTitle:@"上传图片..."];
    //
    [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":image} responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            files = [data objectForKey:@"imgUrl"];
            
            array[array.count-1]=files;
            
            if(array.count<3)
            {
                [array addObject:@"image_addDefault.png"];
            }
            
            [self.collectionView reloadData];
            btnDelete.hidden=NO;
            btnDelete.userInteractionEnabled=YES;
            
            
            //图片以｜分割
            // NSLog(@"path: %@",path);
        }
    }];
    [self hideHUD];
    
    //
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"您还满意么？请留下你的评价，最少评论5字"]) {
        textView.text = @"";
        _textView.textColor=[UIColor blackColor];

    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"您还满意么？请留下你的评价，最少评论5字";
        _textView.textColor=[UIColor lightGrayColor];

    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    int count=textView.text.length;
    if(count<=KremainCount)
    {
        self.labRemain.text=[NSString stringWithFormat:@"还可以写%d字",KremainCount-count];
        self.labRemain.textColor=[UIColor darkGrayColor];

    }
    else
    {
        self.labRemain.text=[NSString stringWithFormat:@"已超出%d字",count-KremainCount];
        self.labRemain.textColor=[UIColor redColor];
    }
    
    if(count<=5)
    {
        self.labRemainCount.text=[NSString stringWithFormat:@"还差%d字",5-count];
        
    }
    else
    {
        self.labRemainCount.text=@"还差0字";
        
    }
}


//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//
//{
//    
//    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    
//    if ([string length] > 120)
//        
//    {
//        
//        string = [string substringToIndex:120];
//        
//    }
//    
//    textView.text = string;
//    
//    return NO;
//    
//}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ImageViewCell";
    
    
    ImageViewCell *cell = (ImageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger i=indexPath.row;
   

    [cell setImage:array[i]];
    

    cell.delegate=self;
    
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return array.count;
}


-(void)deletePhoto:(UIButton *)btnDelete ZoomInImageView:(ZoomInImageView *)imageView
{
    [array removeObject:imageView.url];
    
    if(![array containsObject:@"image_addDefault.png"])
    {
        [array addObject:@"image_addDefault.png"];

    }
    
    [self.collectionView reloadData];
}



-(void)addPhoto:(UIButton *)btnDelete
{
    if(!btnDelete.isHidden) return;
    
    [[ALGetPhoto sharedPhoto] showInViewController:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
        //        [array addObjectsFromArray:images];
        //        [self.collectionView reloadData];
        
        [self uploadImage:btnDelete image:images[0]];
      
    }];
    
}




//-(void)showImage:(NSIndexPath *)indexPath{
//
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;
//    CGRect rect=[UIScreen mainScreen].bounds;
//
//    imageScrollView=[[UIScrollView alloc] initWithFrame:rect];
//    [imageScrollView setContentSize:CGSizeMake(kWindowWidth*array.count, kWindowHeight)];
//    imageScrollView.bounces=YES;
//    imageScrollView.pagingEnabled=YES;
//    imageScrollView.delegate=self;
//    imageScrollView.backgroundColor=[UIColor blackColor];
//    CGFloat y=0;
//
//    UIImageView *leftimageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, y, kWindowWidth, kWindowHeight/2)];
//    leftimageView.center=CGPointMake(kWindowWidth/2, kWindowHeight/2);
//    leftimageView.image=[array objectAtIndex:0];
//
//    [imageScrollView addSubview:leftimageView];
//
//    for (int i=0; i<array.count; i++) {
//        if(i>0)
//        {
//
//            UIImageView *ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(i*kWindowWidth, leftimageView.frame.origin.y, kWindowWidth, kWindowHeight/2)];
//            ImageView.image=[array objectAtIndex:i];
//            [imageScrollView addSubview:ImageView];
//
//        }
//    }
//
//
//
//
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
//    [imageScrollView addGestureRecognizer: tap];
//
//    [imageScrollView setContentOffset:CGPointMake(indexPath.row*kWindowWidth, 0)];
//    [window addSubview:imageScrollView];
//
//    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, kWindowHeight-30, kWindowWidth, 30)];
//    pageControl.numberOfPages=array.count;
//    pageControl.currentPage=indexPath.row+1;
//    pageControl.tag=1003;
//    // [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数
//    [window addSubview:pageControl];
//    //
//    [UIView animateWithDuration:0.3 animations:^{
//        //
//        //            bigimageView.frame=CGRectMake(0, 0, kWindowWidth, kWindowHeight/2);
//        //            bigimageView.center=CGPointMake(kWindowWidth/2, kWindowHeight/2);
//
//    } completion:^(BOOL finished) {
//
//
//    }];
//}
//
//#pragma mark -UIScrollViewDelegate
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//
//    int current=scrollView.contentOffset.x/kWindowWidth;
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;
//    UIPageControl *pageControlTemp=(UIPageControl*)[window viewWithTag:1003];
//    pageControlTemp.currentPage=current;
//
//}
//
//-(void)hideImage:(UITapGestureRecognizer*)tap{
//    UIScrollView *backgroundView=(UIScrollView *)tap.view;
//    //    UIImageView *backgroundView=(UIImageView*)[tap.view viewWithTag:1003];
//    [UIView animateWithDuration:0.3 animations:^{
//        [backgroundView removeFromSuperview];
//
//        [pageControl removeFromSuperview];
//    } completion:^(BOOL finished) {
//    }];
//}
//
//




@end
