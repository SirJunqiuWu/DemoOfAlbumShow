//
//  ViewController.m
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/2/26.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "ViewController.h"
#import "MyAssetPickerController.h"

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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width - 200)/2, 100, 200, 30);
    [button setTitle:@"进入相册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonIsTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buttonIsTouch:(UIButton *)paramSender{
    //进入相册
    MyAssetPickerController *viewController = [[MyAssetPickerController alloc]init];
    viewController.pickControllerDelegate = self;
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

#pragma mark - MyAssetPickerControllerDelegate 最终选择完图片在这里处理

- (void)myAssetPickerController:(MyAssetPickerController *)pickerController didFinishSelect:(NSArray *)imageArray {
    NSLog(@"%@",imageArray);
}

- (void)myAssetPickerController:(MyAssetPickerController *)pickerController selectImageFailedWithError:(NSError *)error {
    
}


-(void)didCancleSelectImage:(MyAssetPickerController *)pickerController {
    
}

@end
