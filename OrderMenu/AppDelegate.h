//
//  AppDelegate.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "WXApi.h"

@class ViewController;
@class LeveyTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UINavigationControllerDelegate>
{
    UINavigationController *nav_set,*nav_third,*nav_collect,*nav_orderList,*nav_map;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic,strong)DDMenuController *ddmenuControler;
@property (nonatomic,retain)UINavigationController *AllNav;
@property (nonatomic, retain)LeveyTabBarController *leveyTabBarController;
-(void)hideBotmoBar;
-(void)showBotomBar;
@end
