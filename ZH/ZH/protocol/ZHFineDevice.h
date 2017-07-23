//
//  ZHFineDevice.h
//  ZH
//
//  Created by lsq on 2017/3/31.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHDeviceModel.h"

@interface ZHFineDevice : NSObject

+ (instancetype)sharedInstance;
-(void)fineDevice:(void (^)(ZHDeviceModel *devicemodel))deviceBlock;

@end
