//
//  WJQUploadImageView.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/4.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end
