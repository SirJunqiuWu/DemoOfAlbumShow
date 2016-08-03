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
#import "MyAssetPickerToolbar.h"

@interface MyAssetImageController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MyAssetImageCollectionViewCellDelegate,MyAssetPickerToolbarDelegate>
{
    UICollectionView *myCollectionView;
    /**
     *  存放图片的数组
     */
    NSMutableArray *allPhotosArray;
    /**
     *  已选的图片
     */
    NSMutableArray *selectArray;
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
    
    myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) collectionViewLayout:[UICollectionViewFlowLayout new]];
    myCollectionView.backgroundColor = [UIColor whiteColor];
    myCollectionView.showsVerticalScrollIndicator = YES;
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [myCollectionView registerClass:[MyAssetImageCollectionViewCell class] forCellWithReuseIdentifier:@"MyAssetImageCollectionViewCell"];
    [self.view addSubview:myCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    }

    
//    //判断是添加还是取消 -- 获取当前的ALAsset对象，
//    ALAsset *tpAsset = [assets objectAtIndex:indexPath.row];
//    BOOL containsObject = [selectArray containsObject:tpAsset];
//    if (containsObject == YES)
//    {
//        //已经存在，则需要进行一个更改
//        [selectArray removeObject:tpAsset];
//        needChangeState = YES;
//    }
//    else
//    {
//        if (selectArray.count < self.maxSelectItem)
//        {
//            [selectArray addObject:tpAsset];
//            needChangeState = YES;
//        }
//        else
//        {
//            needChangeState = NO;
//            UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%d张照片",self.maxSelectItem] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//            [myAlertView show];
//        }
//    }
//    
//    if (needChangeState == YES)
//    {
//        //需要对单个的collectionViewCell进行更新
//        NSArray *indePathArray = [NSArray arrayWithObjects:indexPath, nil];
//        [myCollectionView reloadItemsAtIndexPaths:indePathArray];
//        
//        //同时需要更改导航的标题
//        
//        //更改toolbar的状态
//        if (selectArray.count >0)
//        {
//            self.title = [NSString stringWithFormat:@"已选择%d张照片",(int)selectArray.count];
//            toolbar.buttonCanTouch = YES;
//        }
//        else
//        {
//            self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
//            toolbar.buttonCanTouch = NO;
//        } 
//    }
}

#pragma mark - MyAssetPickerToolbarDelegate

- (void)myAssetPickerToolbar:(MyAssetPickerToolbar *)toolbar leftButtonIsTouch:(UIButton *)paramSender {
    //视图控制器内部实现
}

- (void)myAssetPickerToolbar:(MyAssetPickerToolbar *)toolbar rightButtonIsTouch:(UIButton *)paramSender {
    if ([self.delegate respondsToSelector:@selector(myAssetImageController:didFinishSelectImage:)])
    {
        //需要对结果进行一个处理
        NSMutableArray *tpImageArray = [NSMutableArray array];
        for (int i = 0; i<selectArray.count; i++)
        {
            ALAsset *tpAsset = [selectArray objectAtIndex:i];
            UIImage *tpImage = [UIImage imageWithCGImage:tpAsset.defaultRepresentation.fullScreenImage];
            [tpImageArray addObject:tpImage];
        }
        [self.delegate myAssetImageController:self didFinishSelectImage:tpImageArray];
    }
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
    }
}

#pragma mark - 图片选择达到限制提示框

- (void)showAlertWithTitle:(NSString *)title {
    if (iOS8Later)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
    }
}


@end
