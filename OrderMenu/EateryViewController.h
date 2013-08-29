//
//  EateryViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-8-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EateryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView  *ascrollview;
    UIPageControl *pageC;
    UITableView   *aTableView;
    NSArray       *ary;
    NSArray       *nameAry;
    NSString      *numberStr;
    NSMutableArray*searchAry;
    UITableView   *resultTableView;
    int           p;
}
@property(nonatomic,retain)UIPageControl *pageC;
@property(nonatomic,retain)UITableView   *aTableView;
@property(nonatomic,retain)NSString      *numberStr;
@property(nonatomic,retain)NSMutableArray*searchAry;
@property(nonatomic,retain)UITableView   *resultTableView;
@property(nonatomic,retain)UIScrollView  *ascrollview;
@end
