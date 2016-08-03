//
//  MyAssetImageDetailCollectionCell.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/3.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJQAlbumManager.h"

/**
 *  图片详情界面cell
 */
@interface MyAssetImageDetailCollectionCell : UICollectionViewCell

@property (nonatomic,copy)void(^singleTapGestureBlock)();

- (void)initCellWithModel:(WJQAssetModel *)model;

@end
