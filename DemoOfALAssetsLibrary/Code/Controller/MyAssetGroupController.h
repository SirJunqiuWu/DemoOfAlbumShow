//
//  MyAssetGroupController.h
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAssetGroupController;

@protocol MyAssetGroupControllerDelegate <NSObject>

@optional

/**
 *  完成图片选择
 *
 *  @param controller 当前的MyAssetGroupController
 *  @param imageArray 选择的图片数组
 */
-(void)myAssetGroupController:(MyAssetGroupController *)controller didFinishSelect:(NSArray *)imageArray;

/**
 *  选择图片出错
 *
 *  @param controller 当前的MyAssetGroupController
 *  @param error      错误信息
 */
-(void)myAssetGroupController:(MyAssetGroupController *)controller selectImageWithError:(NSError *)error;

/**
 *  取消图片选择
 *
 *  @param controller 当前的MyAssetGroupController
 */
-(void)didCancleSelectImage:(MyAssetGroupController *)controller;

@end


/**
 *  自定义相册列表界面
 */
@interface MyAssetGroupController : UIViewController

/**
 *  最大选择图片数量
 */
@property (nonatomic , assign) int maxSelectItem;

/**
 *  相册数组
 */
@property (nonatomic , strong) NSMutableArray *allAlbumArray;

@property (nonatomic , weak) id<MyAssetGroupControllerDelegate>delegate;

@end
