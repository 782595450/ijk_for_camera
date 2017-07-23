//
//  FFmpegConvert.m
//  FFmpeg_X264_Codec
//
//  Created by Horace Poon on 25/12/15.
//  Copyright © 2015年 suntongmian@163.com. All rights reserved.
//

#import "FFmpegConvert.h"
#import "avcodec.h"
#import "avformat.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation FFmpegConvert{
    const char *in_filename_a, *out_filename,*in_filename_v;
}

- (void)StartConvert:(NSString*)srcPath{
    [self H264ConvertMP4:srcPath];
    [self saveMovieToCameraRoll];
}

/**
 *  H264转MP4  //测试成功
 */
-(int)H264ConvertMP4:(NSString *)srcPath{
    AVOutputFormat *ofmt = NULL;
    //输入对应一个AVFormatContext，输出对应一个AVFormatContext
    //（Input AVFormatContext and Output AVFormatContext）
    AVFormatContext *ifmt_ctx = NULL, *ofmt_ctx = NULL;
    AVPacket pkt;
    const char *in_filename, *out_filenames;
    int ret, i;
    in_filename  = [[NSString stringWithFormat:@"%@/Documents/ffmpegVideo.h264",NSHomeDirectory()] UTF8String];//输入文件名（Input file URL）
    out_filenames = [[NSString stringWithFormat:@"%@/Documents/ffmpegVideo.mp4",NSHomeDirectory()] UTF8String];//输出文件名（Output file URL）
    av_register_all();
    //输入（Input）
    if ((ret = avformat_open_input(&ifmt_ctx, in_filename, 0, 0)) < 0) {
        NSLog(@"Could not open input file.");
        goto end;
    }
    if ((ret = avformat_find_stream_info(ifmt_ctx, 0)) < 0) {
        NSLog(@"Failed to retrieve input stream information");
        goto end;
    }
    av_dump_format(ifmt_ctx, 0, in_filename, 0);
    //输出（Output）
    avformat_alloc_output_context2(&ofmt_ctx, NULL, NULL, out_filenames);
    if (!ofmt_ctx) {
        NSLog(@"Could not create output context\n");
        ret = AVERROR_UNKNOWN;
        goto end;
    }
    ofmt = ofmt_ctx->oformat;
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        //根据输入流创建输出流（Create output AVStream according to input AVStream）
        AVStream *in_stream = ifmt_ctx->streams[i];
        AVStream *out_stream = avformat_new_stream(ofmt_ctx, in_stream->codec->codec);
        if (!out_stream) {
            NSLog(@"Failed allocating output stream\n");
            ret = AVERROR_UNKNOWN;
            goto end;
        }
        //复制AVCodecContext的设置（Copy the settings of AVCodecContext）
        ret = avcodec_copy_context(out_stream->codec, in_stream->codec);
        if (ret < 0) {
            NSLog(@"Failed to copy context from input to output stream codec context\n");
            goto end;
        }
        out_stream->codec->codec_tag = 0;
        if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER)
            out_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
    }
    //输出一下格式------------------
    av_dump_format(ofmt_ctx, 0, out_filenames, 1);
    //打开输出文件（Open output file）
    if (!(ofmt->flags & AVFMT_NOFILE)) {
        ret = avio_open(&ofmt_ctx->pb, out_filenames, AVIO_FLAG_WRITE);
        if (ret < 0) {
            NSLog(@"Could not open output file '%s'", out_filenames);
            goto end;
        }
    }
    //写文件头（Write file header）
    ret = avformat_write_header(ofmt_ctx, NULL);
    if (ret < 0) {
        NSLog(@"Error occurred when opening output file\n");
        goto end;
    }
    int frame_index=0;
    while (1) {
        AVStream *in_stream, *out_stream;
        //获取一个AVPacket（Get an AVPacket）
        ret = av_read_frame(ifmt_ctx, &pkt);
        if (ret < 0)
            break;
        in_stream  = ifmt_ctx->streams[pkt.stream_index];
        out_stream = ofmt_ctx->streams[pkt.stream_index];
        /* copy packet */
        //转换PTS/DTS（Convert PTS/DTS）
        pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
        pkt.dts = av_rescale_q_rnd(pkt.dts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
        pkt.duration = (int)av_rescale_q((int64_t)pkt.duration, in_stream->time_base, out_stream->time_base);
        pkt.pos = -1;
        //写入（Write）
        ret = av_interleaved_write_frame(ofmt_ctx, &pkt);
        if (ret < 0) {
            NSLog(@"Error muxing packet\n");
            break;
        }
        //NSLog(@"Write %8d frames to output file\n",frame_index);
        av_free_packet(&pkt);
        frame_index++;
    }
    //写文件尾（Write file trailer）
    av_write_trailer(ofmt_ctx);
end:
    avformat_close_input(&ifmt_ctx);
    /* close output */
    if (ofmt_ctx && !(ofmt->flags & AVFMT_NOFILE))
        avio_close(ofmt_ctx->pb);
    avformat_free_context(ofmt_ctx);
    if (ret < 0 && ret != AVERROR_EOF) {
        NSLog(@"Error occurred.\n");
        return -1;
    }
    return 0;
}

