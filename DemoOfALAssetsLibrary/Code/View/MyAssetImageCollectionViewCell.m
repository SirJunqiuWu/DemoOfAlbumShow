//
//  MyAssetImageCollectionViewCell.m
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetImageCollectionViewCell.h"

@interface MyAssetImageCollectionViewCell ()
@end

@implementation MyAssetImageCollectionViewCell
@synthesize imageView,selectBtn,indexPath;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:imageView];
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.backgroundColor = [UIColor clearColor];
    selectBtn.frame = CGRectMake(self.frame.size.height * 0.5, 0, self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.height * 0.1, self.frame.size.height * 0.1, 0)];
    [selectBtn addTarget:self action:@selector(selectBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setImage:[UIImage imageNamed:@"photo_N"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"photo_S"] forState:UIControlStateSelected];
    [self.contentView addSubview:selectBtn];
}

#pragma mark - 数据源

- (void)initCellWithModel:(WJQAssetModel *)model {
    selectBtn.selected = model.isSelected;
    [[WJQAlbumManager sharedManager]getPhotoWithAsset:model.asset photoWidth:imageView.frame.size.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        imageView.image = photo;
    }];
}

#pragma mark - 按钮点击事件

- (void)selectBtnPressed {
    if ([self.delegate respondsToSelector:@selector(selectBtnPressedWithIndexPath:)])
    {
        [self.delegate selectBtnPressedWithIndexPath:indexPath];
    }
}

@end
