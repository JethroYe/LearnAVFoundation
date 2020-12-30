//
//  ViewController.m
//  LearnAVAudioSessionOC
//
//  Created by JethroiMac on 2020/11/27.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureSession.h>

@interface ViewController ()


//MARK: View
//@property (strong , nonatomic) UIView *previewView;
//@property (strong , nonatomic) UIView *overLayView;
@property (strong , nonatomic) UIButton *captureBtn;

//MARK: AVFoundation
@property (strong , nonatomic) AVCaptureSession *captureSession;
@property (strong , nonatomic) AVCaptureDevice *captureDevice;
@property (strong , nonatomic) AVCaptureDeviceInput *captureDeviceInput;
@property (strong , nonatomic) AVCaptureStillImageOutput *stillImgOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewlayer; //预览layer



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI
    [self setUpUI];
    
    //setUp session
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    //setUpDevice
    [self setUpDevice];

    //setUpLayer
    [self setUpPreViewLayer];
    
    //Run Session
    [self startSession];
}

- (void)viewWillLayoutSubviews {
    self.previewlayer.frame = self.view.bounds;
}


//MARK: - start And stop

- (void)startSession {
    if (NO == [self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
}

- (void)stopSession {
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}


//MARK: - setUp

- (void)setUpUI {
    [self.view addSubview:self.captureBtn];
}

- (void)setUpDevice {
    NSError *error = nil;
    //创建输入
    self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
    
    //连接输出和输入
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
    }
    
    if ([self.captureSession canAddOutput:self.stillImgOutput]) {
        [self.captureSession addOutput:self.stillImgOutput];
    }
}

- (void)setUpPreViewLayer {
    self.previewlayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewlayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.previewlayer];
}

- (void)onCaptureBtnClick {
    NSLog(@"click btn");
    //获取Connection
    AVCaptureConnection *connection = [self.stillImgOutput connectionWithMediaType:AVMediaTypeVideo];
    //拍照
    [self.stillImgOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }];
}

//MARK: - lazy

- (AVCaptureStillImageOutput *)stillImgOutput {
    if (!_stillImgOutput) {
        _stillImgOutput = [AVCaptureStillImageOutput new];
        _stillImgOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    }
    return _stillImgOutput;
}

- (AVCaptureDevice *)captureDevice {
    if (!_captureDevice) {
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
}

- (UIButton *)captureBtn {
    if (!_captureBtn) {
        _captureBtn = [UIButton new];
        _captureBtn.frame = CGRectMake(100, 100, 150, 100);
        [_captureBtn setTitle:@"_captureBtn" forState:UIControlStateNormal];
        [_captureBtn addTarget:self action:@selector(onCaptureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureBtn;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewlayer) {
        _previewlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    return _previewlayer;
}

- (AVCaptureSession *)captureSession {
    if(!_captureSession) {
        _captureSession = [AVCaptureSession new];
    }
    return _captureSession;
}

@end
