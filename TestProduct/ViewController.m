//
//  ViewController.m
//  TestProduct
//
//  Created by zhangke on 15/8/13.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"
#import "EntryButton.h"
#import "Utilities.h"
#import "BreathImageView.h"
#import "Entity.h"
#import "Model.h"
#import "RSASecurity.h"
#import "SouFunPieChartView.h"
#import "AppDelegate.h"
#import "WebViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>



//屏幕宽度
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#pragma mark --tag值
#define ENTRYBTN_TAG 1000
#define DATABTN_TAG 2000
#define DATALABEL_TAG 3000

#define ROLEBTN_TAG 4000
#define IMAGE_TAG 5000


@interface ViewController ()<UIScrollViewDelegate,CALayerDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    UIView *dataView;
    UIImageView *selectLine;
    int btnCount;
    UIView *roleView;
    int roleCount;
    
}

@property (nonatomic, strong) RSASecurity *rsaSecurity;



@end

@implementation ViewController


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //在viewDidLoad和viewWillAppear加这个效果，由于控制器生成的视图直接盖在了启动页上，层级在其之上导致无法显示。
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreenId"];
    
    UIView *launchView = viewController.view;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = delegate.window;
    [mainWindow addSubview:launchView];
    
    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        launchView.alpha = 0.0f;
        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
    } completion:^(BOOL finished) {
        [launchView removeFromSuperview];
    }];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    self.view.backgroundColor = [Utilities colorWithHexString:@"#f4f4f4"];
//    btnCount = 12;
//    [self creatEntryView];
//    [self creatDataView];
//    [self creatUserInfoView];
//    roleCount = 4;
//    [self creatChangeRoleView];
//    [self creatAnimationImage];//呼吸灯
    
//    [self testLayer];
    
//    NSMutableString *astr = [@"1" copy];
//    NSLog(@"%@",astr);
    
//    [self testImageAction];
//    [self createCoreData];
    
//    [self testRSAEncrypt];
    
//    [self touchIDTest];
    
