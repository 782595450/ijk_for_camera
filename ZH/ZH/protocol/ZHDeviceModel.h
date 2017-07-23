//
//  ZHDeviceModel.h
//  ZH
//
//  Created by lsq on 2017/4/4.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHDeviceModel : NSObject

@property (copy, nonatomic) NSString *IP;
@property (copy, nonatomic) NSString *Port;
@property (copy, nonatomic) NSString *RtspPort;
@property (copy, nonatomic) NSString *Type;

@end
