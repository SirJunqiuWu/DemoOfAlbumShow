//
//  MyAssetPickerController.m
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetPickerController.h"
#import "MyAssetGroupController.h"
#import "MyAssetImageController.h"

@interface MyAssetPickerController ()<MyAssetGroupControllerDelegate,MyAssetImageControllerDelegate>
{
    MyAssetGroupController *viewController;
    
    /**
     *  是否直接进入相机胶卷相册列表 YES是;反之首先是相册列表
     */
    BOOL isGotoAlbumRoll;
}
@end

@implementation MyAssetPickerController


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

/**
 *  重写init方法 -- 目的为设置MyAssetPickerController的RootViewController
 *
 *  @return 实例化之后的MyAssetPickerController
 */
- (id)initWithMaxSelecteCount:(NSInteger)maxSelectCount {
    viewController               = [[MyAssetGroupController alloc]init];
    viewController.maxSelectItem = (int)maxSelectCount;
    viewController.delegate      = self;
    isGotoAlbumRoll              = YES;
    self = [super initWithRootViewController:viewController];
    if (self)
    {
        [self checkauthorizationStatus];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  设置最大图片选择数量
 *
 *  @param maxSelectItem 最大图片选择数量
 */
-(void)setMaxSelectItem:(int)maxSelectItem
{
    viewController.maxSelectItem = maxSelectItem;
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
    else
    {
        if (isGotoAlbumRoll)
        {
            [[WJQAlbumManager sharedManager]getCameraRollAlbumWithIsAllowPickingVideo:NO Completion:^(WJQAlbumModel *model) {
                [self gotoAssetImageControllerWithModel:model];
            }];
        }
    }
}

- (void)gotoAssetImageControllerWithModel:(WJQAlbumModel *)model {
    MyAssetImageController *imageController = [[MyAssetImageController alloc]init];
    imageController.albumModel              = model;
    imageController.delegate                = self;
    imageController.maxSelectItem           = viewController.maxSelectItem;
    [super pushViewController:imageController animated:YES];
}


#pragma mark - MyAssetGroupControllerDelegate

/**
 *  确定选择按钮的委托
 *
 *  @param controller 当前的pickerController
 *  @param imageArray 图片数组 - 数组的元素为image
 */
- (void)myAssetGroupController:(MyAssetGroupController *)controller didFinishSelect:(NSArray *)imageArray {
    if (controller == viewController)
    {
        if ([self.pickControllerDelegate respondsToSelector:@selector(myAssetPickerController:didFinishSelect:)])
        {
            [self.pickControllerDelegate myAssetPickerController:self didFinishSelect:imageArray];
        }
    }
}

- (void)didCancleSelectImage:(MyAssetGroupController *)controller {
    if (controller == viewController)
    {
        if ([self.pickControllerDelegate respondsToSelector:@selector(didCancleSelectImage:)])
        {
            [self.pickControllerDelegate didCancleSelectImage:self];
        }
    }
}

#pragma mark - MyAssetPickerControllerDelegate

- (void)myAssetImageController:(MyAssetImageController *)controller didFinishSelectImage:(NSArray *)imageArray {
    NSLog(@"%@",imageArray);
    if ([self.pickControllerDelegate respondsToSelector:@selector(myAssetPickerController:didFinishSelect:)])
    {
        [self.pickControllerDelegate myAssetPickerController:self didFinishSelect:imageArray];
    }
}

- (void)myAssetImageController:(MyAssetImageController *)controller selectImageWithError:(NSError *)error {
    
}

- (void)didCancleSelect:(MyAssetImageController *)controller {
    if ([self.pickControllerDelegate respondsToSelector:@selector(didCancleSelectImage:)])
    {
        [self.pickControllerDelegate didCancleSelectImage:self];
    }
}


@end
