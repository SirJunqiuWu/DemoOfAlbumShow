//
//  MyAssetGroupController.m
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetGroupController.h"
#import "MyAssetImageController.h"
#import "MyAssetGroupTableViewCell.h"
#import "WJQAlbumManager.h"

@interface MyAssetGroupController ()<UITableViewDataSource,UITableViewDelegate,MyAssetImageControllerDelegate>
{
    /**
     *  相册列表tableview
     */
    UITableView *imageGroupTableView;
}
@end

@implementation MyAssetGroupController
@synthesize allAlbumArray;

- (id)init {
    self = [super init];
    if (self) {
        allAlbumArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title  = @"相册";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    /**
     *  获取相册列表
     */
    [self getAllAlbum];
    
    /**
     *  创建tableview
     */
    imageGroupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    imageGroupTableView.dataSource = self;
    imageGroupTableView.delegate = self;
    imageGroupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:imageGroupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 获取相册列表

- (void)getAllAlbum {
    [[WJQAlbumManager sharedManager]getAllAlbumsWithIsAllowPickingVideo:NO Completion:^(NSArray *allAlbumsArray) {
        [allAlbumArray addObjectsFromArray:allAlbumsArray];
    }];
}

#pragma mark - UITableViewDatasource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allAlbumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"groupTableViewCell";
    MyAssetGroupTableViewCell *cell = (MyAssetGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[MyAssetGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >=allAlbumArray.count)
    {
        return;
    }
    WJQAlbumModel *model = allAlbumArray[indexPath.row];
    [((MyAssetGroupTableViewCell *)cell) setMyAssetGroupTableViewCellWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self gotoAssetImageControllerWithModel:allAlbumArray[indexPath.row]];
}

- (void)gotoAssetImageControllerWithModel:(WJQAlbumModel *)model {
    MyAssetImageController *imageController = [[MyAssetImageController alloc]init];
    imageController.albumModel              = model;
    imageController.delegate                = self;
    imageController.maxSelectItem           = MaxCount;
    [self.navigationController pushViewController:imageController animated:YES];
}

#pragma mark - 按钮点击事件

- (void)cancle {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didCancleSelectImage:)])
        {
            [self.delegate didCancleSelectImage:self];
        }
    }];
}

#pragma mark - MyAssetGroupControllerDelegate

/**
 *  完成图片选择
 *
 *  @param controller 当前的MyAssetImageController
 *  @param imageArray 选取的图片数组 - 数组元素为image
 */
- (void)myAssetImageController:(MyAssetImageController *)controller didFinishSelectImage:(NSArray *)imageArray {
    if ([self.delegate respondsToSelector:@selector(myAssetGroupController:didFinishSelect:)])
    {
        [self.delegate myAssetGroupController:self didFinishSelect:imageArray];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/**
 *  取消图片选择
 *
 *  @param controller MyAssetImageController
 */
- (void)didCancleSelect:(MyAssetImageController *)controller {
    [self cancle];
}

@end
