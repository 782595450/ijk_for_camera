//
//  ZHWiFiProtocol.h
//  ZH
//
//  Created by lsq on 2017/4/4.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHDeviceModel.h"
#import <UIKit/UIKit.h>

@interface ZHWiFiProtocol : NSObject

+ (instancetype)sharedInstance;

//云台左方向
- (void)ptzCommandleftstart:(ZHDeviceModel *)deviceModel
                      error:(void (^)(NSError *error))errorBlock
                   complete:(void (^)(BOOL shareFinished))completeBlock;
//云台左停止
- (void)ptzCommandleftstop:(ZHDeviceModel *)deviceModel
                     error:(void (^)(NSError *error))errorBlock
                  complete:(void (^)(BOOL shareFinished))completeBlock;
//云台右方向
- (void)ptzCommandrighttstart:(ZHDeviceModel *)deviceModel
                        error:(void (^)(NSError *error))errorBlock
                     complete:(void (^)(BOOL shareFinished))completeBlock;
//云台右停止
- (void)ptzCommandrightstop:(ZHDeviceModel *)deviceModel
                      error:(void (^)(NSError *error))errorBlock
                   complete:(void (^)(BOOL shareFinished))completeBlock;

//云台上方向
- (void)ptzCommandupstart:(ZHDeviceModel *)deviceModel
                    error:(void (^)(NSError *error))errorBlock
                 complete:(void (^)(BOOL shareFinished))completeBlock;
//云台上停止
- (void)ptzCommandupstop:(ZHDeviceModel *)deviceModel
                   error:(void (^)(NSError *error))errorBlock
                complete:(void (^)(BOOL shareFinished))completeBlock;

//云台下方向
- (void)ptzCommanddownstart:(ZHDeviceModel *)deviceModel
                      error:(void (^)(NSError *error))errorBlock
                   complete:(void (^)(BOOL shareFinished))completeBlock;
//云台下停止
- (void)ptzCommanddownstop:(ZHDeviceModel *)deviceModel
                     error:(void (^)(NSError *error))errorBlock
                  complete:(void (^)(BOOL shareFinished))completeBlock;

//云台左上方向
- (void)ptzCommandleftupstart:(ZHDeviceModel *)deviceModel
                        error:(void (^)(NSError *error))errorBlock
                     complete:(void (^)(BOOL shareFinished))completeBlock;

//云台右上方向
- (void)ptzCommandrighttupstart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock;

//云台左下方向
- (void)ptzCommandleftdownstart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock;

//云台右下方向
- (void)ptzCommandrightdownstart:(ZHDeviceModel *)deviceModel
                           error:(void (^)(NSError *error))errorBlock
                        complete:(void (^)(BOOL shareFinished))completeBlock;

//图象变小
- (void)ptzCommandzoomwidestart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock;
//图象变小停止
- (void)ptzCommandzoomwidestop:(ZHDeviceModel *)deviceModel
                         error:(void (^)(NSError *error))errorBlock
                      complete:(void (^)(BOOL shareFinished))completeBlock;

//图象变大
- (void)ptzCommandzoomtelestart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock;
//图象变大停止
- (void)ptzCommandzoomtelestop:(ZHDeviceModel *)deviceModel
                         error:(void (^)(NSError *error))errorBlock
                      complete:(void (^)(BOOL shareFinished))completeBlock;

//焦距近
- (void)ptzCommandfocusnearstart:(ZHDeviceModel *)deviceModel
                           error:(void (^)(NSError *error))errorBlock
                        complete:(void (^)(BOOL shareFinished))completeBlock;
//焦距近开始停止
- (void)ptzCommandfocusnearstop:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock;


//焦距远
- (void)ptzCommandfocusfarstart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock;
//焦距远开始停止
- (void)ptzCommandfocusfarstop:(ZHDeviceModel *)deviceModel
                         error:(void (^)(NSError *error))errorBlock
                      complete:(void (^)(BOOL shareFinished))completeBlock;


//开光圈
- (void)ptzCommandirisopenstart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock;
//开光圈停止
- (void)ptzCommandirisopenstop:(ZHDeviceModel *)deviceModel
                         error:(void (^)(NSError *error))errorBlock
                      complete:(void (^)(BOOL shareFinished))completeBlock;


//关光圈
- (void)ptzCommandirisclosestart:(ZHDeviceModel *)deviceModel
                           error:(void (^)(NSError *error))errorBlock
                        complete:(void (^)(BOOL shareFinished))completeBlock;
//关光圈停止
- (void)ptzCommandirisclosestop:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock;







@end
