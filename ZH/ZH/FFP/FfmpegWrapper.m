//
//  FfmpegWrapper.m
//  rtsp_ffmpeg_player
//
//  Created by J.C. Li on 11/2/12.
//  Copyright (c) 2012 J.C. Li. All rights reserved.
//


#import "FfmpegWrapper.h"
#import "avcodec.h"
#import "avformat.h"
#import "swscale.h"
#include <libkern/OSAtomic.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "OpenALPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "FFmpegConvert.h"
@implementation AVFrameData
@synthesize colorPlane0=_colorPlane0;
@synthesize colorPlane1=_colorPlane1;
@synthesize colorPlane2=_colorPlane2;
@synthesize lineSize0=_lineSize0;
@synthesize lineSize1=_lineSize1;
@synthesize lineSize2=_lineSize2;
@synthesize width=_width;
@synthesize height=_height;
@synthesize presentationTime=_presentationTime;

@end

@interface FfmpegWrapper(){
    AVFormatContext *_formatCtx;
    AVFormatContext *_outputformatCtx;
    AVCodecContext  *_videocodecCtx;
    AVCodecContext  *_AudiocodecCtx;
    AVCodec         *_videocodec;
    AVCodec         *_Audiocodec;

    AVFrame         *_frame;
    AVPacket        _packet;
    AVDictionary    *_optionsDict;
    int _videoStream;
    int _audioStream;
    dispatch_semaphore_t _outputSinkQueueSema;
    
    dispatch_group_t _decode_queue_group;
    
    volatile bool _stopDecode;
    CFTimeInterval _previousDecodedFrameTime;
    FILE *videofp;
    FILE *audiofp;
    BOOL isVideo,isAudio;

    OpenALPlayer *player;
    
    const char *videopath;
    const char *audiopath;
    
    BOOL isMp4;
    FFmpegConvert *pConvert;
}

@end

@implementation FfmpegWrapper
#define MIN_FRAME_INTERVAL 0.01

-(id) init{
    
    self=[super init];
    // initialize all instance variables
    _formatCtx = NULL;
    _videocodecCtx = NULL;
    _AudiocodecCtx=NULL;
    _Audiocodec = NULL;
    _videocodec=NULL;
    _videocodecCtx=NULL;
    _frame = NULL;
    _optionsDict = NULL;
    isVideo=NO;
    isAudio=NO;
    // register av
    av_register_all();
    avformat_network_init();
    
    // setup output queue depth;
    _outputSinkQueueSema = dispatch_semaphore_create((long)(5));
    
    _decode_queue_group = dispatch_group_create();
    
    // set memory barrier
    OSMemoryBarrier();
    _stopDecode=false;

    _previousDecodedFrameTime=0;
    pConvert=[[FFmpegConvert alloc]init];
    return self;

}

