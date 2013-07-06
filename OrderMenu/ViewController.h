//
//  ViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView  *ascrollview;
    UIPageControl *pageC;
    UITableView   *aTableView;
    NSArray       *ary;
    NSArray       *nameAry;
    NSArray       *addressAry;
    NSString      *numberStr;
}
@property(nonatomic,retain)UIPageControl *pageC;
@property(nonatomic,retain)UITableView   *aTableView;
@property(nonatomic,retain)NSString      *numberStr;
@end
