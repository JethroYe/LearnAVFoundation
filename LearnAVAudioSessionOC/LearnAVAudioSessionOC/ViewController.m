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

@property (strong , nonatomic) AVCaptureSession *session;

@property (strong , nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong , nonatomic) AVCaptureDeviceInput *audioInput;
@property (strong , nonatomic) AVCaptureMovieFileOutput *movieFileOutPut;


@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewlayer; //预览layer

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置一手分辨率
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        self.session.sessionPreset=AVCaptureSessionPreset640x480;
    }
    
    //1.设置视频输入
    [self setUpVideo];
    
    //2.设置音频输入
    [self setUpAudio];

    //3.文件输出
    [self setUpFileOut];
    
    //4.设置预览layer
    [self setUpPreviewLayer];

}

- (void)setUpVideo {
    //获取设备
    AVCaptureDevice *videoCaptureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    
    //创建视频输入
    NSError *error = nil;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:&error];
    
    //放入session
    if([self.session canAddInput:self.videoInput]){
        [self.session addInput:self.videoInput];
    }
}

- (void)setUpAudio {
    
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSError *error = nil;
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    
    //放入session
    if ([self.session canAddInput:self.audioInput]) {
        [self.session addInput:self.audioInput];
    }
}

- (void)setUpFileOut {
    
    //1. 初始化设备输出对象
    self.movieFileOutPut = [[AVCaptureMovieFileOutput alloc] init];
    
    //2. 设置输出对象的属性
    AVCaptureConnection *captureConnection = [self.movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    
    //3. 视频防抖
    if([captureConnection isVideoStabilizationSupported]){
        captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    }
    
    //4. 预览图层和视频方向保持一致
    captureConnection.videoOrientation = [self.previewlayer connection].videoOrientation;
    
    //5. 输出设备添加到会话中
    if ([self.session canAddOutput:self.movieFileOutPut]) {
        [self.session addOutput:self.movieFileOutPut];
    }
    
}

- (void)setUpPreviewLayer {
    
    self.previewlayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.previewlayer above:0];
}


//MARK: - 获取录像设备
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray *cameras = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

//MARK: - lazy

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewlayer) {
        _previewlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    return _previewlayer;
}

- (AVCaptureSession *)session
{
    if(!_session) {
        _session = [AVCaptureSession new];
    }
    return _session;
}

@end
