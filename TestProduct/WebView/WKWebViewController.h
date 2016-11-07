//
//  WKWebViewController.h
//  TestProduct
//
//  Created by zhangke on 16/4/22.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WKWebViewController : UIViewController

@property (nonatomic,assign) BOOL hideNav;
@property (nonatomic,strong) NSURL *htmlUrl;

@end
