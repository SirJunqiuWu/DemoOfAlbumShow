//
//  WJQUploadImageView.m
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/4.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "WJQUploadImageView.h"

@implementation WJQUploadImageView
@synthesize imageView,deleteBtn;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds          = YES;
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    /**
     * 展示的图片 可在图片上增添点击事件，以便展示原图
     */
    imageView = [[UIImageView alloc]initWithFrame:AppFrame(10,10,self.width-10,self.height-10)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    
    deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = AppFrame(0,0, 24,24);
    [deleteBtn setImage:[UIImage imageNamed:@"photoDeleteIcon"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
}

#pragma mark - Setter

- (void)setImage:(UIImage *)image {
    _image = image;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    if (_image)
    {
        self.imageView.image = _image;
    }
    else
    {
        /**
         *  赋网络图片
         */
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    }
}

#pragma mark - 按钮点击事件

- (void)deleteBtnPressed {
    if ([self.delegate respondsToSelector:@selector(deleteBtnPressedWithObj:)])
    {
        [self.delegate deleteBtnPressedWithObj:self];
    }
}

@end
