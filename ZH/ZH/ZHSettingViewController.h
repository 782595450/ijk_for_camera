//
//  ZHSettingViewController.h
//  ZH
//
//  Created by lsq on 2017/3/19.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArr;



@end
