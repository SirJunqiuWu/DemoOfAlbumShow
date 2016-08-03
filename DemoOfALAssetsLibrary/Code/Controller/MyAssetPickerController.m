//
//  MyAssetPickerController.m
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetPickerController.h"
#import "MyAssetGroupController.h"

@interface MyAssetPickerController ()<MyAssetGroupControllerDelegate>
{
    MyAssetGroupController *viewController;
}
@end

@implementation MyAssetPickerController

/**
 *  重写init方法 -- 目的为设置MyAssetPickerController的RootViewController
 *
 *  @return 实例化之后的MyAssetPickerController
 */
- (id)init {
    //设置默认值
    viewController = [[MyAssetGroupController alloc]init];
    viewController.maxSelectItem = 9;
    viewController.delegate = self;
    return [self initWithRootViewController:viewController];
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


@end
