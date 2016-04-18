//
//  QRViewController.m
//  TestProduct
//
//  Created by zhangke on 16/4/18.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "QRViewController.h"
#import "KKQRView.h"

@interface QRViewController ()

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    KKQRView *qrView =  [[KKQRView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:qrView];
    
    
}

-(void)showAlertControllerWithMessage:(NSString*)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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