//    [self creatPieChartView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(110, 400, 100, 50);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(creatPieChartView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
    dateFor.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
    [dateFor setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [dateFor stringFromDate:date];
    NSLog(@"%@",string);
    
    date = [date dateByAddingTimeInterval:60 * 60 * 24];
    NSLog(@"%@",[date descriptionWithLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"]]);
    
    
//    NSLog(@"%@",[NSLocale availableLocaleIdentifiers]);

    
    float a = 346.0;
    float b = 137.5;
    float c = 0.0;
    int rate = 0;
    if (a + b == 0) {
        rate = 0;
    }else{
        c = a / (a + b);
        rate = round(c * 100);//round四舍五入函数不留小数点
    }
    
    [self getNumOfDaysWithDate:[NSDate date]];
    
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
    [mutableDict removeObjectForKey:@"1"];
    [mutableDict objectForKey:@"2"];
    
    
    NSMutableArray *array = [NSArray array].mutableCopy;
    [array addObject:@""];
    
}

- (IBAction)goWebView:(UIBarButtonItem *)sender {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    
    [self.navigationController pushViewController:webVC animated:YES];
}

-(NSInteger)getNumOfDaysWithDate:(NSDate*)date{
    
    NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
    dateFor.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
    [dateFor setDateFormat:@"yyyy"];
    NSInteger year = [[dateFor stringFromDate:date] integerValue];
    [dateFor setDateFormat:@"MM"];
    NSInteger month = [[dateFor stringFromDate:date] integerValue];
    
    NSInteger num = 31;
    switch (month) {
        case 4: case 6: case 9: case 11:
            num = 30;
            break;
        case 2:
        {
            if ((year % 400 == 0) || (year % 100 != 0 && year % 4 == 0)) {
                num = 29;
            }else{
                num = 28;
            }
        }
        default:
            break;
    }
    
    return num;
}



-(void)creatPieChartView{
    NSMutableArray *valueArray = [NSMutableArray arrayWithArray:@[@"16",@"65",@"20"]];
    NSMutableArray *colorAry = [NSMutableArray arrayWithObjects:[UIColor redColor],[UIColor greenColor],[UIColor blueColor] ,nil];
    SFPieChartView *pieChartView = [[SFPieChartView alloc]initWithFrame:CGRectMake(20, 20, 100, 100)];
    pieChartView.valueArray = valueArray;
    pieChartView.colorArray = colorAry;
//    pieChartView.title = @"abc";
    [self.view addSubview:pieChartView];
    
    
    
}


-(void)touchIDTest{
    
    //TouchID验证对象
    LAContext *context = [[LAContext alloc]init];
    context.localizedFallbackTitle = @"验证登录密码";//撤销按钮title
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //验证回调
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                
                NSLog(@"authen success");
                
             } else if (error) {
                
                NSLog(@"%ld",(long)error.code);
                
                switch (error.code) {
                        
                    case LAErrorAuthenticationFailed: {
                        

                    }
                        break;
                        
                    case LAErrorUserCancel: {
                        
  
                    }
                        break;
                        
                    case LAErrorUserFallback: {
                        
              
                    }
                        break;
                        
                    case LAErrorSystemCancel:{
                        
              
                    }
                        break;
                        
                    case LAErrorTouchIDNotEnrolled: {
                        
                    
                    }
                        break;
                        
                    case LAErrorPasscodeNotSet: {
                        
                 
                    }
                        break;
                        
                    case LAErrorTouchIDNotAvailable: {
                        
                 
                    }
                        break;
                        
                    case LAErrorTouchIDLockout: {
                        
                   
                    }
                        break;
                        
                    case LAErrorAppCancel:  {
                        
                    
                    }
                        break;
                        
                    case LAErrorInvalidContext: {
                        
                  
                    }
                        break;
                }
             }else{
                 
             }
        }];
        
    } else {
        NSLog(@"This device isn't supported");
    }
    
    
    
}


-(void)testRSAEncrypt{
    
    self.rsaSecurity = [[RSASecurity alloc]init];
    NSString *derPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    NSString *p12Path = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
    [self.rsaSecurity getPublicKeyFromDERFile:derPath];
    [self.rsaSecurity getPrivateKeyFromPKCS12File:p12Path password:@"1234"];
    
    NSString *enStr = @"神神气气神神气气不懂老师，辩驳最流利。神神气气神神气气不懂老师，辩驳最流利。神神气气神神气气不懂老师，辩驳最流利。神神气气神神气气不懂老师，辩驳最流利。I'm waiting for you!Hello World!";
    
    NSString *enString = [self.rsaSecurity rsaEncryptString:enStr];
    NSString *deString = [self.rsaSecurity rsaDecryptString:enString];
    NSLog(@"--\n%@\n--\n%@\n--",enString,deString);
    
}





-(void)testCFDictionary{
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: @"1234" forKey:(__bridge id)kSecImportExportPassphrase];
    CFDictionaryRef option1 = (__bridge CFDictionaryRef)options;
    
    CFStringRef password = (__bridge CFStringRef)@"1234";
    const void *keys[] = {
        kSecImportExportPassphrase
    };
    const void *values[] = {
        password
    };
    CFDictionaryRef option2 = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, NULL, NULL);
    if (option1 == option2 ) {
        NSLog(@"==");
    }
}


-(void)createCoreData{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *pathUrl = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    NSLog(@"%@\n%@\n%@",url,pathUrl,[NSString stringWithFormat:@"%@",pathUrl]);
    Model *model = [[Model alloc]init];
    model.name = @"wang";
    model.age = @"4";
    model.height = @"1.7";
    model.weight = @"60";
    [Entity insertObjectIntoDataBaseWithEntity:model];
    //    [Entity removeObjectFromDataBase];
    [Entity updateObjectFromDataBase];
    [Entity seacherObjectFromDataBase];
}