-(int) openUrl: (NSString *) url{

//    [self createSaveDir];

    if (_formatCtx!=NULL || _videocodec!=NULL){
        return -1;  //url already opened
    }
    // open video stream
    AVDictionary *serverOpt = NULL;
    av_dict_set(&serverOpt, "rtsp_transport", "tcp", 0);
    if (avformat_open_input(&_formatCtx, [url UTF8String], NULL, &serverOpt)!=0){
        [self dealloc_helper];
        return -1; // Couldn't open file
    }
    
    // Retrieve stream information
    AVDictionary * options = NULL;
    av_dict_set(&options, "analyzeduration", "1000000", 0);

    if(avformat_find_stream_info(_formatCtx, &options)<0){
        [self dealloc_helper];
        return -1; // Couldn't find stream information
    }

    // Dump information about file onto standard error
    av_dump_format(_formatCtx, 0, [url UTF8String], 0);
    
    // Find the first video stream
    /**
     *  找到音视频流
     */
    _videoStream=-1;_audioStream = -1;
    for(int i=0; i<_formatCtx->nb_streams; i++){
        if(_formatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO) {
            _videoStream=i;
        }else if (_formatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_AUDIO){
            _audioStream = i;
        }
    }
    NSLog(@"_videoStream=%i,_audioStream=%i",_videoStream,_audioStream);

    //视频初始化
    if(_videoStream==-1){
        [self dealloc_helper];
        return -1; // Didn't find a video stream
    }

    // Get a pointer to the codec context for the video stream
    _videocodecCtx=_formatCtx->streams[_videoStream]->codec;

    // Find the decoder for the video stream
    _videocodec=avcodec_find_decoder(_videocodecCtx->codec_id);
    if(_videocodec==NULL) {
        fprintf(stderr, "Unsupported codec!\n");
        [self dealloc_helper];
        return -1; // Codec not found
    }
    // Open codec
    if(avcodec_open2(_videocodecCtx, _videocodec, &_optionsDict)<0){
        [self dealloc_helper];
        return -1; // Could not open codec
    }
    
    //音频初始化
    if (_audioStream!=-1) {
        _AudiocodecCtx=_formatCtx->streams[_audioStream]->codec;
        
        // Find the decoder for the video stream
        _Audiocodec=avcodec_find_decoder(_AudiocodecCtx->codec_id);
        if(_Audiocodec==NULL) {
            fprintf(stderr, "Unsupported codec!\n");
//            [self dealloc_helper];
            return -1; // Codec not found
        }
        // Open codec
        if(avcodec_open2(_AudiocodecCtx, _Audiocodec, &_optionsDict)<0){
//            [self dealloc_helper];
            return -1; // Could not open codec
        }
    }

    _frame=av_frame_alloc();

    // Allocate video frame
    if (!_frame){
        [self dealloc_helper];
        return -1;  // Could not allocate frame buffer
    }
    
    //初始化音频播放器
    player=[[OpenALPlayer alloc]init];
    [player initOpenAL:AL_FORMAT_MONO16 :44100];
    return 0;

}

-(AVFrameData *) createFrameData: (AVFrame *) frame
                     trimPadding: (BOOL) trim{
    AVFrameData *frameData = [[AVFrameData alloc] init];
    if (trim){
        frameData.colorPlane0 = [[NSMutableData alloc] init];
        frameData.colorPlane1 = [[NSMutableData alloc] init];
        frameData.colorPlane2 = [[NSMutableData alloc] init];
        for (int i=0; i<frame->height; i++){
            [frameData.colorPlane0 appendBytes:(void*) (frame->data[0]+i*frame->linesize[0])
                                        length:frame->width];
        }
        for (int i=0; i<frame->height/2; i++){
            [frameData.colorPlane1 appendBytes:(void*) (frame->data[1]+i*frame->linesize[1])
                                        length:frame->width/2];
            [frameData.colorPlane2 appendBytes:(void*) (frame->data[2]+i*frame->linesize[2])
                                        length:frame->width/2];
        }
        frameData.lineSize0 = [[NSNumber alloc] initWithInt:frame->width];
        frameData.lineSize1 = [[NSNumber alloc] initWithInt:frame->width/2];
        frameData.lineSize2 = [[NSNumber alloc] initWithInt:frame->width/2];
    }else{
        frameData.colorPlane0 = [[NSMutableData alloc] initWithBytes:frame->data[0] length:frame->linesize[0]*frame->height];
        frameData.colorPlane1 = [[NSMutableData alloc] initWithBytes:frame->data[1] length:frame->linesize[1]*frame->height/2];
        frameData.colorPlane2 = [[NSMutableData alloc] initWithBytes:frame->data[2] length:frame->linesize[2]*frame->height/2];
        frameData.lineSize0 = [[NSNumber alloc] initWithInt:frame->linesize[0]];
        frameData.lineSize1 = [[NSNumber alloc] initWithInt:frame->linesize[1]];
        frameData.lineSize2 = [[NSNumber alloc] initWithInt:frame->linesize[2]];
    }

    frameData.width = [[NSNumber alloc] initWithInt:frame->width];
    frameData.height = [[NSNumber alloc] initWithInt:frame->height];
    return frameData;

}

-(void) stopDecode{
    _stopDecode = true;
}

