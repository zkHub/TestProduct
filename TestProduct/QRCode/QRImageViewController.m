//
//  QRImageViewController.m
//  TestProduct
//
//  Created by zhangke on 16/4/19.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "QRImageViewController.h"
#import "WebViewController.h"
#import "WKWebViewController.h"


@interface QRImageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImageView *_imageView;
}
@end

@implementation QRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"长按识别二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"qrCode2"];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 200, 200)];
    _imageView.image = image;
    _imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [_imageView addGestureRecognizer:longPress];
    
    [self.view addSubview:_imageView];
    
    [self createNavBar];
    
}


-(void)createNavBar{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 40);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitle:@"相册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}
-(void)goPhotoAlbum{
    
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        //访问图库失败
    }
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    /*
     info--
     {
     UIImagePickerControllerMediaType = "public.image";
     UIImagePickerControllerOriginalImage = "<UIImage: 0x7f87fe0c75e0> size {4288, 2848} orientation 0 scale 1.000000";
     UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=106E99A1-4F6A-45A2-B320-B0AD4A8E8473&ext=JPG";
     }
     */
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        _imageView.image = image;
        [self detectorImageInformationWithImage:image];
    }
    
}




-(void)longPress:(UILongPressGestureRecognizer*)gesture{
    
    if ([gesture.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView*)gesture.view;
        UIImage *image = imageView.image;
        
        [self detectorImageInformationWithImage:image];
        
    }
    
}


-(void)detectorImageInformationWithImage:(UIImage*)image{
    //初始化检测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    //设置识别结果数组
    NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(image)]];
    //是否识别成功
    if (features.count > 0) {
        CIQRCodeFeature *feature = [features firstObject];
        NSString *resultStr = feature.messageString;
        [self alertControllerMessage:resultStr];
    }else{
        [self alertControllerMessage:@"这不是一个二维码"];
    }
}

-(void)alertControllerMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if ([message isEqualToString:@"这不是一个二维码"]) {
            return;
        }
        WKWebViewController *webView = [[WKWebViewController alloc]init];
        webView.htmlUrl = [NSURL URLWithString:message];
        [self.navigationController pushViewController:webView animated:NO];
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
