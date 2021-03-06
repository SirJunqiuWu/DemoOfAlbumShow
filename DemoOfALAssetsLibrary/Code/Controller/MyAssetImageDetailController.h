//
//  MyAssetImageDetailController.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/3.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAssetImageDetailController : UIViewController

/**
 *  当前查看相册下的所有图片数组
 */
@property(nonatomic,strong)NSMutableArray *allPhotoArray;

/**
 *  当前查看相册下的所有选中图片数组
 */
@property(nonatomic,strong)NSMutableArray *haveSelectPhotoArray;


/**
 *  当前查看相册下的所有选中图片数组
 */
@property(nonatomic,assign)NSInteger currentPhotoIndex;

/**
 *  选择图片回调 参数为操作的图片索引 以及图片对象
 */
@property(nonatomic,copy)void(^SelectedPhotoBlock)(NSInteger idx,WJQAssetModel *model);


/**
 *  确定按钮点击回调
 */
@property(nonatomic,copy)void(^OKBlock)(NSArray *selectedPhotosArray);

@end
