//
//  ViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UIScrollView  *ascrollview;
    UIPageControl *pageC;
    UITableView   *aTableView;
    NSArray       *ary;
    NSArray       *nameAry;
    NSArray       *addressAry;
    NSString      *numberStr;
    UISearchDisplayController *searchVC;
    NSMutableArray*searchAry;
}
@property(nonatomic,retain)UIPageControl *pageC;
@property(nonatomic,retain)UITableView   *aTableView;
@property(nonatomic,retain)NSString      *numberStr;
@property(nonatomic,retain)UISearchDisplayController *searchVC;
@property(nonatomic,retain)NSMutableArray*searchAry;
@end