#pragma mark --图片剪切与拼接
-(void)testImageAction{
    
    
    UIImage *image1 = [UIImage imageNamed:@"闪烁icon"];
    UIImage *image2 = [UIImage imageNamed:@"灰色大圆icon"];
    
    CGImageRef imageRef = image1.CGImage;
    imageRef = CGImageCreateWithImageInRect(imageRef, CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)/2));
    UIImage* image3 = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    
    CGImageRef imageRef2 = image2.CGImage;
    imageRef2 = CGImageCreateWithImageInRect(imageRef2, CGRectMake(0, CGImageGetHeight(imageRef2)/2, CGImageGetWidth(imageRef2), CGImageGetHeight(imageRef2)/2));
    UIImage* image4 = [UIImage imageWithCGImage:imageRef2];
    CGImageRelease(imageRef2);
    
    
    UIGraphicsBeginImageContextWithOptions(image2.size, NO, 0);
    //Draw image2
    [image3 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height/2)];
    
    //Draw image1
    [image4 drawInRect:CGRectMake(0, image2.size.height / 2, image1.size.width, image1.size.height/2)];
    
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, image2.size.width, image2.size.height)];
    imageView.image = resultImage;
    [self.view addSubview:imageView];
    
    
}


#pragma mark --Layer及动画
-(void)testLayer{
//    //层&子层
//    CALayer *subLayer1 = [CALayer layer];
//    //常见属性
//    subLayer1.frame = CGRectMake(20, 20, 100, 20);
//    subLayer1.backgroundColor = [[UIColor blueColor]CGColor];
//    subLayer1.shadowOffset = CGSizeMake(4, 4);
//    subLayer1.shadowColor = [[UIColor darkGrayColor]CGColor];
//    subLayer1.shadowRadius = 3.0;
//    subLayer1.shadowOpacity = 0.8;
//    subLayer1.borderColor = [[UIColor redColor]CGColor];
//    subLayer1.borderWidth = 2.0f;
//    subLayer1.cornerRadius = 10.0f;
//    [self.view.layer addSublayer:subLayer1];
//
//    
//    CALayer *subLayer2 = [CALayer layer];
//    subLayer2.frame = CGRectMake(130, 20, 170, 400);
//    subLayer2.backgroundColor = [[UIColor blueColor]CGColor];
//    //给层贴图
//    subLayer2.contents = (id)[UIImage imageNamed:@"1"].CGImage;
//    subLayer2.cornerRadius = 10.0f;
//    //有蒙板，阴影出不来
//    subLayer2.shadowColor = [[UIColor darkGrayColor] CGColor];
//    subLayer2.shadowOffset = CGSizeMake(1, 1);
//    subLayer2.shadowOpacity = 0.8f;
//    subLayer2.shadowRadius = 1.0f;
//    subLayer2.masksToBounds = YES;//蒙板
//    
//    [self.view.layer addSublayer:subLayer2];
//    
    CALayer *customLayer = [CALayer layer];
    customLayer.frame = self.view.frame;
    customLayer.cornerRadius = 10.0f;
    customLayer.backgroundColor = [[UIColor clearColor] CGColor];
    //重绘，drawLayer，需要设置delegate
    customLayer.delegate = self;
    [customLayer setNeedsDisplay];//重绘
    [self.view.layer addSublayer:customLayer];
    
    
//    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
//    aView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:aView];
//        
//    //路径
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, nil, 20, 20);
//    CGPathAddCurveToPoint(path, nil, 10, 10, 200, 200, 200, 500);
//    //动画1
//    CAKeyframeAnimation *keyAnima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    keyAnima.path = path;
//    keyAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    //动画2,旋转
//    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
//    basicAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    basicAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 1, 0)];
//    //动画3,透明度
//    CABasicAnimation *basicAnima2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    basicAnima2.fromValue = @0.0;
//    basicAnima2.toValue = @1.0;
//    //动画4,颜色
//    CABasicAnimation *basicAnima3 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
//    basicAnima3.toValue = (id)[UIColor blueColor].CGColor;
//    //组动画
//    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
//    groupAnima.animations = @[keyAnima,basicAnima,basicAnima2,basicAnima3];
//    groupAnima.duration = 10.0f;
//    groupAnima.delegate = self;
//    groupAnima.autoreverses = YES;
//    groupAnima.repeatDuration = 60.0f;
//    [aView.layer addAnimation:groupAnima forKey:nil];

    
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 10, 10)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(80, 30, 10, 10)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(30, 180, 10, 10)];
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(100, 250, 10, 10)];
    view1.backgroundColor = [UIColor redColor];
    view2.backgroundColor = [UIColor redColor];
    view3.backgroundColor = [UIColor redColor];
    view4.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    [self.view addSubview:view4];

    
    //如果需要在layer中添加自定义的内容，需要重写该方法
    CGContextSaveGState(ctx);
    //画三角形
    CGContextMoveToPoint(ctx, 20, 20);
    CGContextAddCurveToPoint(ctx, 80, 30, 30, 180, 100, 250);
