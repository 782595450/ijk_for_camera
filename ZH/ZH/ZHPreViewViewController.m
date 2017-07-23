//
//  ZHPreViewViewController.m
//  ZH
//
//  Created by lsq on 2017/3/19.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "ZHPreViewViewController.h"
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<string.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewController.h"
#import "ZHSettingViewController.h"
#import "ZHWiFiProtocol.h"
#import "Masonry.h"

@interface ZHPreViewViewController (){
    int _counter;
    __block BOOL ssss;
}

@property (nonatomic, strong) FfmpegWrapper *h264dec;


@end

@implementation ZHPreViewViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    [self initUI];
    locas = [[NSLock alloc]init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self startStreaming];
        [self ijkPlay];
    });

}
-(void)ijkPlay{
    // Do any additional setup after loading the view from its nib.
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
//    [options setPlayerOptionIntValue:30  forKey:@"max-fps"];
//    [options setPlayerOptionIntValue:1  forKey:@"framedrop"];
//    [options setPlayerOptionIntValue:0  forKey:@"start-on-prepared"];
//    [options setPlayerOptionIntValue:0  forKey:@"http-detect-range-support"];
//    [options setPlayerOptionIntValue:48  forKey:@"skip_loop_filter"];
//    [options setPlayerOptionIntValue:2000000 forKey:@"analyzeduration"];
//    [options setPlayerOptionIntValue:20  forKey:@"min-frames"];
//    [options setPlayerOptionIntValue:1  forKey:@"start-on-prepared"];
//    [options setCodecOptionIntValue:3 forKey:@"skip_frame"];
    
//    [options setFormatOptionValue:@"8192" forKey:@"probsize"];
//    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
//    [options setFormatOptionIntValue:1 forKey:@"reconnect"];
//    [options setPlayerOptionIntValue:0  forKey:@"videotoolbox"]; //设置是否硬解码
    
//    [options setPlayerOptionIntValue:15 forKey:@"limit_packets"];
    [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];  //  关闭播放器缓冲
//    [options setFormatOptionValue:@"nobuffer" forKey:@"fflags"];
    [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];

    NSURL *url = [NSURL URLWithString:self.rtspUrl];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = CGRectMake(0, 64, self.view.frame.size.width, 240);;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    [self.player prepareToPlay];
    [self.player play];
    
}

-(void)initUI{
    self.title = @"预览";

    UIButton *playBtn = [[UIButton alloc] init];
    [playBtn setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:playBtn];
    playBtn.backgroundColor = UIColorFromRGB(0xffc600);
    playBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@324);
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    

    UIButton *voidBtn = [[UIButton alloc] init];
    [voidBtn setTitle:@"声音" forState:UIControlStateNormal];
    [self.view addSubview:voidBtn];
    voidBtn.backgroundColor = UIColorFromRGB(0xffc600);
    voidBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [voidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [voidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playBtn.mas_right).offset(15);
        make.top.equalTo(@324);
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    

    UIButton *setBtn = [[UIButton alloc] init];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [self.view addSubview:setBtn];
    setBtn.backgroundColor = UIColorFromRGB(0xffc600);
    setBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voidBtn.mas_right).offset(15);
        make.top.equalTo(@324);
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    [setBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *photoBtn = [[UIButton alloc] init];
    [photoBtn setTitle:@"照片" forState:UIControlStateNormal];
    [self.view addSubview:photoBtn];
    photoBtn.backgroundColor = UIColorFromRGB(0xffc600);
    photoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(setBtn.mas_right).offset(15);
        make.top.equalTo(@324);
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];

    UIButton *videoBtn = [[UIButton alloc] init];
    [videoBtn setTitle:@"视频" forState:UIControlStateNormal];
    [self.view addSubview:videoBtn];
    videoBtn.backgroundColor = UIColorFromRGB(0xffc600);
    videoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(photoBtn.mas_right).offset(15);
        make.top.equalTo(@324);
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    
    //变倍+
    UIButton *bainbeiAddBtn = [[UIButton alloc] init];
    [self.view addSubview:bainbeiAddBtn];
    [bainbeiAddBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    bainbeiAddBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    bainbeiAddBtn.layer.borderWidth = 1;

    [bainbeiAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voidBtn.mas_right).offset(50);
        make.top.equalTo(videoBtn.mas_bottom).offset(10);
    }];