/**
 *  H264与pcm转MP4  //测试没成功
 */
-(int)H264AndPCMConvertMP4:(NSString *)srcPath{
    AVOutputFormat *ofmt = NULL;
    AVFormatContext *ifmt_ctx_v = NULL, *ifmt_ctx_a = NULL,*ofmt_ctx = NULL;
    AVPacket pkt;
    int ret, i;
    int videoindex_v=-1,videoindex_out=-1;
    int audioindex_a=-1,audioindex_out=-1;
    int frame_index=0;
    int64_t cur_pts_v=0,cur_pts_a=0;

    in_filename_v = [[NSString stringWithFormat:@"%@/Documents/ffmpegVideo.h264",NSHomeDirectory()] UTF8String];
    in_filename_a = [[NSString stringWithFormat:@"%@/Documents/ffmpegAudio.pcm",NSHomeDirectory()] UTF8String];
    out_filename = [[NSString stringWithFormat:@"%@/Documents/ffmpegVideo.mp4",NSHomeDirectory()] UTF8String];
    av_register_all();
    // ‰»Î£®Input£©
    if ((ret = avformat_open_input(&ifmt_ctx_v, in_filename_v, 0, 0)) < 0) {
        printf( "Could not open input file.");
        goto end;
    }
    if ((ret = avformat_find_stream_info(ifmt_ctx_v, 0)) < 0) {
        printf( "Failed to retrieve input stream information");
        goto end;
    }
    if ((ret = avformat_open_input(&ifmt_ctx_a, in_filename_a, 0, 0)) < 0) {
        printf( "Could not open input file.");
        goto end;
    }
    if ((ret = avformat_find_stream_info(ifmt_ctx_a, 0)) < 0) {
        printf( "Failed to retrieve input stream information");
        goto end;
    }
    av_dump_format(ifmt_ctx_v, 0, in_filename_v, 0);
    av_dump_format(ifmt_ctx_a, 0, in_filename_a, 0);
    avformat_alloc_output_context2(&ofmt_ctx, NULL, NULL, out_filename);
    if (!ofmt_ctx) {
        printf( "Could not create output context\n");
        ret = AVERROR_UNKNOWN;
        goto end;
    }
    ofmt = ofmt_ctx->oformat;
    for (i = 0; i < ifmt_ctx_v->nb_streams; i++) {
        //∏˘æ› ‰»Î¡˜¥¥Ω® ‰≥ˆ¡˜£®Create output AVStream according to input AVStream£©
        if(ifmt_ctx_v->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO){
            AVStream *in_stream = ifmt_ctx_v->streams[i];
            AVStream *out_stream = avformat_new_stream(ofmt_ctx, in_stream->codec->codec);
            videoindex_v=i;
            if (!out_stream) {
                printf( "Failed allocating output stream\n");
                ret = AVERROR_UNKNOWN;
                goto end;
            }
            videoindex_out=out_stream->index;
            //∏¥÷∆AVCodecContextµƒ…Ë÷√£®Copy the settings of AVCodecContext£©
            if (avcodec_copy_context(out_stream->codec, in_stream->codec) < 0) {
                printf( "Failed to copy context from input to output stream codec context\n");
                goto end;
            }
            out_stream->codec->codec_tag = 0;
            if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER)
                out_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
            break;
        }
    }
    for (i = 0; i < ifmt_ctx_a->nb_streams; i++) {
        //∏˘æ› ‰»Î¡˜¥¥Ω® ‰≥ˆ¡˜£®Create output AVStream according to input AVStream£©
        if(ifmt_ctx_a->streams[i]->codec->codec_type==AVMEDIA_TYPE_AUDIO){
            AVStream *in_stream = ifmt_ctx_a->streams[i];
            AVStream *out_stream = avformat_new_stream(ofmt_ctx, in_stream->codec->codec);
            audioindex_a=i;
            if (!out_stream) {
                printf( "Failed allocating output stream\n");
                ret = AVERROR_UNKNOWN;
                goto end;
            }
            audioindex_out=out_stream->index;
            //∏¥÷∆AVCodecContextµƒ…Ë÷√£®Copy the settings of AVCodecContext£©
            if (avcodec_copy_context(out_stream->codec, in_stream->codec) < 0) {
                printf( "Failed to copy context from input to output stream codec context\n");
                goto end;
            }
            out_stream->codec->codec_tag = 0;
            if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER)
                out_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
            break;
        }
    }
    av_dump_format(ofmt_ctx, 0, out_filename, 1);
    if (!(ofmt->flags & AVFMT_NOFILE)) {
        if (avio_open(&ofmt_ctx->pb, out_filename, AVIO_FLAG_WRITE) < 0) {
            printf( "Could not open output file '%s'", out_filename);
            goto end;
        }
    }
    if (avformat_write_header(ofmt_ctx, NULL) < 0) {
        printf( "Error occurred when opening output file\n");
        goto end;
    }
    while (1) {
        AVFormatContext *ifmt_ctx;
        int stream_index=0;
        AVStream *in_stream, *out_stream;
        if(av_compare_ts(cur_pts_v,ifmt_ctx_v->streams[videoindex_v]->time_base,cur_pts_a,ifmt_ctx_a->streams[audioindex_a]->time_base) <= 0){
            ifmt_ctx=ifmt_ctx_v;
            stream_index=videoindex_out;
            if(av_read_frame(ifmt_ctx, &pkt) >= 0){
                do{
                    in_stream  = ifmt_ctx->streams[pkt.stream_index];
                    out_stream = ofmt_ctx->streams[stream_index];
                    if(pkt.stream_index==videoindex_v){
                        //Simple Write PTS
                        if(pkt.pts==AV_NOPTS_VALUE){
                            //Write PTS
                            AVRational time_base1=in_stream->time_base;
                            //Duration between 2 frames (us)
                            int64_t calc_duration=(double)AV_TIME_BASE/av_q2d(in_stream->r_frame_rate);
                            //Parameters
                            pkt.pts=(double)(frame_index*calc_duration)/(double)(av_q2d(time_base1)*AV_TIME_BASE);
                            pkt.dts=pkt.pts;
                            pkt.duration=(double)calc_duration/(double)(av_q2d(time_base1)*AV_TIME_BASE);
                            frame_index++;
                        }
                        cur_pts_v=pkt.pts;
                        break;
                    }
                }while(av_read_frame(ifmt_ctx, &pkt) >= 0);
            }else{
                break;
            }
        }else{
            ifmt_ctx=ifmt_ctx_a;
            stream_index=audioindex_out;
            if(av_read_frame(ifmt_ctx, &pkt) >= 0){
                do{
                    in_stream  = ifmt_ctx->streams[pkt.stream_index];
                    out_stream = ofmt_ctx->streams[stream_index];
                    if(pkt.stream_index==audioindex_a){
                        //Simple Write PTS
                        if(pkt.pts==AV_NOPTS_VALUE){
                            //Write PTS
                            AVRational time_base1=in_stream->time_base;
                            //Duration between 2 frames (us)
                            int64_t calc_duration=(double)AV_TIME_BASE/av_q2d(in_stream->r_frame_rate);
                            //Parameters
                            pkt.pts=(double)(frame_index*calc_duration)/(double)(av_q2d(time_base1)*AV_TIME_BASE);
                            pkt.dts=pkt.pts;
                            pkt.duration=(double)calc_duration/(double)(av_q2d(time_base1)*AV_TIME_BASE);
                            frame_index++;
                        }
                        cur_pts_a=pkt.pts;
                        
                        break;
                    }
                }while(av_read_frame(ifmt_ctx, &pkt) >= 0);
            }else{
                break;
            }
        }
        //转换PTS/DTS（Convert PTS/DTS）
        pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
        pkt.dts = av_rescale_q_rnd(pkt.dts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
        pkt.duration = (int)av_rescale_q((int64_t)pkt.duration, in_stream->time_base, out_stream->time_base);
        pkt.pos = -1;
        if (av_interleaved_write_frame(ofmt_ctx, &pkt) < 0) {
            printf( "Error muxing packet\n");
            break;
        }
        av_free_packet(&pkt);
    }
    av_write_trailer(ofmt_ctx);
    
end:
    avformat_close_input(&ifmt_ctx_v);
    avformat_close_input(&ifmt_ctx_a);
    /* close output */
    if (ofmt_ctx && !(ofmt->flags & AVFMT_NOFILE))
        avio_close(ofmt_ctx->pb);
    avformat_free_context(ofmt_ctx);
    if (ret < 0 && ret != AVERROR_EOF) {
        printf( "Error occurred.\n");
        return -1;
    }
    return 0;
}

/**
 *  保存到相册
 */
- (void)saveMovieToCameraRoll{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    NSString *camerafile = [NSString stringWithFormat:@"%@/Documents/ffmpegVideo.mp4",NSHomeDirectory()];
    NSURL * url = [NSURL URLWithString:camerafile];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:url
                                      completionBlock: ^(NSURL *assetURL, NSError *error) {
//                                          [self removeFile:[NSString stringWithFormat:@"%@/Documents/ffmpegVideo.mp4",NSHomeDirectory()]];
//                                          [self removeFile:[NSString stringWithFormat:@"%@/Documents/ffmpegVideo.h264",NSHomeDirectory()]];
//                                          [self removeFile:[NSString stringWithFormat:@"%@/Documents/ffmpegAudio.pcm",NSHomeDirectory()]];
                                      }];
}

/**
 *  沙盒中删除文件
 */
-(void)removeFile:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (!success)
            NSLog(@"FFMpegConvert: Remove file[%@] error!", filePath);
    }
}
@end
