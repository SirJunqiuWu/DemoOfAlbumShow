//
//  WJQUploadImageBaseView.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/4.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJQUploadImageView.h"

@interface WJQUploadImageBaseView : UIView

@property(nonatomic,strong)UIScrollView *baseSV;
@property(nonatomic,strong)UIButton *addBtn;
/**
 * 存放的是WJQUploadImageView对象
 */
@property (nonatomic, strong) NSMutableArray *imageViewsArr;

/**
 *  添加WJQUploadImageView视图对象
 *
 *  @param imageview MPUploadImageView对象
 */
- (void)addImageView:(WJQUploadImageView *)imageview;

/**
 *  移除指定图片链接所在的图片视图对象
 *
 *  @param url 当前要移除的视图的图片链接(上传服务器返回)
 */
- (void)removeImageViewByUrl:(NSString *)url;

/**
 *  更改指定图片链接所在视图的图片链接,不影响图片视图的个数和其他属性值
 *
 *  @param originUrl 原始的图片链接(还未上传时默认的一个地址，无效)
 *  @param nowUrl    最新的图片链接(上传服务器返回)
 */
- (void)changeImageViewImageurlWithOriginUrl:(NSString *)originUrl NowUrl:(NSString *)nowUrl;

@end
