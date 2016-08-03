//
//  MyAssetPickerController.h
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAssetPickerController;

@protocol MyAssetPickerControllerDelegate <NSObject>

@optional

/**
 *  选取图片完成
 *
 *  @param pickerController 当前的图片选择器
 *  @param imageArray       图片数组，数组的内容为Image
 */
-(void)myAssetPickerController:(MyAssetPickerController *)pickerController didFinishSelect:(NSArray *)imageArray;

/**
 *  选取图片出错
 *
 *  @param pickerController 当前的图片选择器
 *  @param error            错误信息
 */
-(void)myAssetPickerController:(MyAssetPickerController *)pickerController selectImageFailedWithError:(NSError *)error;

/**
 *  用户取消选择
 *
 *  @param pickerController 当前的MyAssetPickerController
 */
-(void)didCancleSelectImage:(MyAssetPickerController *)pickerController;

@end

@interface MyAssetPickerController : UINavigationController

@property (nonatomic , weak) id<MyAssetPickerControllerDelegate>pickControllerDelegate;

/**
 *  最大选择数量
 */
@property (nonatomic , assign) int maxSelectItem;

@end
