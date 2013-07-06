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
    UITableView *aTableView;
    NSArray     *ary;
}
@end
