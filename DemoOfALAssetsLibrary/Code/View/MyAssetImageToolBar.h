//
//  MyAssetImageToolBar.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/3.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@protocol MyAssetImageToolBarDelegate <NSObject>

@optional

- (void)okBtnPressed;

@end

@interface MyAssetImageToolBar : UIView

@property(nonatomic,assign)id<MyAssetImageToolBarDelegate>delegate;

/**
 *  根据当前是否选择了图片刷新视图
 *
 *  @param array 选择的图片视图
 */
- (void)reloadToolBarWithArray:(NSArray *)array;

@end
