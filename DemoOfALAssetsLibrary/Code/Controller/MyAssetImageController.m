//
//  MyAssetImageController.m
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetImageController.h"
#import "MyAssetImageCollectionViewCell.h"
#import "MyAssetImageDetailController.h"
#import "MyAssetImageToolBar.h"

@interface MyAssetImageController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MyAssetImageCollectionViewCellDelegate,MyAssetImageToolBarDelegate>
{
    UICollectionView    *myCollectionView;
    MyAssetImageToolBar *toolBar;
    /**
     *  存放图片的数组
     */
    NSMutableArray   *allPhotosArray;
    /**
     *  已选的图片
     */
    NSMutableArray    *selectArray;
}
@end

@implementation MyAssetImageController
@synthesize albumModel;

- (id)init {
    self = [super init];
    if (self)
    {
        selectArray    = [NSMutableArray array];
        allPhotosArray = [NSMutableArray array];
        /**
         *  默认最大支持数量为9
         */
        self.maxSelectItem = 9;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor              = [UIColor whiteColor];
    self.title                             = albumModel.albumName;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self getImages];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 创建UI

- (void)setupUI {
    myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) collectionViewLayout:[UICollectionViewFlowLayout new]];
    myCollectionView.backgroundColor = [UIColor whiteColor];
    myCollectionView.showsVerticalScrollIndicator = YES;
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [myCollectionView registerClass:[MyAssetImageCollectionViewCell class] forCellWithReuseIdentifier:@"MyAssetImageCollectionViewCell"];
    [self.view addSubview:myCollectionView];
    
    toolBar = [[MyAssetImageToolBar alloc]initWithFrame:AppFrame(0,self.view.height-49,AppWidth,49)];
    toolBar.backgroundColor = UIColorFromRGB(0xf9f9f9);
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    
    if (allPhotosArray.count >0)
    {
       [myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(allPhotosArray.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return allPhotosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"MyAssetImageCollectionViewCell";
    MyAssetImageCollectionViewCell *collectionViewCell = (MyAssetImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    collectionViewCell.delegate = self;
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >=allPhotosArray.count)
    {
        return;
    }
    WJQAssetModel *model = allPhotosArray[indexPath.row];
    ((MyAssetImageCollectionViewCell *)cell).indexPath = indexPath;
    [((MyAssetImageCollectionViewCell *)cell) initCellWithModel:model];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  这个需要根据当前屏幕的宽度进行计算
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    int a = 4;
    
    CGFloat imageWidth = (width - (a + 1)*3.0)/a;
    
    return CGSizeMake(imageWidth, imageWidth);
}

//每个小cell的具体位置参数
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

//返回----具体看视图里的（For Cells）的属性
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//返回分割区的大小---具体看视图里的（For Lines）的属性
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 3;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >=allPhotosArray.count)
    {
        return;
    }
    MyAssetImageDetailController *vc = [[MyAssetImageDetailController alloc]init];
    vc.allPhotoArray                 = allPhotosArray;
    vc.haveSelectPhotoArray          = selectArray;
    vc.currentPhotoIndex             = indexPath.row;
    [vc setSelectedPhotoBlock:^(NSInteger idx, WJQAssetModel *model) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        [allPhotosArray replaceObjectAtIndex:idx withObject:model];
        [myCollectionView reloadItemsAtIndexPaths:@[tempIndexPath]];
        [toolBar reloadToolBarWithArray:selectArray];
    }];
    
    [vc setOKBlock:^(NSArray *haveSelectedArray) {
        [self okBtnPressed];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------------------ MyAssetImageCollectionViewCellDelegate --------------

- (void)selectBtnPressedWithIndexPath:(NSIndexPath *)indexPath {
    /**
     *  是否需要刷新编辑行
     */
    BOOL needReload = NO;
    
    WJQAssetModel *model = allPhotosArray[indexPath.row];
    BOOL isContain       = [selectArray containsObject:model];
    if (isContain)
    {
        /**
         *  如果已经包含则去掉选中状态
         */
        [selectArray removeObject:model];
        model.isSelected = NO;
        needReload       = YES;
    }
    else
    {
        if (selectArray.count < self.maxSelectItem)
        {
            [selectArray addObject:model];
            model.isSelected = YES;
            needReload       = YES;
        }
        else
        {
            
            NSString *title = [NSString stringWithFormat:@"你最多只能选择%d张照片",self.maxSelectItem];
            [self showAlertWithTitle:title];
            needReload  = NO;
        }
    }
    
    if (needReload)
    {
        [allPhotosArray replaceObjectAtIndex:indexPath.row withObject:model];
        [myCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        [toolBar reloadToolBarWithArray:selectArray];
    }
}

#pragma mark - MyAssetImageToolBarDelegate

- (void)okBtnPressed {
    NSLog(@"确定");
    NSMutableArray *selectedImagesArr = [NSMutableArray array];
    [selectArray enumerateObjectsUsingBlock:^(WJQAssetModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [[WJQAlbumManager sharedManager]getPhotoWithAsset:model.asset photoWidth:AppWidth completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            [selectedImagesArr addObject:photo];
        }];
    }];
    if ([self.delegate respondsToSelector:@selector(myAssetImageController:didFinishSelectImage:)])
    {
        [self.delegate myAssetImageController:self didFinishSelectImage:selectedImagesArr];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark ------------------ 获取该相册下的所有照片 --------------

- (void)getImages {
    [[WJQAlbumManager sharedManager]getSelectedAlbumPhotoByFetchResult:albumModel.albumResult IsAllowPickingVideo:NO completion:^(NSArray *allPhotoArray) {
        [allPhotosArray addObjectsFromArray:allPhotoArray];
    }];
}

#pragma mark ------------------ 按钮点击事件 --------------

- (void)cancle {
    if ([self.delegate respondsToSelector:@selector(didCancleSelect:)])
    {
        [self.delegate didCancleSelect:self];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - 图片选择达到限制提示框

- (void)showAlertWithTitle:(NSString *)title {
    if (iOS8Later)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
    }
}


@end
