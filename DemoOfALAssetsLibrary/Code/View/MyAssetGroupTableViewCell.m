//
//  MyAssetGroupTableViewCell.m
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetGroupTableViewCell.h"
#import "WJQAlbumManager.h"

@implementation MyAssetGroupTableViewCell
{
    UIImageView *postImageView;
    UILabel     *titleLbl;
    UILabel     *subTitleLbl;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    postImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,75, 75)];
    postImageView.backgroundColor = [UIColor clearColor];
    postImageView.clipsToBounds = YES;
    [self.contentView addSubview:postImageView];
    
    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(90, 0,AppWidth-90.0,14)];
    titleLbl.font = [UIFont systemFontOfSize:14.0];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLbl];
    
    subTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(90,20,AppWidth-90.0,12)];
    subTitleLbl.font = [UIFont systemFontOfSize:12.0];
    subTitleLbl.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:subTitleLbl];
}

#pragma marak - 数据源

- (void)setMyAssetGroupTableViewCellWithModel:(WJQAlbumModel *)model {
    titleLbl.text         = model.albumName;
    subTitleLbl.text      = [NSString stringWithFormat:@"%ld",(long)model.albumContainPhotoCount];
    [[WJQAlbumManager sharedManager]getPostImageWithAlbumModel:model PostImageWidth:80.0 completion:^(UIImage *postImage) {
        postImageView.image = postImage;
    }];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
