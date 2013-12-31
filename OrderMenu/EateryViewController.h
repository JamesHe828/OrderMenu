//
//  EateryViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-8-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EateryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIScrollView  *ascrollview;
    UIPageControl *pageC;
    UITableView   *aTableView;
    NSMutableArray       *ary;
    NSString      *numberStr;
    NSMutableArray*searchAry;
    UITableView   *resultTableView;
    int           p;
    int           pageID,pageID2;
    NSString      *page_ID,*page_ID2;
    UIView        *up_view_region,*up_view_style,*up_view_near;
    UIButton      *btn1,*btn2,*btn3;
    NSMutableArray *nameAry,*styleAry;
    int           regionid,styleid,nearid;
    UIView        *backview;
    UIButton      *aNameBtn;
    NSArray       *departAry,*typedAry;
    NSString      *departStr,*typedStr;
    int           isAll,upOrClick;
}
@property(nonatomic,retain)UIPageControl *pageC;
@property(nonatomic,retain)UITableView   *aTableView;
@property(nonatomic,retain)NSString      *numberStr;
@property(nonatomic,retain)NSMutableArray*searchAry;
@property(nonatomic,retain)UITableView   *resultTableView;
@property(nonatomic,retain)UIScrollView  *ascrollview;
@property(nonatomic,retain)NSMutableArray *nameAry,*styleAry;
@end
