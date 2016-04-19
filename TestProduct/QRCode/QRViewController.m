//
//  QRViewController.m
//  TestProduct
//
//  Created by zhangke on 16/4/18.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "QRViewController.h"
#import "KKQRView.h"



//屏幕宽度
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface QRViewController ()<KKQRViewDelegate>
{
    KKQRView *_QRView;
}
@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    _QRView =  [[KKQRView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _QRView.delegate = self;
    [self.view addSubview:_QRView];
    
    
}

-(void)creatNavigationBar{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 40);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"图片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goQRImage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)goQRImage{
    
    [self.navigationController pushViewController:nil animated:YES];
    
}

-(void)QRView:(KKQRView *)qrView scanResult:(NSString *)result{
    
    [qrView stopScan];
    [self showAlertControllerWithMessage:result];
    
}


-(void)showAlertControllerWithMessage:(NSString*)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_QRView startScan];
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
