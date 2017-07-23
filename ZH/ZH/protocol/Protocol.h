//
//  Protocol.h
//  ZH
//
//  Created by lsq on 2017/4/4.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>


//云台方向控制
typedef enum PtzCommand{
    PtzCommand_LEFT_START = 2,
    PtzCommand_LEFT_STOP = 3,
    PtzCommand_RIGHT_START = 4,
    PtzCommand_RIGHT_STOP = 5,
    PtzCommand_UP_START = 6,
    PtzCommand_UP_STOP = 7,
    PtzCommand_DOWN_START = 8,
    PtzCommand_DOWN_STOP = 9,
    //
    PtzCommand_LEFT_UP_START = 10,
    PtzCommand_LEFT_UP_STOP = 11,
    PtzCommand_RIGHT_UP_START = 12,
    PtzCommand_RIGHT_UP_STOP = 13,
    PtzCommand_LEFT_DOWN_START = 14,
    PtzCommand_LEFT_DOWN_STOP = 15,
    PtzCommand_RIGHT_DOWN_START = 16,
    PtzCommand_RIGHT_DOWN_STOP = 17,
    
}_PtzCommand;

//缩放控制
typedef enum PtzCommand_ZOOM{
    // 图象变小开始
    PtzCommand_ZOOM_WIDE_START = 108,
    // 图象变小停止
    PtzCommand_ZOOM_WIDE_STOP = 109,
    // 图象变大开始
    PtzCommand_ZOOM_TELE_START = 110,
    // 图象变大停止
    PtzCommand_ZOOM_TELE_STOP = 111,
}_PtzCommand_ZOOM;

//调焦距
typedef enum PtzCommand_FOCUS{
    // 焦距近开始
    PtzCommand_FOCUS_NEAR_START = 104,
    // 焦距近停止
    PtzCommand_FOCUS_NEAR_STOP = 105,
    // 焦距远开始
    PtzCommand_FOCUS_FAR_START = 106,
    // 焦距远停止
    PtzCommand_FOCUS_FAR_STOP = 107,
}_PtzCommand_FOCUS;

//调光圈
typedef enum PtzCommand_IRIS{
    // 开光圈开始
    PtzCommand_IRIS_OPEN_START = 100,
    // 开光圈停止
    PtzCommand_IRIS_OPEN_STOP = 101,
    // 关光圈开始
    PtzCommand_IRIS_CLOSE_START = 102,
    // 关光圈停止
    PtzCommand_IRIS_CLOSE_STOP = 103,
}_PtzCommand_IRIS;


//调用云台
#define Call_PTZ @"{\"Header\":{\"Method\":\"CallPtzPt\",\"Action\":\"Requst\",\"Session\":\"24678\"},\"Param\":{\"Channel\":0,\"Slave\":0,\"Cmd\":%d,\"HSpeed\":10,\"VSpeed\":10}}\r\n\r\n"










