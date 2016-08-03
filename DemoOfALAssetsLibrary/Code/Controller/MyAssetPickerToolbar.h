//
//  MyAssetPickerToolbar.h
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/4.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAssetPickerToolbar;

@protocol MyAssetPickerToolbarDelegate <NSObject>

@required

/**
 *  左边预览按钮被点击
 */
-(void)myAssetPickerToolbar:(MyAssetPickerToolbar *)toolbar leftButtonIsTouch:(UIButton *)paramSender;

/**
 *  右边完成按钮被点击
 */
-(void)myAssetPickerToolbar:(MyAssetPickerToolbar *)toolbar rightButtonIsTouch:(UIButton *)paramSender;

@end

@interface MyAssetPickerToolbar : UIView

@property (nonatomic , weak) id<MyAssetPickerToolbarDelegate>delegate;

/**
 *  按钮可点击
 */
@property (nonatomic , assign) BOOL buttonCanTouch;

@end
