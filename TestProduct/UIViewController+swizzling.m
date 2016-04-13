//
//  UIViewController+swizzling.m
//  TestProduct
//
//  Created by zhangke on 16/1/21.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "UIViewController+swizzling.h"
#import <objc/runtime.h>


@implementation UIViewController (swizzling)


+(void)load{
    [super load];
    
    // 通过class_getInstanceMethod()函数从当前对象中的method list获取method结构体，如果是类方法就使用class_getClassMethod()函数获取。
    Method fromMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method toMethod = class_getInstanceMethod([self class], @selector(swizzlingViewDidLoad));
    /**
     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
     */
    if (!class_addMethod([self class], @selector(viewDidLoad), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
    
}

// 我们自己实现的方法，也就是和self的viewDidLoad方法进行交换的方法。
-(void)swizzlingViewDidLoad{
    
    NSString *string = [NSString stringWithFormat:@"%@",self.class];
    
    if (![string containsString:@"UI"]) {
        NSLog(@"exchange succeeded2");
    }
    
//    由于是方法互换，并不会循环调用，而是对viewDidLoad的调用，但是现在是对super的互换，当前并不需要。
//    [self swizzlingViewDidLoad];
    
}


@end
