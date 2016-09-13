//
//  StartLiveView.m
//  ZHIBO
//
//  Created by qianfeng on 16/9/9.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "StartLiveView.h"
#import "LFLiveSession.h"
#import "UIControl+Add.h"
#import "UIView+Add.h"

@interface StartLiveView()<LFLiveSessionDelegate>

@property (nonatomic, strong)LFLiveSession *session;
@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)UIButton *closeButton;
@property (nonatomic,strong)UIButton *cameraButton;
@property (nonatomic,strong)UIButton *beautyButton;
@property (nonatomic,strong)UIButton *startLiveButton;

@end

static int padding = 30;
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width

@implementation StartLiveView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //加载视频录制
        [self requestAccessForVideo];
        //加载音频录制
        [self requestAccessForAudio];
        //创建界面容器
        [self addSubview:self.containerView];
        
        //添加按钮
        [self.containerView addSubview:self.closeButton];
        [self.containerView addSubview:self.cameraButton];
        [self.containerView addSubview:self.beautyButton];
        [self.containerView addSubview:self.startLiveButton];
    }
    return self;
}
#pragma mark ---- <创建会话>
- (LFLiveSession*)session{
    if(!_session){
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        _session.running = YES;
        _session.preView = self;
    }
    return _session;
}
#pragma mark ---- <开始录制>
//调用LF的API开始录制
- (UIButton*)startLiveButton{
    if(!_startLiveButton){
        
        _startLiveButton = [UIButton new];
        
        //位置
        _startLiveButton.frame = CGRectMake((XJScreenW - 200) * 0.5, XJScreenH - 100, 200, 40);
        
        _startLiveButton.layer.cornerRadius = _startLiveButton.frame.size.height * 0.5;
        [_startLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startLiveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
        [_startLiveButton setBackgroundColor:[UIColor grayColor]];
        _startLiveButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [_startLiveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            _self.startLiveButton.selected = !_self.startLiveButton.selected;
            if(_self.startLiveButton.selected){
                [_self.startLiveButton setTitle:@"结束直播" forState:UIControlStateNormal];
                LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
                stream.url = @"rtmp://daniulive.com:1935/live/stream238";
                [_self.session startLive:stream];
            }else{
                [_self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
                [_self.session stopLive];
            }
        }];
    }
    return _startLiveButton;
}

#pragma mark ---- <美颜功能>
- (UIButton*)beautyButton{
    if(!_beautyButton){
        _beautyButton = [UIButton new];
        
        //位置
        _beautyButton.frame = CGRectMake(padding, padding, padding, padding);
        
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateSelected];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateNormal];
        _beautyButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [_beautyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            _self.session.beautyFace = !_self.session.beautyFace;
            _self.beautyButton.selected = !_self.session.beautyFace;
        }];
    }
    return _beautyButton;
}
#pragma mark ---- <切换摄像头>
- (UIButton *)cameraButton{
    if (!_cameraButton) {
        _cameraButton = [UIButton new];
        
        //位置
        _cameraButton.frame = CGRectMake(XJScreenW - padding * 4, padding, padding, padding);
        
        [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        _cameraButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [_cameraButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            AVCaptureDevicePosition devicePositon = _self.session.captureDevicePosition;
            _self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
        }];
    }
    return _cameraButton;
}
#pragma mark ---- <关闭界面>
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton new];
        _closeButton.frame = CGRectMake(XJScreenW - padding * 2, padding, padding, padding);
        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        _closeButton.exclusiveTouch = YES;
        __weak typeof (self) weakSelf = self;
        [_closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            [weakSelf.viewController dismissViewControllerAnimated:true completion:nil];
        }];
    }
    return _closeButton;
}

#pragma mark ---- <界面容器>
- (UIView *)containerView{
    /*new和alloc/init在功能上几乎是一致的，分配内存并完成初始化。
     
     差别在于，采用new的方式只能采用默认的init方法完成初始化，
     
     采用alloc的方式可以用其他定制的初始化方法。*/
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.frame = self.bounds;
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _containerView;
}
#pragma mark ---- <加载音频录制>
- (void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    //
                }
            }];
            break;
        }
        case AVAuthorizationStatusDenied:
            break;
        case AVAuthorizationStatusRestricted:
            break;
        case AVAuthorizationStatusAuthorized:
            break;
        default:
            break;
    }
}

#pragma mark ---- <加载视频录制>
- (void)requestAccessForVideo{
    #pragma clang diagnostic push
    __weak typeof (self) weakSelf = self;
    #pragma clang diagnostic pop
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusDenied:{
            //许可对话没有出现,发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.session setRunning:YES];
                    });
                }
            }];
            
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            //已经开启授权,可继续
            [weakSelf.session setRunning:YES];
        }
        case AVAuthorizationStatusRestricted:{
            //用户明确地拒绝授权,或者相机设备无法使用
            break;
        }
        case AVAuthorizationStatusNotDetermined:
            break;
        default:
            break;
    }
}
#pragma mark ---- <LFStreamingSessionDelegate>
//直播状态改变
- (void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    
}
//错误信息返回
- (void)liveSession:(LFLiveSession *)session debugInfo:(LFLiveDebug *)debugInfo{
    
}
- (void)liveSession:(LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
}

@end