//    CGContextAddLineToPoint(ctx, 20, 120);
//    CGContextAddLineToPoint(ctx, 120, 20);
//    CGContextAddLineToPoint(ctx, 20, 20);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blueColor] CGColor]);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
    
}




-(void)creatAnimationImage{
    
//    UIImageView *outerIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"灰色大圆icon"]];
//    outerIV.frame = CGRectMake(0, 0, outerIV.frame.size.width, outerIV.frame.size.height);
//    outerIV.center = self.view.center;
//    
//    UIImageView *innerIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"内圆icon"]];
//    innerIV.center = outerIV.center;
//
//    
//    [self.view addSubview:outerIV];
//    [self.view addSubview:innerIV];
//    
//    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
//        
//        outerIV.frame = innerIV.frame;
//        
//    } completion:nil];
    
    BreathImageView *breathLightIV = [[BreathImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30) outerImage:[UIImage imageNamed:@"闪烁icon"] innerImage:[UIImage imageNamed:@"内圆icon"]];
    breathLightIV.center = self.view.center;
    [self.view addSubview:breathLightIV];
    
}


-(void)creatChangeRoleView{
    
    roleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 15, SCREEN_WIDTH, 45 * roleCount)];
    roleView.backgroundColor = [Utilities colorWithHexString:@"#fefefe"];
    [self.view addSubview:roleView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [Utilities colorWithHexString:@"#f4f4f4"];
    [roleView addSubview:lineView];
    
    for (int i = 0; i < roleCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, i * 45, SCREEN_WIDTH, 45);
        button.tag = i + ROLEBTN_TAG;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(selectRoleButton:) forControlEvents:UIControlEventTouchUpInside];
        [roleView addSubview:button];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 50, 45)];
        label.text = @"销售部负责人";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [Utilities colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:15];
        [button addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 37, 15, 15, 11)];
        imageView.image = [UIImage imageNamed:@"勾选"];
        if (i == 0) {
            imageView.hidden = NO;
        }else{
            imageView.hidden = YES;
        }
        imageView.tag = i + IMAGE_TAG;
        [button addSubview:imageView];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(button.frame) - 1, SCREEN_WIDTH - 15, 1)];
        lineView.backgroundColor = [Utilities colorWithHexString:@"#f4f4f4"];
        [roleView addSubview:lineView];
        
    }
    UIView *line2View = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(roleView.bounds) - 1, SCREEN_WIDTH, 1)];
    line2View.backgroundColor = [Utilities colorWithHexString:@"#f4f4f4"];
    [roleView addSubview:line2View];
    
}

