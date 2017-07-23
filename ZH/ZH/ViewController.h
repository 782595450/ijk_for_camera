//
//  ViewController.h
//  ZH
//
//  Created by lsq on 2017/3/19.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>
//RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *deviceArr;




@end

