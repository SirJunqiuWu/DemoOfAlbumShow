//
//  WJQAlbumModel.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/2.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  相册model
 */
@interface WJQAlbumModel: NSObject

/**
 *  相册名字
 */
@property (nonatomic, strong) NSString *albumName;
/**
 *  相册包含多少图片
 */
@property (nonatomic, assign) NSInteger albumContainPhotoCount;
/**
 *  相册实体操作对象 PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>
 */
@property (nonatomic, strong) id albumResult;

@end
