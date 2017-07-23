//
//  UINavigationController+UE.m
//  DeTuZZN
//
//  Created by Seth on 16/9/6.
//  Copyright © 2016年 DETU. All rights reserved.
//

#import "UIViewController+UE.h"
#import <objc/runtime.h>

const char * MBProgressHUDKey = "MBProgressHUDKey";

@implementation UIViewController (UE)

- (MBProgressHUD *)getAssociatedObject {
    MBProgressHUD * hub = objc_getAssociatedObject(self, MBProgressHUDKey);
    return hub;
}

- (void )setAssociatedObject:(MBProgressHUD *)hub {
    [self willChangeValueForKey:@"MBProgressHUDKey"]; // KVO
    objc_setAssociatedObject(self, MBProgressHUDKey, hub, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"MBProgressHUDKey"];  // KVO
}

- (void)showAlertIndictorWithMessage:(NSString *)message withDelay:(NSTimeInterval)time {
    
    MBProgressHUD * hub = [self getAssociatedObject];
    
    if (!hub) {
        hub = [[MBProgressHUD alloc] initWithView:self.view];
        [self setAssociatedObject:hub];
    }
    hub.detailsLabelText = message;
    hub.detailsLabelFont = [UIFont systemFontOfSize:14];
    hub.mode = message.length>0?MBProgressHUDModeCustomView:MBProgressHUDModeIndeterminate;
    hub.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hub];
    [hub show:YES];
    if (time > 0) {
        [hub hide:YES afterDelay:time];
    }
}

- (void)hideAlertIndictor {
    MBProgressHUD * hub = [self getAssociatedObject];
    if (!hub) return;
    [hub hide:YES afterDelay:.1];
}

- (void)dtPopToRootViewControllerAnimated
{
    CATransition *animation = [CATransition animation];
    animation.type = @"fade";
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.type = kCATransitionPush;
    animation.type = @"pageCurl"  ;//另一种设置动画效果方法
    animation.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:animation forKey:@"viewController"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
