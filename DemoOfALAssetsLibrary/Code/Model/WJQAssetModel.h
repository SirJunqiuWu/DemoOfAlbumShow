//
//  WJQAssetModel.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/2.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,WJQAssetMediaType) {
    /**
     *  照片
     */
    WJQAssetMediaTypeImage,
    /**
     *  图片是一种动图(ios9之后) LivePhoto，长按之后会进行播放
     */
    WJQAssetMediaTypeLiveImage,
    /**
     *  视频
     */
    WJQAssetMediaTypeVideo,
    /**
     *  语音
     */
    WJQAssetMediaTypeAudio,
};


/**
 *  单个图片管理对象
 */
@interface WJQAssetModel : NSObject

/**
 *  图片对象 PHAsset or ALAsset
 */
@property (nonatomic, strong) id asset;
/**
 *  是否选中,YES选中;反之未选中 默认NO
 */
@property (nonatomic, assign) BOOL isSelected;
/**
 *  文件类型
 */
@property (nonatomic, assign) WJQAssetMediaType type;
/**
 *  视频文件时，视频文件的时长
 */
@property (nonatomic, copy) NSString *timeLength;

#pragma mark ------------------ 用一个PHAsset/ALAsset实例，初始化一个照片模型 --------------

+ (instancetype)modelWithAsset:(id)asset type:(WJQAssetMediaType)type;
+ (instancetype)modelWithAsset:(id)asset type:(WJQAssetMediaType)type timeLength:(NSString *)timeLength;

@end