-(int) startDecodingWithCallbackBlock: (void (^) (AVFrameData *frame,AVFrame *avFrame)) frameCallbackBlock
                      waitForConsumer: (BOOL) wait
                   completionCallback: (void (^)()) completion{

    OSMemoryBarrier();
    _stopDecode=false;
    dispatch_queue_t decodeQueue = dispatch_queue_create("decodeQueue", NULL);
    dispatch_async(decodeQueue, ^{
        int frameFinished;
        OSMemoryBarrier();
        while (self->_stopDecode==false){
            @autoreleasepool {
                CFTimeInterval currentTime = CACurrentMediaTime();
                if ((currentTime-_previousDecodedFrameTime) > MIN_FRAME_INTERVAL &&
                    av_read_frame(_formatCtx, &_packet)>=0) {
                    _previousDecodedFrameTime = currentTime;
                    // Is this a packet from the video stream?
                    NSLog(@"_packet.stream_index==%i",_packet.stream_index);
                    //视频解码
                    if(_packet.stream_index==_videoStream) {
//                        NSLog(@"视频解码");
                        avcodec_decode_video2(_videocodecCtx, _frame, &frameFinished,
                                              &_packet);
                        if (isVideo) {
                            /**
                             *  视频写入沙盒
                             */
                            fwrite(_packet.data, 1, _packet.size, videofp);
                            
                        }
                        if(frameFinished) {
                            // yuv;
                            AVFrameData *frameData = [self createFrameData:_frame trimPadding:YES];
                            frameCallbackBlock(frameData,_frame);
//                            break;
                        }
                    }
                    
                    //音频解码
                    if (_packet.stream_index==_audioStream) {
//                        NSLog(@"音频");
                        //解码
                        int   nRet= avcodec_decode_audio4(_AudiocodecCtx, _frame, &frameFinished, &_packet);
//                        NSLog(@"%s",_packet.data);
                        if (nRet) {
                            [player openAudioFromQueue:[NSData dataWithBytes:_packet.data length:_packet.size]];
                            if (isAudio) {
                                /**
                                 *  音频写入沙盒
                                 */
                                fwrite(_packet.data, 1, _packet.size, audiofp);                        // Did we get a audio frame?
                            }
                        }
                    }
                    // Free the packet that was allocated by av_read_frame
                    av_free_packet(&_packet);
                }else{
                    usleep(1000);
                }
            }
        }
        completion();
    });
    return 0;
}

/**
 *  开始录像
 */
-(void)startVideo{
    [self initForFilePath];
    isVideo=YES;
    isAudio=YES;
}

/**
 *  停止录像
 */
-(void)stopVideo{
    isVideo=NO;
    isAudio=NO;
    fclose(videofp);
//    fclose(audiofp);
    //h264转mp4并保存到相册
    [pConvert StartConvert:[NSString stringWithFormat:@"%@/Documents/ffmpegVideo.h264",NSHomeDirectory()]];
}

- (void)initForFilePath{

    //视频地址
    videopath = [[NSString stringWithFormat:@"%@/Documents/ffmpegVideo.h264",NSHomeDirectory()] UTF8String];
    videofp = fopen(videopath,"wb");
    
    //音频地址
//    audiopath = [[NSString stringWithFormat:@"%@/Documents/ffmpegAudio.pcm",NSHomeDirectory()] UTF8String];
//    audiofp=fopen(audiopath,"wb");

}


- (char*)GetFilePathByfileName:(char*)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *strName = [NSString stringWithFormat:@"%s",filename];
    NSString *writablePath = [documentsDirectory stringByAppendingPathComponent:strName];
    int len = (int)[writablePath length];
    char *filepath = (char*)malloc(sizeof(char) * (len + 1));
    [writablePath getCString:filepath maxLength:len + 1 encoding:[NSString defaultCStringEncoding]];
    return filepath;
    
}

