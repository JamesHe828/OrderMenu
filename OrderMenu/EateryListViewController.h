//
//  EateryListViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-12-30.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EateryListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray        *ary;
    UITableView    *aTableView;
    int            classID;
    NSString       *hideStr;
    int            pageID;
    NSString       *isPageID;
    
}
@property(nonatomic,assign)int            classID;
@property(nonatomic,retain)NSString       *hideStr;
@property(nonatomic,retain)NSString       *titleLabStr;
@end