//    [bainbeiAddBtn addTarget:self action:@selector(zoomwide) forControlEvents:UIControlEventTouchUpInside];
    //处理按钮点击事件
    [bainbeiAddBtn addTarget:self action:@selector(zoomtele)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [bainbeiAddBtn addTarget:self action:@selector(zoomtelestop)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    
    UILabel *bianbeiLabel = [[UILabel alloc] init];
    [self.view addSubview:bianbeiLabel];
    bianbeiLabel.font = [UIFont systemFontOfSize:14];
    bianbeiLabel.text = @"变倍";
    bianbeiLabel.textAlignment = NSTextAlignmentCenter;
    [bianbeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voidBtn.mas_right).offset(50);
        make.top.equalTo(bainbeiAddBtn.mas_bottom).offset(10);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
    }];
    
    UIButton *bainbeilowBtn = [[UIButton alloc] init];
//    [bainbeilowBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.view addSubview:bainbeilowBtn];
    [bainbeilowBtn setImage:[UIImage imageNamed:@"mins"] forState:UIControlStateNormal];
    bainbeilowBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    bainbeilowBtn.layer.borderWidth = 1;
    [bainbeilowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voidBtn.mas_right).offset(50);
        make.top.equalTo(bianbeiLabel.mas_bottom).offset(10);
    }];
//    [bainbeilowBtn addTarget:self action:@selector(zoomtele) forControlEvents:UIControlEventTouchUpInside];
    //处理按钮点击事件
    [bainbeilowBtn addTarget:self action:@selector(zoomwide)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [bainbeilowBtn addTarget:self action:@selector(zoomwidestop)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    //变焦+
    UIButton *bainjiaoAddBtn = [[UIButton alloc] init];
//    [bainjiaoAddBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.view addSubview:bainjiaoAddBtn];
    [bainjiaoAddBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    bainjiaoAddBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    bainjiaoAddBtn.layer.borderWidth = 1;

//    bainjiaoAddBtn.backgroundColor = UIColorFromRGB(0xffc600);
//    bainjiaoAddBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [bainjiaoAddBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bainjiaoAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bainbeiAddBtn.mas_right).offset(15);
        make.top.equalTo(videoBtn.mas_bottom).offset(10);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
    }];
//    [bainjiaoAddBtn addTarget:self action:@selector(focusnear) forControlEvents:UIControlEventTouchUpInside];
    //处理按钮点击事件
    [bainjiaoAddBtn addTarget:self action:@selector(focusnear)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [bainjiaoAddBtn addTarget:self action:@selector(focusnearstop)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    UILabel *bianjiaoLabel = [[UILabel alloc] init];
    [self.view addSubview:bianjiaoLabel];
    bianjiaoLabel.font = [UIFont systemFontOfSize:14];
    bianjiaoLabel.text = @"变焦";
    bianjiaoLabel.textAlignment = NSTextAlignmentCenter;
    [bianjiaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bainbeiAddBtn.mas_right).offset(15);
        make.top.equalTo(bainbeiAddBtn.mas_bottom).offset(10);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
    }];
    
    UIButton *bainjiaolowBtn = [[UIButton alloc] init];
//    [bainjiaolowBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.view addSubview:bainjiaolowBtn];
    [bainjiaolowBtn setImage:[UIImage imageNamed:@"mins"] forState:UIControlStateNormal];
    bainjiaolowBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    bainjiaolowBtn.layer.borderWidth = 1;
//    bainjiaolowBtn.backgroundColor = UIColorFromRGB(0xffc600);
//    bainjiaolowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [bainjiaolowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bainjiaolowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bainbeiAddBtn.mas_right).offset(15);
        make.top.equalTo(bianbeiLabel.mas_bottom).offset(10);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
    }];
//    [bainjiaolowBtn addTarget:self action:@selector(focusfar) forControlEvents:UIControlEventTouchUpInside];
    //处理按钮点击事件
    [bainjiaolowBtn addTarget:self action:@selector(focusfar)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [bainjiaolowBtn addTarget:self action:@selector(focusfarstop)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];


    
    //光圈+
    UIButton *guanquanAddBtn = [[UIButton alloc] init];
//    [guanquanAddBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.view addSubview:guanquanAddBtn];
//    guanquanAddBtn.backgroundColor = UIColorFromRGB(0xffc600);
//    guanquanAddBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [guanquanAddBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    guanquanAddBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    guanquanAddBtn.layer.borderWidth = 1;

    [guanquanAddBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [guanquanAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bainjiaoAddBtn.mas_right).offset(15);
        make.top.equalTo(videoBtn.mas_bottom).offset(10);
//        make.height.equalTo(@40);
//        make.width.equalTo(@40);
    }];