-(void)selectRoleButton:(UIButton*)button{

    UIImageView *imageView = (UIImageView*)[button viewWithTag:button.tag + 1000];
    imageView.hidden = NO;
    
    for (int i = 0; i < roleCount; i++) {
        UIButton *btn = (UIButton*)[roleView viewWithTag:i + ROLEBTN_TAG];
        if (btn.tag != button.tag) {
            UIImageView *imageView = (UIImageView*)[btn viewWithTag:btn.tag + 1000];
            imageView.hidden = YES;
        }
    }
}





-(void)creatUserInfoView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 15, SCREEN_WIDTH, 120)];
    headerView.backgroundColor = [Utilities colorWithHexString:@"#fefefe"];
    [self.view addSubview:headerView];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 28, 45, 16)];
    headLabel.text = @"头像";
    headLabel.font = [UIFont systemFontOfSize:15];
    headLabel.textColor = [Utilities colorWithHexString:@"#333333"];
    headLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:headLabel];
    
    UIImage *rightImage = [UIImage imageNamed:@"灰箭头"];

    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = CGRectMake(CGRectGetMaxX(headLabel.frame), 0, SCREEN_WIDTH - CGRectGetMaxX(headLabel.frame), 75);
    headBtn.backgroundColor = [UIColor clearColor];
    [headBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(headBtn.frame), SCREEN_WIDTH - 15, 1)];
    lineView.backgroundColor = [Utilities colorWithHexString:@"#f4f4f4"];
    [headerView addSubview:lineView];
    
    float width = headBtn.frame.size.width;
    UIImageView *rightIV = [[UIImageView alloc]initWithFrame:CGRectMake(width - 24, 30, 9, 15)];
    rightIV.image = rightImage;
    [headBtn addSubview:rightIV];
    UIImageView *headerIV = [[UIImageView alloc]initWithFrame:CGRectMake(width - 88, 10, 55, 55)];
    headerIV.image = [UIImage imageNamed:@"1"];
    [headBtn addSubview:headerIV];
    

    UILabel *roleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 120 - 30, 45, 15)];
    roleLabel.text = @"角色";
    roleLabel.font = [UIFont systemFontOfSize:15];
    roleLabel.textColor = [Utilities colorWithHexString:@"#333333"];
    roleLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:roleLabel];
    
    UIButton *roleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    roleBtn.frame = CGRectMake(CGRectGetMaxX(roleLabel.frame), 75, SCREEN_WIDTH - CGRectGetMaxX(roleLabel.frame), 45);
    roleBtn.backgroundColor = [UIColor clearColor];
    [roleBtn addTarget:self action:@selector(roleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:roleBtn];
    
    UIImageView *right1IV = [[UIImageView alloc]initWithFrame:CGRectMake(width - 24, 15, 9, 15)];
    right1IV.image = rightImage;
    [roleBtn addSubview:right1IV];
    
    UILabel *role_Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width - 33, 45)];
    role_Label.textAlignment = NSTextAlignmentRight;
    role_Label.font = [UIFont systemFontOfSize:15];
    role_Label.textColor = [Utilities colorWithHexString:@"#333333"];
    role_Label.text = @"销售部负责人";
    [roleBtn addSubview:role_Label];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame) + 15, SCREEN_WIDTH, 45);
    logoutBtn.backgroundColor = [Utilities colorWithHexString:@"#fefefe"];
    [logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    
    UILabel *logoutLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    logoutLabel.text = @"退出登录";
    logoutLabel.textAlignment = NSTextAlignmentCenter;
    logoutLabel.font = [UIFont systemFontOfSize:13];
    logoutLabel.textColor = [Utilities colorWithHexString:@"#ff3333"];
    [logoutBtn addSubview:logoutLabel];
}

-(void)headerButtonClick:(UIButton*)button{
    NSLog(@"headerButtonClick");
}
-(void)roleButtonClick:(UIButton*)button{
    NSLog(@"roleButtonClick");
}
-(void)logoutBtnClick:(UIButton*)button{
    NSLog(@"logoutBtnClick");
}















