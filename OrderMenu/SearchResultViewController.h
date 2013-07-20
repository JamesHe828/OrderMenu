//
//  SearchResultViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-12.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@interface SearchResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray        *ary;
    UITableView    *aTableView;
    NSString       *searchStr;
    DetailViewController *detailVC;
    int            p;
}
@property(nonatomic,retain)NSArray        *ary;
@property(nonatomic,retain)NSString       *searchStr;
@property(nonatomic,retain)UITableView    *aTableView;
@end
