//
//  PlayerViewController.m
//  ZHIBO
//
//  Created by qianfeng on 16/9/8.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "PlayerViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "UIImageView+WebCache.h"
#import "DMHeartFlyView.h"

#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width
@interface PlayerViewController ()

@property (nonatomic, strong)id<IJKMediaPlayback>player;
@property (nonatomic, strong)NSURL *url;
@property (nonatomic, strong)UIView *playerView;
@property (nonatomic, strong)UIImageView *dimIamge;
@property (nonatomic, assign)int number;
@property (nonatomic, assign)int heartSize;
@property (nonatomic, strong) NSArray *fireworksArray;
@property (nonatomic, weak) CALayer *fireworksL;

@end

@implementation PlayerViewController

- (void)viewWillAppear:(BOOL)animated{
    if (![self.player isPlaying]) {
        //准备播放
        [self.player prepareToPlay];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //播放视频
    [self goPlaying];
    
    //开启通知
    [self installMovieNotificationObservers];
    
    //设置加载视图
    [self setupLoadingView];
    
    //创建按钮
    [self setupBtn];
}
#pragma mark ---- <创建按钮>
- (void)setupBtn{
    //返回
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 64 / 2 - 8, 33, 33);
    [backBtn setImage:[UIImage imageNamed:@"NavBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    backBtn.layer.shadowOffset = CGSizeMake(0, 0);
    backBtn.layer.shadowOpacity = 0.5;
    backBtn.layer.shadowRadius = 1;
    [self.view addSubview:backBtn];
    
    // 暂停
    UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(XJScreenW - 33 - 10, 64 / 2 - 8, 33, 33);
    
    if (self.number == 0) {
        [playBtn setImage:[UIImage imageNamed:@"play"] forState:(UIControlStateNormal)];
        [playBtn setImage:[UIImage imageNamed:@"开始"] forState:(UIControlStateSelected)];
    }else{
        [playBtn setImage:[UIImage imageNamed:@"开始"] forState:(UIControlStateNormal)];
        [playBtn setImage:[UIImage imageNamed:@"play"] forState:(UIControlStateSelected)];
    }
    
    [playBtn addTarget:self action:@selector(playAction:) forControlEvents:(UIControlEventTouchUpInside)];
    playBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    playBtn.layer.shadowOffset = CGSizeMake(0, 0);
    playBtn.layer.shadowOpacity = 0.5;
    playBtn.layer.shadowRadius = 1;
    [self.view addSubview:playBtn];

    // 点赞
    UIButton * heartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    heartBtn.frame = CGRectMake(36, XJScreenH - 64 - 60, 36, 36);
    [heartBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    [heartBtn addTarget:self action:@selector(showTheLove:) forControlEvents:UIControlEventTouchUpInside];
    heartBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    heartBtn.layer.shadowOffset = CGSizeMake(0, 0);
    heartBtn.layer.shadowOpacity = 0.5;
    heartBtn.layer.shadowRadius = 1;
    heartBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:heartBtn];
    
    //礼物
    UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    giftBtn.frame = CGRectMake(XJScreenW - 50, XJScreenH - 64 - 60, 36, 36);
    [giftBtn setImage:[UIImage imageNamed:@"2.0_sixin_lt_lw_@2x"] forState:UIControlStateNormal];
    [giftBtn addTarget:self action:@selector(showMyPorsche918) forControlEvents:UIControlEventTouchUpInside];
    giftBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    giftBtn.layer.shadowOffset = CGSizeMake(0, 0);
    giftBtn.layer.shadowOpacity = 0.5;
    giftBtn.layer.shadowRadius = 1;
    [self.view addSubview:giftBtn];
    
}
// 返回
- (void)goBack
{
    // 停播
    
    
    [self.navigationController popViewControllerAnimated:true];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player shutdown];
}
//暂停开始
- (void)playAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (![self.player isPlaying]) {
        // 播放
        [self.player play];
    }else{
        // 暂停
        [self.player pause];
    }

}
//点赞
- (void)showTheLove:(UIButton *)btn{
    _heartSize = 36;
    
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(_heartSize + _heartSize/2.0, self.view.bounds.size.height - _heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.view];
    
    // button点击动画
    CAKeyframeAnimation *btnAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    btnAnimation.values = @[@(1.0),@(0.7),@(0.5),@(0.3),@(0.5),@(0.7),@(1.0), @(1.2), @(1.4), @(1.2), @(1.0)];
    btnAnimation.keyTimes = @[@(0.0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    btnAnimation.calculationMode = kCAAnimationLinear;
    btnAnimation.duration = 0.3;
    [btn.layer addAnimation:btnAnimation forKey:@"SHOW"];
}
//送礼物
- (void)showMyPorsche918{
    CGFloat durTime = 3.0;
    
    UIImageView *porsche918 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"porsche"]];
    
    //设置汽车初始位置
    porsche918.frame = CGRectMake(0, 0, 0, 0);
    [self.view addSubview:porsche918];
    
    //给汽车添加动画
    [UIView animateWithDuration:durTime animations:^{
        
        porsche918.frame = CGRectMake(XJScreenW * 0.5 - 100, XJScreenH * 0.5 - 100 * 0.5, 240, 120);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
        [UIView animateWithDuration:0.5 animations:^{
            porsche918.alpha = 0;
        } completion:^(BOOL finished) {
            [porsche918 removeFromSuperview];
        }];
    });
    
    
    
    //烟花
    
    CALayer *fireworksL = [CALayer layer];
    fireworksL.frame = CGRectMake((XJScreenW - 250) * 0.5, 100, 250, 50);
    fireworksL.contents = (id)[UIImage imageNamed:@"gift_fireworks_0"].CGImage;
    [self.view.layer addSublayer:fireworksL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            //没找到设置透明度的方法，有创意可以自己写
            //            fireworksL.alpha = 0;
        } completion:^(BOOL finished) {
            [fireworksL removeFromSuperlayer];
        }];
    });
    _fireworksL = fireworksL;
    
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (int i = 1; i < 3; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gift_fireworks_%d",i]];
        [tempArray addObject:image];
    }
    _fireworksArray = tempArray;
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

