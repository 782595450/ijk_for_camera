//
//  ZHFineDevice.m
//  ZH
//
//  Created by lsq on 2017/3/31.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "ZHFineDevice.h"
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<string.h>
#define HELLO_PORT 3703
#define HELLO_GROUP "239.255.255.250"

@implementation ZHFineDevice

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id fineDevice = nil;
    dispatch_once(&onceToken, ^{
        fineDevice = [[[self class] alloc] init];
    });
    return fineDevice;
}

char bufftmp[1024];

-(void)fineDevice:(void (^)(ZHDeviceModel *devicemodel))deviceBlock{

    NSString *postString = @"{\"Header\":{\"Action\":\"Request\",\"Method\":\"Discover\",\"Session\":\"\"},\"Param\":{\"Type\":\"ALL\"}}";
    NSData *commandjsonData =[postString dataUsingEncoding:NSUTF8StringEncoding] ;
    char *bufs = (char *)[commandjsonData bytes];
    
    int s = socket(AF_INET,SOCK_DGRAM,0);
    if(0 > s)
    {
        perror("socket");
        return ;
    }
    
    int fd_socket = socket(AF_INET,SOCK_DGRAM,0);
    if (fd_socket < 0) {
        return ;
    }
    
    struct sockaddr_in addr_dest;
    memset(&addr_dest, 0, sizeof(addr_dest));
    addr_dest.sin_family = AF_INET;
    addr_dest.sin_addr.s_addr = inet_addr(HELLO_GROUP);
    addr_dest.sin_port = htons(HELLO_PORT);
    
    int length = sendto(fd_socket, bufs, strlen(bufs), 0, (struct sockaddr *)&addr_dest, sizeof(addr_dest));
    if (length < 0) {
        return;
    }
    
    while (1) {
        length = recv(fd_socket, bufftmp, 1024,0);
        if (length < 0) {
            return ;
        }
        NSString *str = [NSString stringWithFormat:@"%s",bufftmp];
        [self dataprocessing:str withBlock:deviceBlock];
        NSLog(@"\n bufftmp [%@]\n", str);
    }
    
    
}

-(void)dataprocessing:(NSString *)data withBlock:(void (^)(ZHDeviceModel *devicemodel))deviceBlock{
    NSData *datas = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
    ZHDeviceModel *model = [[ZHDeviceModel alloc] init];
    model.IP = [[jsonDict objectForKey:@"Param"] objectForKey:@"IP"];
    model.Port = [[jsonDict objectForKey:@"Param"] objectForKey:@"Port"];
    model.RtspPort = [[jsonDict objectForKey:@"Param"] objectForKey:@"RtspPort"];
    model.Type = [[jsonDict objectForKey:@"Param"] objectForKey:@"Type"];
    if (deviceBlock) {
        deviceBlock(model);
    }

    
}

@end
