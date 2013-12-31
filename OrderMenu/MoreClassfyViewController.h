//
//  MoreClassfyViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-12-27.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreClassfyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIApplicationDelegate>
{
    UITableView        *aTableView;
    NSMutableArray     *listAry;
    NSArray            *resAry;
}
@end
