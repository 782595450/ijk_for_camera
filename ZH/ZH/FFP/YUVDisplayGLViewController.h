//
//  YUVDisplayGLViewController.h
//  rtsp_player
//
//  Created by J.C. Li on 11/17/12.
//  Copyright (c) 2012 J.C. Li. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "FfmpegWrapper.h"

@interface YUVDisplayGLViewController : GLKViewController{
    GLuint _testTxture[3];

}
@property (assign,nonatomic)float xScal;
@property (assign,nonatomic)float yScal;
-(int) loadFrameData: (AVFrameData *) frameData;

-(BOOL) shouldHideMaster;

@end
