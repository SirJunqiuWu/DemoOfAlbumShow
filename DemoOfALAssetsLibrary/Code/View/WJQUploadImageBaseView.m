//
//  WJQUploadImageBaseView.m
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/4.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "WJQUploadImageBaseView.h"

@implementation WJQUploadImageBaseView
@synthesize baseSV,addBtn,imageViewsArr;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        imageViewsArr = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    baseSV = [[UIScrollView alloc] initWithFrame:AppFrame(0, 0,self.width, self.height)];
    [self addSubview:baseSV];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = AppFrame(10,(baseSV.height-80)/2, 80, 80);
    [addBtn setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    [addBtn setImage:[UIImage imageNamed:@"photoAdd"] forState:UIControlStateNormal];
    [baseSV addSubview:addBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize imageSize = CGSizeMake(90.0,90.0);
    float gap = 10.0;
    
    WJQUploadImageView *lastImageView;
    for (int i = 0; i < imageViewsArr.count; i++)
    {
        WJQUploadImageView *preImageView = [imageViewsArr pObjectAtIndex:i - 1];
        WJQUploadImageView *curImageView = [imageViewsArr pObjectAtIndex:i];
        if (preImageView == nil)
        {
            /**
             * 如果前面的视图不存在,必为第一位视图
             */
            curImageView.frame = AppFrame(gap,(baseSV.height-imageSize.height)/2,imageSize.width,imageSize.height);
        }
        else
        {
            curImageView.frame = AppFrame(preImageView.right+gap,(baseSV.height-imageSize.height)/2,imageSize.width,imageSize.height);
        }
        
        lastImageView = curImageView;
    }
    
    if (lastImageView == nil)
    {
        /**
         * 作为第一位视图
         */
        addBtn.frame = AppFrame(gap,(baseSV.height-80)/2, imageSize.width, imageSize.height);
    }
    else
    {
        addBtn.frame = AppFrame(lastImageView.right+gap,(baseSV.height-80)/2, imageSize.width, imageSize.height);
    }
    
    /**
     * 设置baseSV的contentSize
     */
    NSInteger totalCount = imageViewsArr.count + 1;
    float totalW = totalCount *imageSize.width + (totalCount+1)*gap;
    baseSV.contentSize = CGSizeMake(totalW, self.height);
}

#pragma mark - 添加MPUploadImageView

- (void)addImageView:(WJQUploadImageView *)imageview {
    [imageViewsArr addObject:imageview];
    [baseSV addSubview:imageview];
    [self layoutSubviews];
}


#pragma mark - 删除指定的图片链接的MPUploadImageView

- (void)removeImageViewByUrl:(NSString *)url {
    WJQUploadImageView *imageview = [imageViewsArr objectOfProperty:@"imageUrl" value:url];
    [imageViewsArr removeObject:imageview];
    [imageview removeFromSuperview];
    [self layoutSubviews];
}

#pragma mark - 更改指定图片链接的MPUploadImageView的图片链接

- (void)changeImageViewImageurlWithOriginUrl:(NSString *)originUrl NowUrl:(NSString *)nowUrl {
    WJQUploadImageView *imageview = [imageViewsArr objectOfProperty:@"imageUrl" value:originUrl];
    imageview.imageUrl = nowUrl;
    NSInteger index = [imageViewsArr indexOfObject:imageview];
    [imageViewsArr replaceObjectAtIndex:index withObject:imageview];
}


@end
