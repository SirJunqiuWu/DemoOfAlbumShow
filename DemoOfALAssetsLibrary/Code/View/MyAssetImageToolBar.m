//
//  MyAssetImageToolBar.m
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/3.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MyAssetImageToolBar.h"

@implementation MyAssetImageToolBar
{
    UIButton *okBtn;
    UIView   *grayView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = AppFrame(10,(self.height-40)/2,self.width-20,40);
    okBtn.layer.cornerRadius = 2.0;
    okBtn.layer.masksToBounds = YES;
    okBtn.backgroundColor = UIColorFromRGB(0x00ae66);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    
    grayView = [[UIView alloc]initWithFrame:AppFrame(0,0,self.width,self.height)];
    grayView.backgroundColor = [UIColor whiteColor];
    grayView.alpha = 0.5;
    [self addSubview:grayView];
}

#pragma mark - 数据源

- (void)reloadToolBarWithArray:(NSArray *)array {
    grayView.hidden = array.count == 0?NO:YES;
}

#pragma mark - 按钮点击事件

- (void)okBtnPressed {
    if ([self.delegate respondsToSelector:@selector(okBtnPressed)])
    {
        [self.delegate okBtnPressed];
    }
}

@end