+(UIImage *)imageFromAVPicture:(unsigned char **)picData
                      lineSize:(int *) linesize
                         width:(int)width height:(int)height{

    /**
     *删除图片
     */
    // 获得此程序的沙盒路径
//    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    // 获取Documents路径
//    NSFileManager * fm = [NSFileManager defaultManager];
//    NSArray  *arr = [fm subpathsOfDirectoryAtPath:[patchs objectAtIndex:0] error:nil];
//    NSLog(@"%@",arr);
//    for (int i=0; i<arr.count; i++) {
//        NSFileManager *fm = [NSFileManager defaultManager];
//        [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [patchs objectAtIndex:0], [arr objectAtIndex:i]] error:nil];
//    }

    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, picData[0], linesize[0]*height,kCFAllocatorNull);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(width,
                                       height,
                                       8,
                                       24,
                                       linesize[0],
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSSSSS"];  // 输出格式
    NSString *str = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fddd = [str stringByAppendingString:@".png"];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * filename = [[ paths objectAtIndex:0]stringByAppendingPathComponent:fddd];
    NSLog(@"%@",image);
    if ([UIImageJPEGRepresentation(image, 1.0) writeToFile:filename atomically:YES]){
        UIImage *img=[UIImage imageWithContentsOfFile:filename];
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary writeImageToSavedPhotosAlbum:[img CGImage] orientation:(ALAssetOrientation)img.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
//            NSLog(@"%@",assetsLibrary);
            //            //同时删除沙盒里的文件
            //        NSFileManager *fm = [NSFileManager defaultManager];
            //        [fm removeItemAtPath:filename error:nil];
        }];
//        UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);

    }else{
        NSLog(@"write file fail");
    }

    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CFRelease(data);
    
    return image;

}

//拍照
+(UIImage *) convertFrameDataToImage: (AVFrameData *) avFrameData avFrame:(AVFrame *)avFrame
{
    // Allocate an AVFrame structure
    
    //===================把yuv帧数据转为rgb===========
    UIImage *image=[[UIImage alloc]init];
    AVFrame *rgbBuf;
    rgbBuf=av_frame_alloc();
    int numBytes=avpicture_get_size(PIX_FMT_RGB24, avFrame->width,
                                    avFrame->height);

    uint8_t *buffer=(uint8_t *)av_malloc(numBytes*sizeof(uint8_t));
    avpicture_fill((AVPicture *)rgbBuf, buffer, PIX_FMT_RGB24,
                   avFrame->width, avFrame->height);
    struct SwsContext *img_convert_ctx = 0;
    // int linesize[4] = {3*decoded_frame->width, 0, 0, 0};
    img_convert_ctx = sws_getContext(avFrameData.width.intValue, avFrameData.height.intValue,
                                     PIX_FMT_YUV420P,
                                     avFrameData.width.intValue,
                                     avFrameData.height.intValue,
                                     PIX_FMT_RGB24, SWS_FAST_BILINEAR, 0, 0, 0);
    if (img_convert_ctx != 0)
    {
        uint8_t *data[AV_NUM_DATA_POINTERS];
        int linesize[AV_NUM_DATA_POINTERS];
        for (int i=0; i<AV_NUM_DATA_POINTERS; i++){
            data[i] = NULL;
            linesize[i] = 0;
        }

        data[0]=(uint8_t*)(avFrameData.colorPlane0.bytes);
        data[1]=(uint8_t*)(avFrameData.colorPlane1.bytes);
        data[2]=(uint8_t*)(avFrameData.colorPlane2.bytes);
        linesize[0]=avFrameData.lineSize0.intValue;
        linesize[1]=avFrameData.lineSize1.intValue;
        linesize[2]=avFrameData.lineSize2.intValue;

        sws_scale(img_convert_ctx, (uint8_t const * const *)data, linesize, 0, avFrame->height,rgbBuf->data,rgbBuf->linesize);
        sws_freeContext(img_convert_ctx);
        
        image= [self imageFromAVPicture:rgbBuf->data
                               lineSize:rgbBuf->linesize
                                  width:avFrame->width height:avFrame->height];
    }
    av_free(buffer);
    //==============================================

    return image;
}


-(void)dealloc_helper
{
    // Free the YUV frame
    if (_frame){
        av_free(_frame);
    }

    // Close the codec
    if (_videocodecCtx){
        avcodec_close(_videocodecCtx);
    }
    // Close the video src
    if (_formatCtx){
        avformat_close_input(&_formatCtx);
    }

    if (_AudiocodecCtx) {
        avcodec_close(_AudiocodecCtx);

    }
}

-(void)dealloc
{
//    dispatch_group_wait(_decode_queue_group, DISPATCH_TIME_FOREVER);
    [self stopDecode];
    sleep(1);
    [self dealloc_helper];

}

  
@end
