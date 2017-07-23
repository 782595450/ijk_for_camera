//
//  ZHWiFiProtocol.m
//  ZH
//
//  Created by lsq on 2017/4/4.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "ZHWiFiProtocol.h"
#import "Protocol.h"

@interface ZHWiFiProtocol ()
@property (nonatomic, strong)NSURLSessionDataTask *protocolTask;
@end

@implementation ZHWiFiProtocol

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id wifiProtocol = nil;
    dispatch_once(&onceToken, ^{
        wifiProtocol = [[[self class] alloc] init];
    });
    return wifiProtocol;
}

-(NSURLSessionDataTask *)protocolTask{
    if (!_protocolTask) {
        _protocolTask = [[NSURLSessionDataTask alloc] init];
    }
    return _protocolTask;
}
-(BOOL)checkdata:(NSData *)data witherror:(NSError *)error{
    
    if (error == nil && data.length > 0 && data != nil) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark -正常上下左右控制
//云台左方向
- (void)ptzCommandleftstart:(ZHDeviceModel *)deviceModel
                 error:(void (^)(NSError *error))errorBlock
              complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];

    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_LEFT_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandleftstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];

}


//云台左停止
- (void)ptzCommandleftstop:(ZHDeviceModel *)deviceModel
                 error:(void (^)(NSError *error))errorBlock
              complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_LEFT_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }

        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

//云台右方向
- (void)ptzCommandrighttstart:(ZHDeviceModel *)deviceModel
                      error:(void (^)(NSError *error))errorBlock
                   complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_RIGHT_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }

        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
//            [self ptzCommandrightstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//云台右停止
- (void)ptzCommandrightstop:(ZHDeviceModel *)deviceModel
                     error:(void (^)(NSError *error))errorBlock
                  complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_RIGHT_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }

        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

//云台上方向
- (void)ptzCommandupstart:(ZHDeviceModel *)deviceModel
                        error:(void (^)(NSError *error))errorBlock
                     complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_UP_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandupstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//云台上停止
- (void)ptzCommandupstop:(ZHDeviceModel *)deviceModel
                      error:(void (^)(NSError *error))errorBlock
                   complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_UP_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

//云台下方向
- (void)ptzCommanddownstart:(ZHDeviceModel *)deviceModel
                    error:(void (^)(NSError *error))errorBlock
                 complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_DOWN_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
//            [self ptzCommanddownstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//云台下停止
- (void)ptzCommanddownstop:(ZHDeviceModel *)deviceModel
                   error:(void (^)(NSError *error))errorBlock
                complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_DOWN_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

#pragma mark -刁钻的角度
//云台左上方向
- (void)ptzCommandleftupstart:(ZHDeviceModel *)deviceModel
                      error:(void (^)(NSError *error))errorBlock
                   complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_LEFT_UP_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandleftupstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//云台左上停止
- (void)ptzCommandleftupstop:(ZHDeviceModel *)deviceModel
                     error:(void (^)(NSError *error))errorBlock
                  complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_LEFT_UP_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

//云台右上方向
- (void)ptzCommandrighttupstart:(ZHDeviceModel *)deviceModel
                        error:(void (^)(NSError *error))errorBlock
                     complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_RIGHT_UP_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandrigthupstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//云台右上停止
- (void)ptzCommandrigthupstop:(ZHDeviceModel *)deviceModel
                       error:(void (^)(NSError *error))errorBlock
                    complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_RIGHT_UP_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

//云台左下方向
- (void)ptzCommandleftdownstart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_LEFT_DOWN_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandleftdownstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//云台左下停止
- (void)ptzCommandleftdownstop:(ZHDeviceModel *)deviceModel
                        error:(void (^)(NSError *error))errorBlock
                     complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_LEFT_DOWN_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

//云台右下方向
- (void)ptzCommandrightdownstart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_RIGHT_DOWN_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandrightdownstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//云台右下停止
- (void)ptzCommandrightdownstop:(ZHDeviceModel *)deviceModel
                         error:(void (^)(NSError *error))errorBlock
                      complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_RIGHT_DOWN_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

#define mark - 图象缩放
//图象变小开始
- (void)ptzCommandzoomwidestart:(ZHDeviceModel *)deviceModel
                           error:(void (^)(NSError *error))errorBlock
                        complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_ZOOM_WIDE_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandzoomwidestop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//图象变小停止
- (void)ptzCommandzoomwidestop:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_ZOOM_WIDE_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

//图象变大开始
- (void)ptzCommandzoomtelestart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_ZOOM_TELE_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandzoomtelestop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//图象变大停止
- (void)ptzCommandzoomtelestop:(ZHDeviceModel *)deviceModel
                         error:(void (^)(NSError *error))errorBlock
                      complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_ZOOM_TELE_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

#pragma mark - 调焦距
//焦距近开始
- (void)ptzCommandfocusnearstart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_FOCUS_NEAR_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandfocusnearstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//焦距近开始停止
- (void)ptzCommandfocusnearstop:(ZHDeviceModel *)deviceModel
                         error:(void (^)(NSError *error))errorBlock
                      complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_FOCUS_NEAR_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

//焦距远开始
- (void)ptzCommandfocusfarstart:(ZHDeviceModel *)deviceModel
                           error:(void (^)(NSError *error))errorBlock
                        complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_FOCUS_FAR_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandfocusfarstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//焦距远开始停止
- (void)ptzCommandfocusfarstop:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_FOCUS_FAR_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

#pragma mark - 调光圈
//开光圈开始
- (void)ptzCommandirisopenstart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_IRIS_OPEN_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandirisopenstop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//开光圈停止
- (void)ptzCommandirisopenstop:(ZHDeviceModel *)deviceModel
                         error:(void (^)(NSError *error))errorBlock
                      complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_IRIS_OPEN_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

//关光圈开始
- (void)ptzCommandirisclosestart:(ZHDeviceModel *)deviceModel
                          error:(void (^)(NSError *error))errorBlock
                       complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_IRIS_CLOSE_START];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkdata:data witherror:error]) {
            if (errorBlock) {
                errorBlock(error);
            }
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }

//            [self ptzCommandirisclosestop:deviceModel error:errorBlock complete:completeBlock];
        }
    }];
    [self.protocolTask resume];
    
}


//关光圈停止
- (void)ptzCommandirisclosestop:(ZHDeviceModel *)deviceModel
                         error:(void (^)(NSError *error))errorBlock
                      complete:(void (^)(BOOL shareFinished))completeBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/Login.cgi",deviceModel.IP];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString * postString = [NSString stringWithFormat:Call_PTZ,PtzCommand_IRIS_CLOSE_STOP];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:url]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.protocolTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (errorBlock) {
            errorBlock(error);
        }
        if ([self checkdata:data witherror:error]) {
            if (completeBlock) {
                completeBlock(NO);
            }
            
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
    [self.protocolTask resume];
    
}

@end



