//
//  MyAssetImageCollectionViewCell.h
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJQAlbumManager.h"

@protocol MyAssetImageCollectionViewCellDelegate <NSObject>

@required

/**
 *  选中按钮的委托
 *
 *  @param indexPath 当前cell的indexPath
 */
-(void)selectBtnPressedWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyAssetImageCollectionViewCell : UICollectionViewCell

/**
 *  用于显示单个图片的imageView
 */
@property (nonatomic,strong)UIImageView *imageView;
/**
 *  图片选中标记按钮
 */
@property (nonatomic,strong)UIButton    *selectBtn;
/**
 *  当前cell行
 */
@property (nonatomic,strong)NSIndexPath *indexPath;
/**
 *  委托
 */
@property (nonatomic ,assign) id<MyAssetImageCollectionViewCellDelegate>delegate;

- (void)initCellWithModel:(WJQAssetModel *)model;

@end
