//
//  PieChartView.m
//  TestProduct
//
//  Created by zhangke on 16/3/1.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "SFPieChartView.h"


@interface SFPieChartView ()
{
    CGFloat startAngle;
    CGFloat endAngle;
}

@end

@implementation SFPieChartView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    startAngle = 0;
    float sum = 0;
    for (int i = 0; i < self.valueArray.count; i++) {
        sum += [self.valueArray[i] floatValue];
    }
    
    CGFloat radius = rect.size.width / 2.0;
    
    for (int j = 0; j < self.valueArray.count; j++) {
        //画扇形
        endAngle = startAngle + 2 * M_PI * [self.valueArray[j] floatValue] / sum;
        CGContextSetFillColorWithColor(context, [self.colorArray[j]CGColor]);
        CGContextMoveToPoint(context, radius, radius);
        CGContextAddArc(context, radius, radius, radius - 1, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
        
        startAngle = endAngle;

    }
    
    //中间空白圈
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor]CGColor]);
    CGContextMoveToPoint(context, radius, radius);
    CGContextAddArc(context, radius, radius, radius / 2, 0, 2 * M_PI, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    //遮罩动画
    ShadeView *myShadeView = [[ShadeView alloc]initWithFrame:self.bounds];
    [self addSubview:myShadeView];
}


@end


#pragma mark --ShadeView

@interface ShadeView ()
{
    CGFloat startAngle;
}
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation ShadeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        startAngle = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(foldAction) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)foldAction{
    if (startAngle <= 2 * M_PI) {
        startAngle += 0.5;
        [self setNeedsDisplay];
    }else{
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)drawRect:(CGRect)rect{
    
    CGFloat radius = rect.size.width / 2.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor]CGColor]);
    CGContextMoveToPoint(context, radius, radius);
    CGContextAddArc(context, radius, radius, radius, startAngle >= 2 * M_PI ? 2 * M_PI : startAngle, 2 * M_PI, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
}

@end









