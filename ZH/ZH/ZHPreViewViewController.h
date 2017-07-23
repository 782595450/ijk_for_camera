//
//  ZHPreViewViewController.h
//  ZH
//
//  Created by lsq on 2017/3/19.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUVDisplayGLViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "ZHDeviceModel.h"
#import "UIViewController+UE.h"

@interface ZHPreViewViewController : UIViewController<UIGestureRecognizerDelegate>{
    YUVDisplayGLViewController *yuvGLDisplay;
    FILE *fp;
    NSLock *locas;
    __block UIImageView *imageView;
    UIButton *savePicture;
    BOOL baochun;
    
}
@property(nonatomic, strong)UIPinchGestureRecognizer *pinchGestureRecognizer;

@property (copy, nonatomic) NSString *RecDirPath;
@property (nonatomic, strong)NSString *rtspUrl;
@property (atomic, retain) id<IJKMediaPlayback> player;
@property (nonatomic, strong)ZHDeviceModel *deviceModel;

@end
