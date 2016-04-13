//
//  BreathImageView.m
//  TestProduct
//
//  Created by zhangke on 15/12/25.
//  Copyright © 2015年 zhangke. All rights reserved.
//

#import "BreathImageView.h"

@implementation BreathImageView

-(instancetype)initWithFrame:(CGRect)frame outerImage:(UIImage*)outer innerImage:(UIImage*)inner{
    self =[super initWithFrame:frame];
    if (self) {
        UIImageView *outerIV = [[UIImageView alloc]initWithImage:outer];
        outerIV.frame = CGRectMake(0, 0, outerIV.frame.size.width, outerIV.frame.size.height);
        outerIV.center = self.center;
        
        UIImageView *innerIV = [[UIImageView alloc]initWithImage:inner];
        innerIV.center = outerIV.center;
        
        
        [self addSubview:outerIV];
        [self addSubview:innerIV];
        
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            
            outerIV.frame = innerIV.frame;
            
        } completion:nil];
        
        
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