//    [guanquanAddBtn addTarget:self action:@selector(diriopen) forControlEvents:UIControlEventTouchUpInside];
    //处理按钮点击事件
    [guanquanAddBtn addTarget:self action:@selector(diriopen)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [guanquanAddBtn addTarget:self action:@selector(diriopenstop)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    
    UILabel *guanquanLabel = [[UILabel alloc] init];
    [self.view addSubview:guanquanLabel];
    guanquanLabel.font = [UIFont systemFontOfSize:14];
    guanquanLabel.text = @"光圈";
    guanquanLabel.textAlignment = NSTextAlignmentCenter;
    [guanquanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bainjiaoAddBtn.mas_right).offset(15);
        make.top.equalTo(bainbeiAddBtn.mas_bottom).offset(10);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
    }];
    
    UIButton *guanquanlowBtn = [[UIButton alloc] init];
//    [guanquanlowBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.view addSubview:guanquanlowBtn];
    [guanquanlowBtn setImage:[UIImage imageNamed:@"mins"] forState:UIControlStateNormal];
    guanquanlowBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    guanquanlowBtn.layer.borderWidth = 1;

//    guanquanlowBtn.backgroundColor = UIColorFromRGB(0xffc600);
//    guanquanlowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [guanquanlowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [guanquanlowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bainjiaoAddBtn.mas_right).offset(15);
        make.top.equalTo(bianbeiLabel.mas_bottom).offset(10);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
    }];
//    [guanquanlowBtn addTarget:self action:@selector(diriclose) forControlEvents:UIControlEventTouchUpInside];
    //处理按钮点击事件
    [guanquanlowBtn addTarget:self action:@selector(diriclose)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [guanquanlowBtn addTarget:self action:@selector(diriclosestop)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    
    //上
    UIButton *upBtn = [[UIButton alloc] init];
//    [upBtn setTitle:@"上" forState:UIControlStateNormal];
    [upBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [self.view addSubview:upBtn];
    upBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    upBtn.layer.borderWidth = 1;
//    upBtn.backgroundColor = UIColorFromRGB(0xffc600);
    upBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playBtn.mas_right).offset(25);
        make.top.equalTo(playBtn.mas_bottom).offset(10);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
    }];
//    [upBtn addTarget:self action:@selector(up) forControlEvents:UIControlEventTouchUpInside];
    //处理按钮点击事件
    [upBtn addTarget:self action:@selector(up)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [upBtn addTarget:self action:@selector(upstop)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    //下
    UIButton *downBtn = [[UIButton alloc] init];
    [downBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [self.view addSubview:downBtn];
    downBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    downBtn.layer.borderWidth = 1;
//    downBtn.backgroundColor = UIColorFromRGB(0xffc600);
    downBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playBtn.mas_right).offset(25);
        make.top.equalTo(upBtn.mas_bottom).offset(40);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
    }];
//    [downBtn addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
    //处理按钮点击事件
    [downBtn addTarget:self action:@selector(down)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [downBtn addTarget:self action:@selector(downStop)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    //左
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    leftBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    leftBtn.layer.borderWidth = 1;
//    leftBtn.backgroundColor = UIColorFromRGB(0xffc600);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(upBtn.mas_left).offset(-10);
        make.top.equalTo(upBtn.mas_bottom).offset(10);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
    }];
//    [leftBtn addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchUpInside];
    //处理按钮点击事件
    [leftBtn addTarget:self action:@selector(left)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [leftBtn addTarget:self action:@selector(leftStop)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    //右
    UIButton *rigtBtn = [[UIButton alloc] init];
    [rigtBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self.view addSubview:rigtBtn];
    rigtBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    rigtBtn.layer.borderWidth = 1;
//    rigtBtn.backgroundColor = UIColorFromRGB(0xffc600);
    rigtBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rigtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rigtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upBtn.mas_right).offset(10);
        make.top.equalTo(upBtn.mas_bottom).offset(10);
//        make.height.equalTo(@30);
//        make.width.equalTo(@40);
    }];
