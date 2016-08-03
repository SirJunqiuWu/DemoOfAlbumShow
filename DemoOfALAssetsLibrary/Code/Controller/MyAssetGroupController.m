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
    
    /**
     *  是否为第一次进入这个VC -- 第一次的时候需要直接跳转到图片列表页，否则为页面加载
     */
    BOOL isFirst;
}
@end

@implementation MyAssetGroupController
@synthesize allAlbumArray;

- (id)init {
    self = [super init];
    if (self) {
        isFirst = YES;
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

#pragma mark - 检测是否具有权限

- (void)checkauthorizationStatus {
    if (![[WJQAlbumManager sharedManager]authorizationStatusAuthorized])
    {
        NSString *appName     = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (appName.length == 0)
        {
           appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        }
        
        NSString *alertText    = [NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册。",[UIDevice currentDevice].model,appName];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:alertText delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        /**
         *  注:可以在此添加定时器，隔一段时间检测相册访问权限
         */
    }
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
    MyAssetImageController *imageController = [[MyAssetImageController alloc]init];
    imageController.albumModel              = allAlbumArray[indexPath.row];
    imageController.delegate                = self;
    [self.navigationController pushViewController:imageController animated:YES];
}

#pragma mark - 默认进来是进 相机胶卷相册

- (void)getAssetGroupFinish
{
    self.title = @"照片";
    
    if (isFirst == YES)
    {
        isFirst = NO;
//        MyAssetImageController *viewController = [[MyAssetImageController alloc]init];
//        viewController.assetsGroup = [self.groups objectAtIndex:0];
//        viewController.maxSelectItem = self.maxSelectItem;
//        viewController.delegate = self;
//        [self.navigationController pushViewController:viewController animated:NO];
    }
    else
    {
        [imageGroupTableView reloadData];
    }
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
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(myAssetGroupController:didFinishSelect:)])
        {
            [self.delegate myAssetGroupController:self didFinishSelect:imageArray];
        }
    }];
}

/**
 *  取消图片选择
 *
 *  @param controller <#controller description#>
 */
- (void)didCancleSelect:(MyAssetImageController *)controller {
    [self cancle];
}

@end
