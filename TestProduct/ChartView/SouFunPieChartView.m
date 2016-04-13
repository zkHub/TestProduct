//
//  SouFunPieChartView.m
//  PieChartDemo
//
//  Created by 邱 育良 on 14-7-24.
//  Copyright (c) 2014年 搜房网. All rights reserved.
//

#import "SouFunPieChartView.h"

#define DEGREES_TO_RADIAN(x) (M_PI * (x) / 180.0)
#define RADIAN_TO_DEGREES(x) 180 * (x) / M_PI
#define HEXCOLOR(hexString) [UIColor colorWithRed:((float)((hexString & 0xFF0000) >> 16))/255.0 green:((float)((hexString & 0xFF00) >> 8))/255.0 blue:((float)(hexString & 0xFF))/255.0 alpha:1.0]

@interface SouFunPieChartView ()
{
    CGFloat startAngle;
    CGFloat endAngle;
}
@end

@implementation SouFunPieChartView

@synthesize valueArray;
@synthesize colorArray;
@synthesize margin;
@synthesize title;
@synthesize otherFlag;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.margin = 30;
    }
    return self;
}

- (void)reloadData
{
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    startAngle = 0;
    CGFloat lastEndAngle = 0;
    float sum = 0;
    for (int j = 0; j < [self.valueArray count]; j++) {
        sum +=[self.valueArray[j] floatValue];
    }
    
    CGFloat radius = rect.size.width/2.0 - self.margin;

    for (int i = 0; i < [self.valueArray count]; i++) {
        endAngle = startAngle + 2 * M_PI * [self.valueArray[i] floatValue]/sum;
        //填充
        CGContextSetFillColorWithColor(context, [self.colorArray[i]CGColor]);
        CGContextMoveToPoint(context, rect.size.width/2.0, rect.size.width/2.0);
        CGContextAddArc(context, rect.size.width/2.0, rect.size.width/2.0, rect.size.width/2.0 - self.margin, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
        //百分比文字
        CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
        CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
        CGFloat xPosition = rect.size.width/2 + radius/1.5 * cos(lastEndAngle + (endAngle - startAngle)/2.0);
        CGFloat yPosition = rect.size.width/2 + radius/1.5 * sin(lastEndAngle + (endAngle - startAngle)/2.0);
        
        CGFloat xPosition2 = rect.size.width/2 + radius * cos(lastEndAngle + (endAngle - startAngle)/2.0);
        CGFloat yPosition2 = rect.size.width/2 + radius * sin(lastEndAngle + (endAngle - startAngle)/2.0);
        
        CGContextMoveToPoint(context, xPosition, yPosition);
        CGContextAddLineToPoint(context, xPosition2, yPosition2);
        
        
        if (xPosition <= rect.size.width/2) {
            CGContextAddLineToPoint(context, xPosition2 - 2, yPosition2);
            NSString *percentStr = nil;
            if (i == [self.valueArray count] - 1 && [self.otherFlag isEqualToString:@"其他"]) {
                percentStr = @"其他";
            } else {
                percentStr = [NSString stringWithFormat:@"%.0f%%",100 * [self.valueArray[i] floatValue]/sum];
            }
            [percentStr drawAtPoint:CGPointMake(xPosition2 - 2 - 20, yPosition2-4) withFont:[UIFont systemFontOfSize:8]];
        } else {
            CGContextAddLineToPoint(context, xPosition2 + 2, yPosition2);
            NSString *percentStr = nil;
            if (i == [self.valueArray count] - 1 && [self.otherFlag isEqualToString:@"其他"]) {
                percentStr = @"其他";
            } else {
                percentStr = [NSString stringWithFormat:@"%.0f%%",100 * [self.valueArray[i] floatValue]/sum];
            }
            [percentStr drawAtPoint:CGPointMake(xPosition2 + 2, yPosition2-4) withFont:[UIFont systemFontOfSize:8]];
        }
        CGContextStrokePath(context);

        startAngle = endAngle;
        lastEndAngle = endAngle;
    }
    //中间圆圈
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextMoveToPoint(context, rect.size.width/2.0, rect.size.width/2.0);
    CGContextAddArc(context, rect.size.width/2.0, rect.size.width/2.0, radius/2, 0, 2 * M_PI, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    /*
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    if (self.title) {
        [self.title drawAtPoint:CGPointMake(rect.size.width/2.0 - 13, rect.size.width/2.0 - 9) withFont:[UIFont systemFontOfSize:14]];
    }
    */
    
    //扇形动画遮罩
    SouFunRoundView *roundView = [[SouFunRoundView alloc] initWithFrame:self.bounds];
//    roundView.layer.position = CGPointMake(75, 75);
    roundView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    if (self.title) {
        roundView.title = self.title;
    }
    
    [self addSubview:roundView];
    
    
}

- (UIColor *)getPieChartColorWithIndex:(NSInteger)index
{
    NSArray *allColor = @[HEXCOLOR(0x5b8ce0),//1.群青蓝
                          HEXCOLOR(0xf4d55c),//2.橙黄
                          HEXCOLOR(0xcb62c0),//3.紫红
                          HEXCOLOR(0x73eb5b),//4.叶绿
                          HEXCOLOR(0x9973f5),//5.青紫
                          HEXCOLOR(0xbeef5c),//6.青黄
                          HEXCOLOR(0x7377f5),//7.群青
                          HEXCOLOR(0xf48965),//8.橙红
                          HEXCOLOR(0x5dd4a2),//9.蓝绿
                          HEXCOLOR(0xf4ab5c) //10.橙
                          ];
    return (UIColor *)allColor[index];
}




@end

@interface SouFunRoundView ()
{
    CGFloat endAngle;
}
@property (nonatomic, strong)NSTimer *timer;

@end
@implementation SouFunRoundView
@synthesize timer;
@synthesize title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        endAngle = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(foldAction) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)foldAction
{
    if (endAngle <= 2 * M_PI) {
        endAngle += 0.5;
        [self setNeedsDisplay];
    } else {
        [self.timer invalidate];
        self.timer = nil;
        //        self.hidden = YES;
    }
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextMoveToPoint(context, rect.size.width/2.0, rect.size.width/2.0);
    CGContextAddArc(context, rect.size.width/2.0, rect.size.width/2.0, rect.size.width/2.0, endAngle >= 2 * M_PI?2 * M_PI:endAngle, 2 * M_PI, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    if (self.title) {
        [self.title drawAtPoint:CGPointMake(rect.size.width/2.0 - 13, rect.size.width/2.0 - 9) withFont:[UIFont systemFontOfSize:14]];
    }
}
@end

@implementation SouFunSimplePieChartView

+ (UIColor *)getPieChartColorWithIndex:(NSInteger)index
{
    NSArray *allColor = @[HEXCOLOR(0x5b8ce0),//1.群青蓝
                          HEXCOLOR(0xf4d55c),//2.橙黄
                          HEXCOLOR(0xcb62c0),//3.紫红
                          HEXCOLOR(0x73eb5b),//4.叶绿
                          HEXCOLOR(0x9973f5),//5.青紫
                          HEXCOLOR(0xbeef5c),//6.青黄
                          HEXCOLOR(0x7377f5),//7.群青
                          HEXCOLOR(0xf48965),//8.橙红
                          HEXCOLOR(0x5dd4a2),//9.蓝绿
                          HEXCOLOR(0xf4ab5c) //10.橙
                          ];
    return (UIColor *)allColor[index];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    static float startAngle = 0;
    static float endAngle = 0;
    float sum = 0;
    for (int j = 0; j < 2; j++) {
        sum +=[self.valueArray[j] floatValue];
    }
    for (int i = 0; i < 2; i++) {
        endAngle = startAngle + 2 * M_PI * [self.valueArray[i] floatValue]/sum;
        CGContextSetFillColorWithColor(context, [[SouFunSimplePieChartView getPieChartColorWithIndex:i] CGColor]);
        CGContextMoveToPoint(context, rect.size.width/2.0, rect.size.width/2.0);
        
        CGContextAddArc(context, rect.size.width/2.0, rect.size.width/2.0, rect.size.width/2.0, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
        startAngle = endAngle;
    }
}

@end