#pragma mark --入口View
-(void)creatEntryView{
    
    float viewHeight = 0;//scrollViewHeight
    if (btnCount <= 4) {
        viewHeight = 113;
    }else if (btnCount <= 8){
        viewHeight = 215;
    }else{
        viewHeight = 230;
    }

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, viewHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    int count = 0;
    if (btnCount%8 == 0) {
        count = btnCount/8;
    }else{
        count = btnCount/8 + 1;
    }
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * count, 0);
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    float btnWidth = SCREEN_WIDTH/4;
    float btnHeight = btnWidth + 5;

    for (int i = 0; i < btnCount; i++) {
        EntryButton *button = [[EntryButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4 * (i%4) + i/8 * SCREEN_WIDTH, btnHeight * (i%8/4), btnWidth, btnHeight)];
        button.tag = i + ENTRYBTN_TAG;
        button.btnImage = @"1";
        button.btnTitle = @"项目名称";
        [button layoutSubviews];
        [button addTarget:self action:@selector(entryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
    }
    if (btnCount > 8) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) - 20, SCREEN_WIDTH, 20)];
        _pageControl.numberOfPages = count;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        [self.view addSubview:_pageControl];
    }
    
}
#pragma mark --数据View
-(void)creatDataView{
    //数据展示View
    dataView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) + 15, SCREEN_WIDTH, 220)];
    dataView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dataView];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 45)];
    titleLable.text = @"关键数据";
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.font = [UIFont systemFontOfSize:17];
    titleLable.textColor = [UIColor blackColor];
    titleLable.backgroundColor = [UIColor whiteColor];
    [dataView addSubview:titleLable];
    
    
    NSArray *btnTitleArr = @[@"今天",@"昨天",@"本周",@"本月"];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * SCREEN_WIDTH / 4, CGRectGetMaxY(titleLable.frame), SCREEN_WIDTH / 4, 45);
        button.tag = DATABTN_TAG + i;
        [button setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(refreshKeyData:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
        }
        [dataView addSubview:button];
    }
    selectLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLable.frame) + 43, SCREEN_WIDTH / 4, 2)];
    selectLine.image = [UIImage imageNamed:@"矩形-19"];
    [dataView addSubview:selectLine];
    
    NSArray *dataNameArr = @[@"在执行项目",@"订单客户数",@"到访客户数",@"退认购",@"办卡客户数",@"认购客户数",@"签约客户数",@"收益"];
    for (int j = 0; j < 8; j++) {
        UILabel *dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(j % 4 *SCREEN_WIDTH / 4,CGRectGetMaxY(selectLine.frame) + j / 4 * 60, SCREEN_WIDTH / 4, 40)];
        dataLabel.tag = DATALABEL_TAG + j;
        dataLabel.text = @"0";
        dataLabel.textColor = [UIColor redColor];
        dataLabel.textAlignment = NSTextAlignmentCenter;
        [dataView addSubview:dataLabel];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(dataLabel.frame), CGRectGetMaxY(dataLabel.frame), SCREEN_WIDTH / 4, 20)];
        nameLabel.text = dataNameArr[j];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textColor = [UIColor blackColor];
        [dataView addSubview:nameLabel];
        
    }
    
}

#pragma mark --scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    _pageControl.currentPage = currentPage;
}

#pragma mark --entryButtonClick
-(void)entryButtonClick:(UIButton*)button{
    NSLog(@"entryButtonClick--%ld",(long)button.tag);
}
#pragma mark --refreshKeyData
-(void)refreshKeyData:(UIButton*)button{
    button.selected = YES;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = (UIButton*)[dataView viewWithTag:DATABTN_TAG + i];
        if (btn.tag != button.tag) {
            btn.selected = NO;
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect lineFrame = selectLine.frame;
        lineFrame.origin.x = (button.tag - DATABTN_TAG) * SCREEN_WIDTH / 4;
        selectLine.frame = lineFrame;
    }];
    
    NSLog(@"refreshKeyData--%ld",(long)button.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
