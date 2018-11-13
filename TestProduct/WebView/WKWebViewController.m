//
//  WKWebViewController.m
//  TestProduct
//
//  Created by zhangke on 16/4/22.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "WKWebViewController.h"


//屏幕宽度
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.htmlUrl) {
        self.htmlUrl = [[NSBundle mainBundle] URLForResource:@"test2" withExtension:@"html"];
    }
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
//    self.webView.scrollView.scrollEnabled = NO;
    //允许左右划手势导航,默认不开启
    self.webView.allowsBackForwardNavigationGestures = YES;
    
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
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
-(void)backButton:(UIButton*)button{
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark --WKNavigationDelegate,WKUIDelegate
// 是否允许加载网页 在发送请求之前，决定是否跳转
// 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
// 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *urlString = navigationAction.request.URL.absoluteString;
    urlString = [urlString stringByRemovingPercentEncoding];//URL解码
    NSLog(@"%@",urlString);
    
    if ([urlString containsString:@"itms-appss"]) {
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    
}
//-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    
//    NSString *responseStr = navigationResponse.response.URL.absoluteString;
//    NSLog(@"%@",responseStr);
//    
//    decisionHandler(WKNavigationResponsePolicyAllow);
//    
//}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
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
