//
//  KKQRView.m
//  TestProduct
//
//  Created by zhangke on 16/4/18.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "KKQRView.h"
#import <AVFoundation/AVFoundation.h>


@interface KKQRView ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation KKQRView{
    AVCaptureSession *_session;
    UIImageView *_scanView;
    UIImageView *_lineView;
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    UIImage *scanImage = [UIImage imageNamed:@"scanscanBg"];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat scanW = width - 120;
    CGRect scanFrame = CGRectMake(width / 2 - scanW / 2, height / 2 - scanW / 2 - 64, scanW, scanW);
    
    _scanView = [[UIImageView alloc]initWithImage:scanImage];
    _scanView.backgroundColor = [UIColor clearColor];
    _scanView.frame = scanFrame;
    [self addSubview:_scanView];
    
    //获取摄像设备
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //闪光灯配置
    if ([device hasFlash] && [device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setFlashMode:AVCaptureFlashModeAuto];
        [device setTorchMode:AVCaptureTorchModeAuto];
        [device unlockForConfiguration];
    }
    
    //创建输入流
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    //创建输出流(元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理到线程中
    //在扫描的过程中，会分析扫描的内容，分析成功后就会调用代理方法在队列中输出
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描区域限制
    output.rectOfInterest = [self rectOfInterestWithScanFrame:scanFrame];
    
    //设置采集对象
    _session = [[AVCaptureSession alloc]init];
    //采集率
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    if (input) {
        [_session addInput:input];
    }
    if (output) {
        [_session addOutput:output];
        //设置扫码可支持的格式
        //指定识别类型一定要放到添加到session之后
        output.metadataObjectTypes = output.availableMetadataObjectTypes;
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    
    [self bringSubviewToFront:_scanView];
    [self setAnimationForScanView:_scanView];
    [self setOtherView];
    
    [_session startRunning];
}

-(CGRect)rectOfInterestWithScanFrame:(CGRect)frame{
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    //扫描区设置是右上为原点的相对比例值，且x,y对调，w,h对调。
    CGFloat x = CGRectGetMinY(frame) / height;
    CGFloat y = CGRectGetMinX(frame) / width;
    CGFloat w = CGRectGetHeight(frame) / height;
    CGFloat h = CGRectGetWidth(frame) / width;
    
    return CGRectMake(x, y, w, h);
}

-(void)setAnimationForScanView:(UIView*)scanView{
    
    UIImage *lineImage = [UIImage imageNamed:@"scanLine"];
//    CGFloat x = CGRectGetMinX(scanView.frame);
//    CGFloat y = CGRectGetMinY(scanView.frame);
    CGFloat w = CGRectGetWidth(scanView.frame);
    CGFloat h = CGRectGetHeight(scanView.frame);
    
    CGRect start = CGRectMake(0, 0, w, 3);
    CGRect end = CGRectMake(0, h - 2, w, 3);
    
    if (!_lineView) {
        _lineView = [[UIImageView alloc]initWithFrame:start];
        _lineView.image = lineImage;
        [scanView addSubview:_lineView];
    }else{
        _lineView.frame = start;
    }
    
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:3.0 animations:^{
        _lineView.frame = end;
    } completion:^(BOOL finished) {
        [tempSelf setAnimationForScanView:_scanView];
    }];
    
    
}

#pragma mark - 添加模糊效果
-(void)setOtherView{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat x = CGRectGetMinX(_scanView.frame);
    CGFloat y = CGRectGetMinY(_scanView.frame);
    CGFloat w = CGRectGetWidth(_scanView.frame);
    CGFloat h = CGRectGetHeight(_scanView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

-(void)creatView:(CGRect)rect{
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor grayColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self addSubview:view];
}

#pragma mark --AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count > 0) {
        AVMetadataObject *metadataObject = metadataObjects.lastObject;
        if ([metadataObject isKindOfClass:[AVMetadataFaceObject class]]) {
            AVMetadataFaceObject* object = (AVMetadataFaceObject*)metadataObject;
            NSLog(@"%ld",(long)object.faceID);
        }else{

            AVMetadataMachineReadableCodeObject* object = (AVMetadataMachineReadableCodeObject*)metadataObject;
            NSLog(@"%@",object.stringValue);
            
            if ([_delegate respondsToSelector:@selector(QRView:scanResult:)]) {
                [_delegate QRView:self scanResult:object.stringValue];
            }
            
            
        }
    }else{
        
    }
    
}

-(void)startScan{
    if (!_session.running) {
        [_session startRunning];
    }
}
-(void)stopScan{
    if (_session.running) {
        [_session stopRunning];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
