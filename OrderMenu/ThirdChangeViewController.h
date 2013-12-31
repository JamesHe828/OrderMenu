//
//  ThirdChangeViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-12-26.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdChangeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIScrollView *scrollView;
    NSArray      *ary;
    UITableView  *aTableView;
    NSArray      *guanggaoAry;
}
@end
