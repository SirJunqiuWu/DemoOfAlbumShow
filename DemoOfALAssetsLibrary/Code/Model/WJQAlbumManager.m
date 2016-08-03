//
//  WJQAlbumManager.m
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/1.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "WJQAlbumManager.h"

@interface WJQAlbumManager()
@property(nonatomic,strong)ALAssetsLibrary *assetLibrary;
@end

static WJQAlbumManager *myManager = nil;
@implementation WJQAlbumManager

+(WJQAlbumManager *)sharedManager {
    @synchronized (self) {
        static dispatch_once_t pred;
        dispatch_once(&pred,^{
            myManager = [[self alloc]init];
        });
    }
    return myManager;
}

- (ALAssetsLibrary *)assetLibrary {
    if (_assetLibrary == nil)
    {
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetLibrary;
}


- (BOOL)authorizationStatusAuthorized {
    if (iOS8Later)
    {
        if ([PHPhotoLibrary authorizationStatus] == ALAuthorizationStatusAuthorized)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

- (void)getAllAlbumsWithIsAllowPickingVideo:(BOOL)isAllowPickingVideo Completion:(void(^)(NSArray *allAlbumsArray))completion {
    NSMutableArray *albumArr = [NSMutableArray array];
    if (iOS8Later)
    {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        
        /**
         *  PHAssetMediaType 多媒体类型
         */
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        /**
         *  显示的相册类型
         */
        PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumVideos;

        if (iOS9Later)
        {
            /**
             *  ios9后新增屏幕截图,自定义相册类型
             */
            smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos;
        }
        
        /**
         *  相机胶卷,屏幕快照,最近添加,个人收藏
         */
        PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
        for (PHAssetCollection *collection in smartAlbumsFetchResult)
        {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            
            /**
             *  图片数为0的相册不显示
             */
            if (fetchResult.count < 1)
                continue;
            
            /**
             *  最近删除的相册不显示
             */
            if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"])
                continue;
            
            /**
             *  相机胶卷的相册放在第一个显示
             */
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"])
            {
                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
            }
            else
            {
                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
        
        /**
         *  QQ,QQ空间,美颜相机等
         */
        PHFetchResult *albumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        for (PHAssetCollection *collection in albumsFetchResult)
        {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1)
                continue;
            if ([collection.localizedTitle isEqualToString:@"My Photo Stream"] || [collection.localizedTitle isEqualToString:@"我的照片流"])
            {
                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:1];
            }
            else
            {
                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
        if (completion && albumArr.count > 0)
        {
           completion(albumArr); 
        }
    }
    else
    {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil)
            {
                if (completion && albumArr.count > 0) completion(albumArr);
            }
            if ([group numberOfAssets] < 1)
                return;
            
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:@"Camera Roll"] || [name isEqualToString:@"相机胶卷"])
            {
                [albumArr insertObject:[self modelWithResult:group name:name] atIndex:0];
            }
            else if ([name isEqualToString:@"My Photo Stream"] || [name isEqualToString:@"我的照片流"])
            {
                [albumArr insertObject:[self modelWithResult:group name:name] atIndex:1];
            }
            else
            {
                [albumArr addObject:[self modelWithResult:group name:name]];
            }
        } failureBlock:nil];
    }
}

- (void)getPostImageWithAlbumModel:(WJQAlbumModel *)model PostImageWidth:(CGFloat)postImageWidth completion:(void (^)(UIImage *postImage))completion {
    if (iOS8Later)
    {
       [self getPhotoWithAsset:[model.albumResult lastObject] photoWidth:postImageWidth completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
           if (completion)
           {
               completion(photo);
           }
       }];
    }
    else
    {
        ALAssetsGroup *gruop = model.albumResult;
        UIImage *postImage = [UIImage imageWithCGImage:gruop.posterImage];
        if (completion)
        {
           completion(postImage); 
        }
    }
}

