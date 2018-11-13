//
//  KKQRView.h
//  TestProduct
//
//  Created by zhangke on 16/4/18.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKQRView;

@protocol KKQRViewDelegate <NSObject>

-(void)QRView:(KKQRView*)qrView scanResult:(NSString*)result;

@end


@interface KKQRView : UIView

@property (nonatomic,weak) id<KKQRViewDelegate>delegate;

-(void)startScan;
-(void)stopScan;

@end
