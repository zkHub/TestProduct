//
//  QRImageViewController.m
//  TestProduct
//
//  Created by zhangke on 16/4/19.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "QRImageViewController.h"
#import "WebViewController.h"

@interface QRImageViewController ()

@end

@implementation QRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"长按识别二维码";
    
    UIImage *image = [UIImage imageNamed:@"qrCode2"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 200, 200)];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [imageView addGestureRecognizer:longPress];
    
    [self.view addSubview:imageView];
    
    
}

-(void)longPress:(UILongPressGestureRecognizer*)gesture{
    
    if ([gesture.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView*)gesture.view;
        UIImage *image = imageView.image;
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
    
    
}

-(void)alertControllerMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        WebViewController *webView = [[WebViewController alloc]init];
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
