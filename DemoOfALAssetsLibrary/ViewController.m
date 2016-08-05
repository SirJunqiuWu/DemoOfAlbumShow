//
//  ViewController.m
//  DemoOfALAssetsLibrary
//
//  Created by JackWu on 15/2/26.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MyAssetPickerController.h"
#import "WJQUploadImageBaseView.h"

@interface ViewController ()<MyAssetPickerControllerDelegate,WJQUploadImageViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    WJQUploadImageBaseView *uploadImageBaseView;
}
@property(nonatomic,strong)UIImagePickerController *imagePicker;

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相册";
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建UI

- (void)setupUI {
    uploadImageBaseView = [[WJQUploadImageBaseView alloc]initWithFrame:CGRectMake(0,64.0,AppWidth,115.0)];
    [uploadImageBaseView.addBtn addTarget:self action:@selector(addBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadImageBaseView];
    
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = AppFrame(10,self.view.height-50,self.view.width-20,40);
    okBtn.layer.cornerRadius = 2.0;
    okBtn.layer.masksToBounds = YES;
    okBtn.backgroundColor = UIColorFromRGB(0x00ae66);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
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

- (void)addBtnPressed {
    UIActionSheet *actSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    actSheet.delegate = self;
    [actSheet showInView:self.view];
}

- (void)okBtnPressed {
    NSArray *uploadImagesArr = [uploadImageBaseView.imageViewsArr arrayWithObjectProperty:@"imageUrl"];
    if (uploadImagesArr.count == 0)
    {
        [self showAlertWithTitle:@"请选择图片"];
        return;
    }
    /**
     * 注:在此处已经获得网络的图片链接了,只需普通接口post即可(如若多张图片中有上传失败的,在此处需判断图片链接长度是否只为1,过滤上传服务器失败的)
     */
    [self showAlertWithTitle:[NSString stringWithFormat:@"当前上传%ld张图片",uploadImagesArr.count]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.delegate = self;
        [appDel.window.rootViewController presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        NSInteger remainCount = MaxCount - uploadImageBaseView.imageViewsArr.count;
        if (remainCount <= 0)
        {
            [self showAlertWithTitle:[NSString stringWithFormat:@"最多可选%d张图片",MaxCount]];
            return ;
        }
        MyAssetPickerController *viewController = [[MyAssetPickerController alloc]initWithMaxSelecteCount:remainCount];
        viewController.pickControllerDelegate = self;
        viewController.maxSelectItem = (int)remainCount;
        [self presentViewController:viewController animated:YES completion:NULL];
    }
    else
    {
        NSAssert(@"", nil);
    }
}

- (void)showAlertWithTitle:(NSString *)title {
    if (iOS8Later)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image != nil)
    {
        /**
         *  上传图片
         */
        [self showImageViewWithArray:@[image]];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showImageViewWithArray:(NSArray *)images {
    /**
     * 添加图片视图
     */
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
        WJQUploadImageView *imageview = [[WJQUploadImageView alloc]initWithFrame:AppFrame(0, 0, 90,90)];
        imageview.image    = image;
        imageview.imageUrl = [NSString stringWithFormat:@"%ld",idx];
        imageview.delegate = self;
        [uploadImageBaseView addImageView:imageview];
    }];
    /**
     * 后网络请求拿到图片的网络链接，并更换对应视图的图片链接(很关键)
     */
}

#pragma mark - WJQUploadImageViewDelegate

- (void)deleteBtnPressedWithObj:(WJQUploadImageView *)obj {
    [uploadImageBaseView removeImageViewByUrl:obj.imageUrl];
}

#pragma mark - MyAssetPickerControllerDelegate 最终选择完图片在这里处理

- (void)myAssetPickerController:(MyAssetPickerController *)pickerController didFinishSelect:(NSArray *)imageArray {
    NSLog(@"%@",imageArray);
    /**
     *  先展示
     */
    [self showImageViewWithArray:imageArray];
}

- (void)myAssetPickerController:(MyAssetPickerController *)pickerController selectImageFailedWithError:(NSError *)error {
    
}


- (void)didCancleSelectImage:(MyAssetPickerController *)pickerController {
    
}

@end
