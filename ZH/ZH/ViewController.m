//
//  ViewController.m
//  ZH
//
//  Created by lsq on 2017/3/19.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "ZHPreViewViewController.h"
#import "UIViewController+UE.h"
#import "ZHDeviceModel.h"
#import "ZHFineDevice.h"

#define APP_COLORFROMHEX(s)            [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

@interface ViewController ()

@property(nonatomic,strong)UITextField *linkTextfield;
@end

@implementation ViewController

-(NSMutableArray *)deviceArr{
    if (!_deviceArr) {
        _deviceArr = [[NSMutableArray alloc] init];
    }
    return _deviceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *urlLabel = [[UILabel alloc] init];
    self.title = @"设备列表";
    [self.view addSubview:urlLabel];

    [self initUI];
    
    [self findDevice];

}

-(void)findDevice{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ZHFineDevice sharedInstance] fineDevice:^(ZHDeviceModel *devicemodel) {
            if (weakSelf.deviceArr.count > 0) {
                BOOL only = YES;
                for (ZHDeviceModel *model in weakSelf.deviceArr) {
                    NSString *devicename = model.IP;
                    if ([devicename isEqualToString:devicemodel.IP]) {
                        only = NO;
                        break;
                    }
                }
                if (only) {
                    [weakSelf.deviceArr addObject:devicemodel];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                }
            }else{
                if (devicemodel) {
                    [weakSelf.deviceArr addObject:devicemodel];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });

                }
            }
        }];
    });
}

-(void)initUI{
    UILabel *urlLable = [[UILabel alloc] init];
    [self.view addSubview:urlLable];
    urlLable.text = @"URL:";
    urlLable.font = [UIFont systemFontOfSize:14];
//    urlLable.backgroundColor = [UIColor redColor];
    [urlLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@100);
        
    }];
    self.linkTextfield = [[UITextField alloc] init];
    [self.view addSubview:self.linkTextfield];
    self.linkTextfield.text = @"rtsp://192.168.1.211/c=0&s=1";
    [self.linkTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.left.equalTo(urlLable.mas_right).offset(5);
    }];
    UIButton *confimBtn = [[UIButton alloc] init];
    [self.view addSubview:confimBtn];
    [confimBtn setTitle:@"确定" forState:UIControlStateNormal];
    confimBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [confimBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.linkTextfield.mas_right).offset(10);
        make.top.equalTo(@95);
        
    }];
    [confimBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    // 离上35像素
    UITableView *tableView = [[UITableView alloc] initWithFrame:
                              CGRectMake(0, 45 + 100, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];

}
-(void)jump{
    if (self.linkTextfield.text.length > 0 ) {
        ZHPreViewViewController *previewVC = [[ZHPreViewViewController alloc] init];
        NSArray *aArray = [self.linkTextfield.text componentsSeparatedByString:@"/"];
        ZHDeviceModel *devicemodel = [[ZHDeviceModel alloc] init];
        devicemodel.IP = [aArray objectAtIndex:2];
        previewVC.rtspUrl = self.linkTextfield.text;
        previewVC.deviceModel = devicemodel;
        [self.navigationController pushViewController:previewVC animated:YES];
    }
}

-(void)jumpTo:(ZHDeviceModel *)model{
    ZHPreViewViewController *previewVC = [[ZHPreViewViewController alloc] init];
    previewVC.deviceModel = model;
    previewVC.rtspUrl = [NSString stringWithFormat:@"rtsp://%@/c=0&s=1",model.IP];
    [self.navigationController pushViewController:previewVC animated:YES];
}

-(void)setwifiSetting{
    NSString * URLString = @"http://192.168.1.211/Login.cgi";
    NSURL * URL = [NSURL URLWithString:URLString];
    
    //查询
    NSString * postString = @"{\"Header\":{\"Action\":\"Request\",\"Method\":\"GetWifiConf\",\"Session\":\"\"},\"Param\":{}}\r\n\r\n";
    //设置有bug
//    NSString * postString = @"{\"Header\":{\"Action\":\"Request\",\"Method\":\"SetWifiConf\",\"Session\":\"\"},\"Param\":{\"SSID\":\"wifissd\",\"Passwd\":\"123456\",\"WifiMode\":\"Station\"}}\r\n\r\n";
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
  
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"%@",data);
    }];
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    ZHDeviceModel *model = [self.deviceArr objectAtIndex:indexPath.row];
    
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, 119.5, self.view.frame.size.width, 0.5);
    lineLabel.backgroundColor = APP_COLORFROMHEX(0xe5e5e5);
    [cell.contentView addSubview:lineLabel];
    
    UIImageView *devicenImageView = [[UIImageView alloc] init];
    devicenImageView.image = [UIImage imageNamed:@"setting"];
    [cell.contentView addSubview:devicenImageView];
    [devicenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@20);
        make.bottom.equalTo(@-20);
    }];
    
    UILabel *devicenameLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:devicenameLabel];
    devicenameLabel.font = [UIFont systemFontOfSize:18];
    devicenameLabel.textColor = [UIColor blackColor];
    devicenameLabel.text = model.IP;
    [devicenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(devicenImageView.mas_right).offset(15);
        make.top.equalTo(@19);
    }];
    
    UILabel *deviceipLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:deviceipLabel];
    deviceipLabel.font = [UIFont systemFontOfSize:16];
    deviceipLabel.textColor = APP_COLORFROMHEX(0xe828282);
    deviceipLabel.text = [NSString stringWithFormat:@"IP:%@",model.IP];
    [deviceipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(devicenImageView.mas_right).offset(15);
        make.top.equalTo(devicenameLabel.mas_bottom).offset(10);
    }];

    UILabel *devicehttpLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:devicehttpLabel];
    devicehttpLabel.font = [UIFont systemFontOfSize:16];
    devicehttpLabel.textColor = APP_COLORFROMHEX(0xe828282);
    devicehttpLabel.text = [NSString stringWithFormat:@"http:%@  RtspPort:%@",model.Port,model.RtspPort];
    [devicehttpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(devicenImageView.mas_right).offset(15);
        make.top.equalTo(deviceipLabel.mas_bottom).offset(10);
    }];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHDeviceModel *model = [self.deviceArr objectAtIndex:indexPath.row];
    [self jumpTo:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
