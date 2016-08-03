//
//  MyAssetGroupTableViewCell.h
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJQAlbumModel.h"

@interface MyAssetGroupTableViewCell : UITableViewCell

/**
 *  对外方法，获取单个相册列表内容
 *
 *  @param model 单个相册列表model
 */
-(void)setMyAssetGroupTableViewCellWithModel:(WJQAlbumModel *)model;

@end
