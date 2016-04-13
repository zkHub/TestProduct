//
//  SouFunPieChartView.h
//  PieChartDemo
//
//  Created by 邱 育良 on 14-7-24.
//  Copyright (c) 2014年 搜房网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SouFunPieChartView : UIView

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *otherFlag;

/*
 *刷新饼状图
 */
- (void)reloadData;

@end

@interface SouFunRoundView : UIView
@property (nonatomic, copy) NSString *title;
@end

@interface SouFunSimplePieChartView : UIView

@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) NSString *firstCount;
@property (nonatomic, strong) NSString *secondCount;

+ (UIColor *)getPieChartColorWithIndex:(NSInteger)index;

@end
