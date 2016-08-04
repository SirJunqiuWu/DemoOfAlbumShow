//
//  ViewController.m
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/2/26.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "ViewController.h"
#import "MyAssetPickerController.h"
#import "WJQUploadImageView.h"

@interface ViewController ()<MyAssetPickerControllerDelegate>

@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相册";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"进入相册" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮点击事件

- (void)rightItemPressed{
    /**
     *  进入相册
     */
    MyAssetPickerController *viewController = [[MyAssetPickerController alloc]init];
    viewController.pickControllerDelegate = self;
    [self presentViewController:viewController animated:YES completion:NULL];
}

#pragma mark - MyAssetPickerControllerDelegate 最终选择完图片在这里处理

- (void)myAssetPickerController:(MyAssetPickerController *)pickerController didFinishSelect:(NSArray *)imageArray {
    NSLog(@"%@",imageArray);
}

- (void)myAssetPickerController:(MyAssetPickerController *)pickerController selectImageFailedWithError:(NSError *)error {
    
}


- (void)didCancleSelectImage:(MyAssetPickerController *)pickerController {
    
}

@end