//    [rigtBtn addTarget:self action:@selector(rigth) forControlEvents:UIControlEventTouchUpInside];
    //处理按钮点击事件
    [rigtBtn addTarget:self action:@selector(right)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [rigtBtn addTarget:self action:@selector(rightStop)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

}

-(void)setting{
    ZHSettingViewController *setVC = [[ZHSettingViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)startStreaming{
    
    yuvGLDisplay=[[YUVDisplayGLViewController alloc]init];
    yuvGLDisplay.view.frame = CGRectMake(0, 64, self.view.frame.size.width, 240);
    yuvGLDisplay.view.superview.backgroundColor = [UIColor blackColor];
    yuvGLDisplay.xScal=10.0;
    yuvGLDisplay.yScal=10.0;
    [self.view addSubview:yuvGLDisplay.view];

    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)];
    [yuvGLDisplay.view addGestureRecognizer:self.pinchGestureRecognizer];
    
    int status=1;
    self.h264dec=[[FfmpegWrapper alloc]init];
    status = [self.h264dec openUrl:self.rtspUrl];
    NSLog(@"status=%d",status);
    ssss=NO;
    if (status==0){
        [self.h264dec startDecodingWithCallbackBlock:^(AVFrameData *frame,AVFrame *avFrame) {
            [yuvGLDisplay loadFrameData:frame];
            if (!ssss) {
                ssss=!ssss;
            }
            if (_counter%60==0){
                //                NSLog(@"got %d frames", _counter);
            }
            _counter++;
            
        } waitForConsumer:YES completionCallback:^{
            NSLog(@"decode complete.");
        }];
        
    }else{
        
    }
    
    baochun=NO;
    savePicture=[UIButton buttonWithType:UIButtonTypeCustom];
}

#pragma mark - 方向
-(void)left{
//    [self showAlertIndictorWithMessage:nil withDelay:15];
    __weak __typeof(self) weakSelf = self;

    [[ZHWiFiProtocol sharedInstance] ptzCommandleftstart:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertIndictor];
            if (shareFinished) {
                [weakSelf showAlertIndictorWithMessage:@"设置成功" withDelay:0.5];
            }else{
                [weakSelf showAlertIndictorWithMessage:@"设置失败" withDelay:0.5];
            }
        });
    }];
}
-(void)leftStop{
    [[ZHWiFiProtocol sharedInstance] ptzCommandleftstop:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        
    }];
}
-(void)right{
//    [self showAlertIndictorWithMessage:nil withDelay:15];
    __weak __typeof(self) weakSelf = self;

    [[ZHWiFiProtocol sharedInstance] ptzCommandrighttstart:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertIndictor];
            if (shareFinished) {
                [weakSelf showAlertIndictorWithMessage:@"设置成功" withDelay:0.5];
            }else{
                [weakSelf showAlertIndictorWithMessage:@"设置失败" withDelay:0.5];
            }
        });
    }];
}
-(void)rightStop{
    [[ZHWiFiProtocol sharedInstance] ptzCommandrightstop:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        
    }];
}
-(void)up{
//    [self showAlertIndictorWithMessage:nil withDelay:15];
    __weak __typeof(self) weakSelf = self;

    [[ZHWiFiProtocol sharedInstance] ptzCommandupstart:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertIndictor];
            if (shareFinished) {
                [weakSelf showAlertIndictorWithMessage:@"设置成功" withDelay:0.5];
            }else{
                [weakSelf showAlertIndictorWithMessage:@"设置失败" withDelay:0.5];
            }
        });
    }];
}
-(void)upstop{
    [[ZHWiFiProtocol sharedInstance] ptzCommandupstop:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        
    }];
}
-(void)down{
//    [self showAlertIndictorWithMessage:nil withDelay:15];
    __weak __typeof(self) weakSelf = self;

    [[ZHWiFiProtocol sharedInstance] ptzCommanddownstart:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertIndictor];
            if (shareFinished) {
                [weakSelf showAlertIndictorWithMessage:@"设置成功" withDelay:0.5];
            }else{
                [weakSelf showAlertIndictorWithMessage:@"设置失败" withDelay:0.5];
            }
        });
    }];
}
-(void)downStop{
    [[ZHWiFiProtocol sharedInstance] ptzCommanddownstop:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        
    }];
}
#pragma mark - 图象缩放
//图象变小
-(void)zoomwide{
//    [self showAlertIndictorWithMessage:nil withDelay:15];
    __weak __typeof(self) weakSelf = self;

    [[ZHWiFiProtocol sharedInstance] ptzCommandzoomwidestart:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertIndictor];
//            if (shareFinished) {
//                [weakSelf showAlertIndictorWithMessage:@"设置成功" withDelay:0.5];
//            }else{
//                [weakSelf showAlertIndictorWithMessage:@"设置失败" withDelay:0.5];
//            }
        });
    }];
}
-(void)zoomwidestop{
    [[ZHWiFiProtocol sharedInstance] ptzCommandzoomwidestop:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        
    }];
}
//图像变大
-(void)zoomtele{
//    [self showAlertIndictorWithMessage:nil withDelay:15];
    __weak __typeof(self) weakSelf = self;

    [[ZHWiFiProtocol sharedInstance] ptzCommandzoomtelestart:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertIndictor];
//            if (shareFinished) {
//                [weakSelf showAlertIndictorWithMessage:@"设置成功" withDelay:0.5];
//            }else{
//                [weakSelf showAlertIndictorWithMessage:@"设置失败" withDelay:0.5];
//            }
        });
    }];
}
-(void)zoomtelestop{
    [[ZHWiFiProtocol sharedInstance] ptzCommandzoomtelestop:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        
    }];
}
#pragma mark - 焦距
-(void)focusnear{
//    [self showAlertIndictorWithMessage:nil withDelay:15];
    __weak __typeof(self) weakSelf = self;

    [[ZHWiFiProtocol sharedInstance] ptzCommandfocusnearstart:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertIndictor];
//            if (shareFinished) {
//                [weakSelf showAlertIndictorWithMessage:@"设置成功" withDelay:0.5];
//            }else{
//                [weakSelf showAlertIndictorWithMessage:@"设置失败" withDelay:0.5];
//            }
        });
    }];
}
-(void)focusnearstop{
    [[ZHWiFiProtocol sharedInstance] ptzCommandfocusnearstop:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        
    }];
}
-(void)focusfar{
//    [self showAlertIndictorWithMessage:nil withDelay:15];
    __weak __typeof(self) weakSelf = self;

    [[ZHWiFiProtocol sharedInstance] ptzCommandfocusfarstart:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertIndictor];
//            if (shareFinished) {
//                [weakSelf showAlertIndictorWithMessage:@"设置成功" withDelay:0.5];
//            }else{
//                [weakSelf showAlertIndictorWithMessage:@"设置失败" withDelay:0.5];
//            }
        });
    }];
}
-(void)focusfarstop{
    [[ZHWiFiProtocol sharedInstance] ptzCommandfocusnearstop:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        
    }];
}
#pragma mark - 光圈
-(void)diriopen{
//    [self showAlertIndictorWithMessage:nil withDelay:15];
    __weak __typeof(self) weakSelf = self;

    [[ZHWiFiProtocol sharedInstance] ptzCommandirisopenstart:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertIndictor];
//            if (shareFinished) {
//                [weakSelf showAlertIndictorWithMessage:@"设置成功" withDelay:0.5];
//            }else{
//                [weakSelf showAlertIndictorWithMessage:@"设置失败" withDelay:0.5];
//            }
        });
    }];
}
-(void)diriopenstop{
    [[ZHWiFiProtocol sharedInstance] ptzCommandirisopenstop:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        
    }];
}
-(void)diriclose{
//    [self showAlertIndictorWithMessage:nil withDelay:15];
    __weak __typeof(self) weakSelf = self;

    [[ZHWiFiProtocol sharedInstance] ptzCommandirisclosestart:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertIndictor];
//            if (shareFinished) {
//                [weakSelf showAlertIndictorWithMessage:@"设置成功" withDelay:0.5];
//            }else{
//                [weakSelf showAlertIndictorWithMessage:@"设置失败" withDelay:0.5];
//            }
        });
    }];
}
-(void)diriclosestop{
    [[ZHWiFiProtocol sharedInstance] ptzCommandirisclosestop:self.deviceModel error:^(NSError *error) {
        
    } complete:^(BOOL shareFinished) {
        
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player shutdown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.player prepareToPlay];

}


@end
