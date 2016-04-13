//
//  ZKPieChart.m
//  TestProduct
//
//  Created by zhangke on 16/2/29.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "ZKPieChart.h"

@implementation ZKPieChart

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        RenderView *pieChart = [[RenderView alloc]initWithFrame:self.bounds];
        pieChart.delegate = self;
        pieChart.dataSource = self;
        [pieChart setPieBackgroundColor:[UIColor grayColor]];
        [self addSubview:pieChart];
        [pieChart reloadData];
    }
    return self;
}

-(NSUInteger)numberOfSlicesInPieChart:(RenderView *)pieChart{
    return 3;
}

-(CGFloat)pieChart:(RenderView *)pieChart valueForSliceAtIndex:(NSUInteger)index{
    NSMutableArray *valueArray = [NSMutableArray arrayWithArray:@[@"16",@"65",@"20"]];
    return [valueArray[index]floatValue];
}

-(UIColor *)pieChart:(RenderView *)pieChart colorForSliceAtIndex:(NSUInteger)index{
    NSMutableArray *colorAry = [NSMutableArray arrayWithObjects:[UIColor redColor],[UIColor greenColor],[UIColor blueColor] ,nil];
    return colorAry[index];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
