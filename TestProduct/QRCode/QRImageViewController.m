//
//  QRImageViewController.m
//  TestProduct
//
//  Created by zhangke on 16/4/19.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "QRImageViewController.h"

@interface QRImageViewController ()

@end

@implementation QRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 200, 200)];
    imageView.image = [UIImage imageNamed:@"qrCode"];
    imageView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [imageView addGestureRecognizer:longPress];
    
    [self.view addSubview:imageView];
    
    
}

-(void)longPress:(UILongPressGestureRecognizer*)gesture{
    
    
    
    
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
