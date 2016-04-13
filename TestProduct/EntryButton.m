//
//  EntryButton.m
//  TestProduct
//
//  Created by zhangke on 15/8/14.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "EntryButton.h"

@implementation EntryButton
{
    UIImageView *imageView;
    UILabel *label;

}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    float width = frame.size.width;
    if (self) {
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, width - 30, width - 30)];
        imageView.image = [UIImage imageNamed:self.btnImage];
        [self addSubview:imageView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, width - 15, width, 20)];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.btnTitle;
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        
    }
    return self;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    imageView.image = [UIImage imageNamed:self.btnImage];
    label.text = self.btnTitle;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
