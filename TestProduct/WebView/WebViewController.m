//
//  WebViewController.m
//  TestProduct
//
//  Created by zhangke on 16/4/15.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "WebViewController.h"


//屏幕宽度
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation WebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    
    
    if (!self.htmlUrl) {
        self.htmlUrl = [[NSBundle mainBundle] URLForResource:@"test1" withExtension:@"html"];
    }
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.htmlUrl]];
    if (self.hideNav) {
        self.navigationController.navigationBarHidden = YES;
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
    [self.view addSubview:self.webView];
    
    [self creatNavBarItem];
    
}

-(void)creatNavBarItem{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 70, 30);
    [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(4.5, -20, 4.5, 20)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [button addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
-(void)backButton:(UIButton*)button{
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *relativePath = request.mainDocumentURL.relativePath;
    NSLog(@"\n--%@\n--%@",request.URL.absoluteString,relativePath);
    
    return YES;
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
