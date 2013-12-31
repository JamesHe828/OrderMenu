//
//  Chain_EateryViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-9-25.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Chain_EateryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView   *aTableView;
    NSArray       *ary;
    NSString      *pID;
}
@property(nonatomic,retain)NSString      *pID;
@end
