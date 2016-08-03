//
//  MyAssetImageDetailController.m
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/3.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MyAssetImageDetailController.h"
#import "MyAssetImageController.h"
#import "MyAssetImageDetailCollectionCell.h"
#import "MyAssetImageDetailToolBar.h"

@interface MyAssetImageDetailController ()<UICollectionViewDataSource,UICollectionViewDelegate,MyAssetImageDetailToolBarDelegate>
{
    UICollectionView *infoCollection;
    
    /**
     *  导航
     */
    UIView           *naviBar;
    UIButton         *backBtn;
    UIButton         *selectBtn;
    
    /**
     *  工具栏
     */
    MyAssetImageDetailToolBar *toolBar;
    
    
    /**
     *  是否隐藏导航或者底部工具栏 YES隐藏
     */
    BOOL             isHideNaviBar;
    
    
    /**
     *  是否展示原图片大小 YES展示(一旦在某张图片修改了这个值后，后面的一致)
     */
    BOOL             isShowOriginSize;
}

@end

@implementation MyAssetImageDetailController
@synthesize allPhotoArray,haveSelectPhotoArray,currentPhotoIndex;

- (id)init {
    self = [super init];
    if (self) {
        allPhotoArray        = [NSMutableArray array];
        haveSelectPhotoArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    [self setupUI];
    [self setNaviBar];
    [self setToolBar];
    [self reloadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建UI

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing      = 0;
    
    infoCollection                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width , self.view.height) collectionViewLayout:layout];
    infoCollection.backgroundColor = [UIColor blackColor];
    infoCollection.dataSource      = self;
    infoCollection.delegate        = self;
    infoCollection.pagingEnabled   = YES;
    infoCollection.scrollsToTop    = NO;
    infoCollection.showsHorizontalScrollIndicator = NO;
    infoCollection.contentOffset   = CGPointMake(0, 0);
    infoCollection.contentSize     = CGSizeMake(self.view.width *allPhotoArray.count, self.view.height);
    [infoCollection registerClass:[MyAssetImageDetailCollectionCell class] forCellWithReuseIdentifier:@"MyAssetImageDetailCollectionCell"];
    [self.view addSubview:infoCollection];
    if (currentPhotoIndex) [infoCollection setContentOffset:CGPointMake((self.view.width) *currentPhotoIndex, 0) animated:NO];
}

- (void)setNaviBar {
    naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    naviBar.alpha = 0.7;
    [self.view addSubview:naviBar];
    
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,20, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:backBtn];
    
    selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 54,20, 42, 42)];
    [selectBtn setImage:[UIImage imageNamed:@"photo_N"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"photo_S"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:selectBtn];
}

- (void)setToolBar {
    toolBar = [[MyAssetImageDetailToolBar alloc]initWithFrame:CGRectMake(0,self.view.height-44,self.view.width,44)];
    toolBar.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
    toolBar.alpha = 0.7;
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
}

#pragma mark - 按钮点击事件

- (void)backBtnPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectBtnPressed {
    if (currentPhotoIndex >=allPhotoArray.count)
    {
        return;
    }
    
    BOOL needReload = NO;
    
    WJQAssetModel *tempModel = allPhotoArray[currentPhotoIndex];
    NSArray *viewControllers = self.navigationController.viewControllers;
    __block MyAssetImageController *assetImageVC = nil;
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vc isKindOfClass:[MyAssetImageController class]])
        {
            assetImageVC = (MyAssetImageController *)vc;
        }
    }];
    if (tempModel.isSelected)
    {
        tempModel.isSelected = NO;
        selectBtn.selected   = NO;
        needReload           = YES;
        [haveSelectPhotoArray removeObject:tempModel];
        [allPhotoArray replaceObjectAtIndex:currentPhotoIndex withObject:tempModel];
    }
    else
    {
        if (haveSelectPhotoArray.count < assetImageVC.maxSelectItem)
        {
            tempModel.isSelected = YES;
            selectBtn.selected   = YES;
            needReload           = YES;
            [haveSelectPhotoArray addObject:tempModel];
            [allPhotoArray replaceObjectAtIndex:currentPhotoIndex withObject:tempModel];
        }
        else
        {
            needReload           = NO;
            NSString *title = [NSString stringWithFormat:@"你最多只能选择%d张照片",assetImageVC.maxSelectItem];
            [assetImageVC showAlertWithTitle:title];
        }
    }
    if (needReload)
    {
        [self reloadUI];
    }
}

#pragma mark - 刷新UI

- (void)reloadUI {
    if (currentPhotoIndex >=allPhotoArray.count)
    {
        return;
    }
    WJQAssetModel *tempModel = allPhotoArray[currentPhotoIndex];
    selectBtn.selected = tempModel.isSelected;
    [toolBar initViewWithArray:haveSelectPhotoArray];
    [toolBar changeOriginSizeWithModel:tempModel IsShowOriginSize:isShowOriginSize];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return allPhotoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"MyAssetImageDetailCollectionCell";
    MyAssetImageDetailCollectionCell *cell = (MyAssetImageDetailCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >=allPhotoArray.count)
    {
        return;
    }
    WJQAssetModel *model = allPhotoArray[indexPath.row];
    [((MyAssetImageDetailCollectionCell *)cell) initCellWithModel:model];
    
    __block BOOL weakIsHideNaviBar       = isHideNaviBar;
    __weak typeof(naviBar) weakNaviBar   = naviBar;
    __weak typeof(toolBar) weaktoolBar   = toolBar;
    [((MyAssetImageDetailCollectionCell *)cell) setSingleTapGestureBlock:^{
        /**
         *  隐藏导航栏和底部工具栏
         */
        weakIsHideNaviBar   = !weakIsHideNaviBar;
        weakNaviBar.hidden  = weakIsHideNaviBar;
        weaktoolBar.hidden  = weakIsHideNaviBar;
    }];
}

#pragma mark - MyAssetImageDetailToolBarDelegate

- (void)originBtnPressed:(UIButton *)sender {
    NSLog(@"原图");
    isShowOriginSize = sender.selected;
    [toolBar changeOriginSizeWithModel:[self getCurrentAssetModel] IsShowOriginSize:isShowOriginSize];
}

- (void)okBtnPressed {
    NSLog(@"确定");
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    currentPhotoIndex = scrollView.contentOffset.x / self.view.tz_width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadUI];
}

#pragma mark - 获取当前显示的图片对象

- (WJQAssetModel *)getCurrentAssetModel {
    if (currentPhotoIndex >=allPhotoArray.count)
    {
        return [WJQAssetModel new];
    }
    WJQAssetModel *model = allPhotoArray[currentPhotoIndex];
    return model;
}

@end
