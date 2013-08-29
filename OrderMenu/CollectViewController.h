//
//  CollectViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-8.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray        *ary;
    NSMutableArray *collectAry;
    UITableView    *aTableView;
    NSUserDefaults *userDefaults;
    int            p;
    UIButton       *editBtn;
}
@property(nonatomic,retain) NSArray  *ary;
@property(nonatomic,retain)NSMutableArray *collectAry;
@property(nonatomic,retain)UITableView    *aTableView;
@end
