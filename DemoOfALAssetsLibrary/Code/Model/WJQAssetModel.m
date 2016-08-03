//
//  WJQAssetModel.m
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/2.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "WJQAssetModel.h"

@implementation WJQAssetModel

+ (instancetype)modelWithAsset:(id)asset type:(WJQAssetMediaType)type {
    WJQAssetModel *model = [WJQAssetModel new];
    model.asset          = asset;
    model.isSelected     = NO;
    model.type           = type;
    return model;
}


+ (instancetype)modelWithAsset:(id)asset type:(WJQAssetMediaType)type timeLength:(NSString *)timeLength {
    WJQAssetModel *model = [WJQAssetModel new];
    model.asset          = asset;
    model.isSelected     = NO;
    model.type           = type;
    model.timeLength     = timeLength;
    return model;
}

@end
