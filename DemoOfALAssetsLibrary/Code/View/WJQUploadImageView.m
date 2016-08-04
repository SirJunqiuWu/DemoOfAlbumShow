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

#pragma mark - 按钮点击事件

- (void)deleteBtnPressed {
    
}

@end
