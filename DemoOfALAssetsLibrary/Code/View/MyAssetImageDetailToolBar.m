//
//  MyAssetImageDetailToolBar.m
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/3.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MyAssetImageDetailToolBar.h"

@implementation MyAssetImageDetailToolBar
{
    UIButton    *originBtn;
    UIImageView *originIcon;
    UILabel     *sizeLbl;
    
    UIButton    *okBtn;
    UIImageView *numIcon;
    UILabel     *numLbl;
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
    originIcon = [[UIImageView alloc]initWithFrame:AppFrame(5,(self.height-21)/2,20,21)];
    originIcon.backgroundColor = [UIColor clearColor];
    originIcon.image = [UIImage imageNamed:@"original_N"];
    originIcon.userInteractionEnabled = YES;
    [self addSubview:originIcon];
    
    sizeLbl = [[UILabel alloc]initWithFrame:AppFrame(originIcon.right +5,(self.height-12)/2,50, 12)];
    sizeLbl.textAlignment = NSTextAlignmentLeft;
    sizeLbl.textColor = [UIColor whiteColor];
    sizeLbl.font = [UIFont systemFontOfSize:12];
    sizeLbl.text = @"原图";
    [self addSubview:sizeLbl];
    
    originBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    originBtn.frame = AppFrame(0, 0,100, self.height);
    originBtn.selected = NO;
    [originBtn addTarget:self action:@selector(originBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:originBtn];
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(self.width - 44 - 12, 0, 44, 44);
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [okBtn addTarget:self action:@selector(okBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:okBtn];
    
    numIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_number_icon"]];
    numIcon.backgroundColor = [UIColor clearColor];
    numIcon.frame = CGRectMake(self.width - 56 - 24,9, 26, 26);
    [self addSubview:numIcon];
    
    numLbl = [[UILabel alloc] init];
    numLbl.frame = numIcon.frame;
    numLbl.font = [UIFont systemFontOfSize:16];
    numLbl.textColor = [UIColor whiteColor];
    numLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:numLbl];
}

#pragma mark - 按钮点击事件

- (void)originBtnPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    originIcon.image = sender.selected ?[UIImage imageNamed:@"original_S"]:[UIImage imageNamed:@"original_N"];
    if ([self.delegate respondsToSelector:@selector(originBtnPressed:)])
    {
        [self.delegate originBtnPressed:sender];
    }
}

- (void)okBtnPressed {
    if ([self.delegate respondsToSelector:@selector(okBtnPressed)])
    {
        [self.delegate okBtnPressed];
    }
}

#pragma mark - 数据源

- (void)initViewWithArray:(NSArray *)array {
    numIcon.hidden = array.count == 0 ?YES:NO;
    numLbl.hidden  = array.count == 0 ?YES:NO;
    numLbl.text    = [NSString stringWithFormat:@"%ld",array.count];
}

- (void)changeOriginSizeWithModel:(WJQAssetModel *)model IsShowOriginSize:(BOOL)isShowOriginSize {
    if (isShowOriginSize)
    {
        [[WJQAlbumManager sharedManager]getPhotosBytesWithArray:@[model] completion:^(NSString *totalBytes) {
            sizeLbl.text = totalBytes;
        }];
    }
    else
    {
       sizeLbl.text = @"原图";
    }
}

@end
