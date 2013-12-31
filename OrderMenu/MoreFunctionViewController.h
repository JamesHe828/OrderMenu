//
//  MoreFunctionViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreFunctionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView       *aTableView;
    NSArray           *ary;
    NSMutableArray    *_array;
    BOOL              flag[26];//里面默认值为no
   
}
@property(nonatomic,retain)NSMutableArray     *_array;

@end
