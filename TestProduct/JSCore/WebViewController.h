//
//  WebViewController.h
//  TestProduct
//
//  Created by zhangke on 16/4/15.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic,assign) BOOL isHideNav;
@property (nonatomic,strong) NSURL *htmlUrl;

@end