static int _fishIndex = 0;

- (void)update {
    
    _fishIndex++;
    
    if (_fishIndex > 1) {
        _fishIndex = 0;
    }
    UIImage *image = self.fireworksArray[_fishIndex];
    _fireworksL.contents = (id)image.CGImage;
}


#pragma mark ---- <设置加载视图>
- (void)setupLoadingView{
    self.dimIamge = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [_dimIamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@", _imageUrl]] placeholderImage:[UIImage imageNamed:@"default_room"]];
    //视觉特效
    //高斯模糊 中亮UIBlurEffectStyleExtraLight,UIBlurEffectStyleLight,UIBlurEffectStyleDark
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = _dimIamge.bounds;
    [_dimIamge addSubview:visualEffectView];
    [self.view addSubview:_dimIamge];
}

#pragma mark ---- <播放视频>
- (void)goPlaying{
    //获取url
    self.url = [NSURL URLWithString:_liveUrl];
    _player = [[IJKFFMoviePlayerController alloc]initWithContentURL:self.url withOptions:nil];
    
    UIView *playerView = [self.player view];
    UIView *displayView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.playerView = displayView;
    [self.view addSubview:self.playerView];
    
    //自动调节自己的宽度和高度
    playerView.frame = self.playerView.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.playerView insertSubview:playerView atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Install Notification
- (void)installMovieNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackFinish:) name:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaIsPreparedToPlayDidChange:) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}
- (void)removeMovieNotificationObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

#pragma Selector func
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
    _dimIamge.hidden = YES;
    
    switch (_player.playbackState) {
            
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}


@end