- (void)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    if ([asset isKindOfClass:[PHAsset class]])
    {
        /**
         * 等比缩放图片本身
         */
        PHAsset *phAsset    = (PHAsset *)asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple    = [UIScreen mainScreen].scale;
        if (photoWidth == AppWidth)
        {
            multiple = 1.0;
        }
        CGFloat pixelWidth  = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
         {
             BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
             if (downloadFinined && result)
             {
                 result = [self fixOrientation:result];
                 if (completion)
                 {
                     completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                 }
             }
         }];
    }
    else if ([asset isKindOfClass:[ALAsset class]])
    {
        ALAsset *alAsset = (ALAsset *)asset;
        ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
        CGImageRef thumbnailImageRef = alAsset.aspectRatioThumbnail;
        UIImage *thumbnailImage = [UIImage imageWithCGImage:thumbnailImageRef scale:1.0 orientation:UIImageOrientationUp];
        if (completion) completion(thumbnailImage,nil,YES);
        
        if (photoWidth == [UIScreen mainScreen].bounds.size.width)
        {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                CGImageRef fullScrennImageRef = [assetRep fullScreenImage];
                UIImage *fullScrennImage = [UIImage imageWithCGImage:fullScrennImageRef scale:1.0 orientation:UIImageOrientationUp];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(fullScrennImage,nil,NO);
                });
            });
        }
    }
    else
    {
        NSAssert(@"", nil);
    }
}

- (void)getSelectedAlbumPhotoByFetchResult:(id)result IsAllowPickingVideo:(BOOL)isAllowPickingVideo completion:(void (^)(NSArray *allPhotoArray))completion {
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]])
    {
        /**
         * 相册管理类
         */
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = (PHAsset *)obj;
            WJQAssetMediaType type = WJQAssetMediaTypeImage;
            if (asset.mediaType == PHAssetMediaTypeVideo)
            {
                type = WJQAssetMediaTypeVideo;
            }
            else if (asset.mediaType == PHAssetMediaTypeAudio)
            {
                type = WJQAssetMediaTypeAudio;
            }
            else if (asset.mediaType == PHAssetMediaTypeImage)
            {
                type = WJQAssetMediaTypeImage;
            }
            
            /**
             *  不允许挑选视频并且当前文件类型是视频文件时返回
             */
            if (!isAllowPickingVideo && type == WJQAssetMediaTypeVideo)
            {
                return;
            }
            
            /**
             *  如果允许挑选视频
             */
            NSString *timeLength = type == WJQAssetMediaTypeVideo ? [NSString stringWithFormat:@"%0.0f",asset.duration] : @"";
            timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
            
            /**
             *  添加图片model
             */
            [photoArr addObject:[WJQAssetModel modelWithAsset:asset type:type timeLength:timeLength]];
        }];
        if (completion)
        {
           completion(photoArr);
        }
    }
    else if ([result isKindOfClass:[ALAssetsGroup class]])
    {
        ALAssetsGroup *gruop = (ALAssetsGroup *)result;
        if (!isAllowPickingVideo)
        {
           [gruop setAssetsFilter:[ALAssetsFilter allPhotos]];
        }
        [gruop enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil)
            {
                if (completion)
                {
                    completion(photoArr);
                }
            }
            WJQAssetMediaType type = WJQAssetMediaTypeImage;
            
            /**
             *  不允许挑选视频的话,返回
             */
            if (!isAllowPickingVideo)
            {
                [photoArr addObject:[WJQAssetModel modelWithAsset:result type:type]];
                return;
            }
            
            /**
             *  如果允许挑选视频文件
             */
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo])
            {
                type = WJQAssetMediaTypeVideo;
                NSTimeInterval duration = [[result valueForProperty:ALAssetPropertyDuration] integerValue];
                NSString *timeLength    = [NSString stringWithFormat:@"%0.0f",duration];
                timeLength              = [self getNewTimeFromDurationSecond:timeLength.integerValue];
                [photoArr addObject:[WJQAssetModel modelWithAsset:result type:type timeLength:timeLength]];
            }
            else
            {
                [photoArr addObject:[WJQAssetModel modelWithAsset:result type:type]];
            }
            if (completion)
            {
                completion(photoArr);
            }
        }];
    }
}


- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void (^)(NSString *totalBytes))completion {
    __block NSInteger dataLength = 0;
    __block NSInteger assetCount = 0;
    
    [photos enumerateObjectsUsingBlock:^(WJQAssetModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.asset isKindOfClass:[PHAsset class]])
        {
            [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                if (model.type != WJQAssetMediaTypeVideo)
                {
                    dataLength += imageData.length;
                }
                assetCount ++;
                if (assetCount >= photos.count)
                {
                    NSString *bytes = [self getBytesFromDataLength:dataLength];
                    if (completion) completion(bytes);
                }
            }];
        }
        else if ([model.asset isKindOfClass:[ALAsset class]])
        {
            ALAssetRepresentation *representation = [model.asset defaultRepresentation];
            if (model.type != WJQAssetMediaTypeVideo)
            {
                dataLength += (NSInteger)representation.size;
            }
            if (idx >= photos.count - 1)
            {
                NSString *bytes = [self getBytesFromDataLength:dataLength];
                if (completion) completion(bytes);
            }
        }
        else
        {
            NSAssert(@"",nil);
        }
    }];
}

- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024))
    {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    }
    else if (dataLength >= 1024)
    {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    }
    else
    {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

#pragma mark ------------------ 获取相册model --------------

/**
 *  将相册名字数据转换为model
 *
 *  @param result < PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>
 *  @param name   相册名字
 *
 *  @return WJQAlbumModel
 */
- (WJQAlbumModel *)modelWithResult:(id)result name:(NSString *)name {
    WJQAlbumModel *model = [[WJQAlbumModel alloc] init];
    model.albumResult = result;
    model.albumName = [self getNewAlbumName:name];
    if ([result isKindOfClass:[PHFetchResult class]])
    {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.albumContainPhotoCount = fetchResult.count;
    }
    else if ([result isKindOfClass:[ALAssetsGroup class]])
    {
        ALAssetsGroup *gruop = (ALAssetsGroup *)result;
        model.albumContainPhotoCount = [gruop numberOfAssets];
    }
    else
    {
        NSAssert(@"",nil);
    }
    return model;
}

- (NSString *)getNewAlbumName:(NSString *)name {
    if (iOS8Later)
    {
        NSString *newName = @"";
        if ([name rangeOfString:@"Roll"].location != NSNotFound)
        {
           newName = @"相机胶卷";
        }
        else if ([name rangeOfString:@"Stream"].location != NSNotFound)
        {
            newName = @"我的照片流";
        }
        else if ([name rangeOfString:@"Added"].location != NSNotFound)
        {
           newName = @"最近添加";
        }
        else if ([name rangeOfString:@"Selfies"].location != NSNotFound)
        {
           newName = @"自拍";
        }
        else if ([name rangeOfString:@"shots"].location != NSNotFound)
        {
            newName = @"截屏";
        }
        else if ([name rangeOfString:@"Videos"].location != NSNotFound)
        {
          newName = @"视频";
        }
        else
        {
            newName = name;
        }
        return newName;
    }
    else
    {
        return name;
    }
}

#pragma mark ------------------ 调整图片方向 --------------

- (UIImage *)fixOrientation:(UIImage *)aImage {
    if (!self.shouldFixOrientation) return aImage;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark ------------------ 获取时间 --------------

- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10)
    {
        newTime = [NSString stringWithFormat:@"0:0%zd",duration];
    }
    else if (duration < 60)
    {
        newTime = [NSString stringWithFormat:@"0:%zd",duration];
    }
    else
    {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10)
        {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        }
        else
        {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

@end
