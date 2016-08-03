//
//  WJQAlbumManager.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/1.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Config.h"
#import "WJQAlbumModel.h"
#import "WJQAssetModel.h"

@interface WJQAlbumManager : NSObject

/**
 *  是否调整图片方向
 */
@property(nonatomic,assign)BOOL shouldFixOrientation;

/**
 *  单例
 *
 *  @return WJQAlbumManager
 */
+(WJQAlbumManager *)sharedManager;


/**
 *  是否获得相册访问权限
 *
 *  @return YES,已经授权;反之无
 */
- (BOOL)authorizationStatusAuthorized;

/**
 *  获取手机所有相册
 *
 *  @param isAllowPickingVideo 是否允许选择视频 YES允许;反之不允许
 *  @param completion          结果回调
 */
- (void)getAllAlbumsWithIsAllowPickingVideo:(BOOL)isAllowPickingVideo Completion:(void(^)(NSArray *allAlbumsArray))completion;


/**
 *  获取某个相册展示图片
 *
 *  @param model               当前的相册model
 *  @param postImageWidth      相册需要展示的图片宽度
 *  @param completion          结果回调
 */
- (void)getPostImageWithAlbumModel:(WJQAlbumModel *)model PostImageWidth:(CGFloat)postImageWidth completion:(void (^)(UIImage *postImage))completion;


/**
 *  获取指定宽度的照片
 *
 *  @param asset      图片操作对象
 *  @param photoWidth 图片宽度
 *  @param completion 结果回调
 */
- (void)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;


/**
 *  获取指定相册下的所有图片
 *
 *  @param result              是否允许选择视频 YES允许;反之不允许
 *  @param isAllowPickingVideo
 *  @param completion          结果回调
 */
- (void)getSelectedAlbumPhotoByFetchResult:(id)result IsAllowPickingVideo:(BOOL)isAllowPickingVideo completion:(void (^)(NSArray *allPhotoArray))completion;


/**
 *  获取一组图片的大小
 *
 *  @param photos     图片数组
 *  @param completion 结果回调
 */
- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void (^)(NSString *totalBytes))completion;

@end





