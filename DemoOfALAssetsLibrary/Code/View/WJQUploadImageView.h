//
//  WJQUploadImageView.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/4.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJQUploadImageView;
@protocol WJQUploadImageViewDelegate <NSObject>

@optional

/**
 *  删除某张图片视图
 *
 *  @param obj 自身
 */
- (void)deleteBtnPressedWithObj:(WJQUploadImageView *)obj;

@end

/**
 *  上传图片用的视图
 */
@interface WJQUploadImageView : UIView

/**
 *  图片链接
 */
@property (nonatomic, strong) NSString *imageUrl;
/**
 *  图片
 */
@property (nonatomic, strong) UIImage  *image;
/**
 *  显示图片的视图
 */
@property (nonatomic, strong) UIImageView *imageView;
/**
 *  图片上的删除按钮
 */
@property (nonatomic, strong) UIButton *deleteBtn;
/**
 *  代理
 */
@property (nonatomic,assign)id<WJQUploadImageViewDelegate>delegate;

@end
