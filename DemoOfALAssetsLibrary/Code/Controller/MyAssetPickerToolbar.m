//
//  MyAssetPickerToolbar.m
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/4.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetPickerToolbar.h"

@interface MyAssetPickerToolbar ()
{
    /**
     *  左边的预览按钮
     */
    UIButton *leftButton;
    
    /**
     *  右边的确定按钮
     */
    UIButton *rightButton;
}
@end

@implementation MyAssetPickerToolbar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initiaMyAssetPickerToolbar];
    }
    return self;
}

- (void)initiaMyAssetPickerToolbar {
    //分割线
    UIImageView *topLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.3)];
    topLineImageView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    [self addSubview:topLineImageView];
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.alpha = 0.3;
    leftButton.frame = CGRectMake(0, 0, 60, self.frame.size.height);
    [leftButton setTitle:@"预览" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonIsTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setEnabled:NO];
    [self addSubview:leftButton];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.alpha = 0.3;
    rightButton.frame = CGRectMake(self.frame.size.width - 60, 0, 60, self.frame.size.height);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(rightButtonIsTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setEnabled:NO];
    [self addSubview:rightButton];
}

/**
 *  左边预览按钮的点击事件
 *
 *  @param paramSender 预览按钮
 */
-(void)leftButtonIsTouchUpInside:(UIButton *)paramSender
{
    if ([self.delegate respondsToSelector:@selector(myAssetPickerToolbar:leftButtonIsTouch:)])
    {
        [self.delegate myAssetPickerToolbar:self leftButtonIsTouch:paramSender];
    }
}

/**
 *  右边确定按钮的点击事件
 *
 *  @param paramSender 确定按钮
 */
-(void)rightButtonIsTouchUpInside:(UIButton *)paramSender
{
    if ([self.delegate respondsToSelector:@selector(myAssetPickerToolbar:rightButtonIsTouch:)])
    {
        [self.delegate myAssetPickerToolbar:self rightButtonIsTouch:paramSender];
    }
}


-(void)setButtonCanTouch:(BOOL)buttonCanTouch
{
    if (buttonCanTouch == YES)
    {
        [leftButton setEnabled:YES];
        leftButton.alpha = 1;
        
        [rightButton setEnabled:YES];
        rightButton.alpha = 1;
    }
    else
    {
        [leftButton setEnabled:NO];
        leftButton.alpha = 0.3;
        
        [rightButton setEnabled:NO];
        rightButton.alpha = 0.3;
    }
}

@end
