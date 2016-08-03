//
//  MyAssetImageDetailToolBar.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/3.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "WJQAlbumManager.h"

@protocol MyAssetImageDetailToolBarDelegate <NSObject>

@optional

- (void)originBtnPressed:(UIButton *)sender;

- (void)okBtnPressed;


@end

@interface MyAssetImageDetailToolBar : UIView

@property(nonatomic,assign)id<MyAssetImageDetailToolBarDelegate>delegate;

/**
 *  数据源方法
 *
 *  @param array 当前选择的图片数组
 */
- (void)initViewWithArray:(NSArray *)array;


/**
 *  显示图片大小
 *
 *  @param model            当前查看的图片对象
 *  @param isShowOriginSize 是否展示原图尺寸大小
 */
- (void)changeOriginSizeWithModel:(WJQAssetModel *)model IsShowOriginSize:(BOOL)isShowOriginSize;

@end
