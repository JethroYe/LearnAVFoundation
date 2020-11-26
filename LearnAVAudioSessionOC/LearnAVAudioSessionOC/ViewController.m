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

- (void)setUpAudio{
    
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

- (AVCaptureSession *)session
{
    if(!_session) {
        _session = [AVCaptureSession new];
    }
    return _session;
}

@end
