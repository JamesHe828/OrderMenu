//
//  SearchViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-11.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResultViewController;
@interface SearchViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray     *ary;
    UISearchBar        *aSearchBar;
    UITableView        *resultTableView;
    SearchResultViewController *searchReslutVC;
    NSArray            *searcharry;
    NSString           *seatchStr;
}
@property(nonatomic,retain)NSMutableArray     *ary;
@property(nonatomic,retain)NSArray            *searcharry;
@property(nonatomic,retain)NSString           *seatchStr;
@end
