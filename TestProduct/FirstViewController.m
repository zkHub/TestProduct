//
//  FirstViewController.m
//  TestProduct
//
//  Created by zhangke on 2016/11/18.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "FirstViewController.h"
#import <MessageUI/MessageUI.h>
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"first";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor cyanColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(sendMFMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)sendMFMessage{
    UIDevice *device = [UIDevice currentDevice];
    Class messsageClass = NSClassFromString(@"MFMessageComposeViewController");
    if ([device.model isEqualToString:@"iPhone"] && messsageClass != nil) {
        if ([messsageClass canSendText]) {
            MFMessageComposeViewController *MFMessageCVC = [[MFMessageComposeViewController alloc]init];
            [self presentViewController:MFMessageCVC animated:YES completion:^{
                
            }];
            
        }else{
            NSLog(@"Not Support");
        }
    }else{
        NSLog(@"Not Support");
    }
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
