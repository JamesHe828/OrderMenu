//
//  AppDelegate.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SettingViewController.h"
#import "MoreFunctionViewController.h"
#import "HelpViewController.h"
#import "Reachability.h"
#import "DataBase.h"
#import "TKHttpRequest.h"
#import "MobClick.h"
@implementation AppDelegate
@synthesize ddmenuControler;
@synthesize AllNav;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // [UMSocialData setAppKey:@"51dccb0456240b7f87001d5e"];
    [MobClick startWithAppkey:@"51dccb0456240b7f87001d5e"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:self.viewController];
//    self.AllNav = nav;
//    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:nav];
//    ddmenuControler = rootController;
//    SettingViewController *setVC=[[SettingViewController alloc] init];
//    UINavigationController *nav2=[[UINavigationController alloc] initWithRootViewController:setVC];
//    ddmenuControler.leftViewController=nav2;
//    MoreFunctionViewController *moreVC=[[MoreFunctionViewController alloc] init];
//    UINavigationController *nav3=[[UINavigationController alloc] initWithRootViewController:moreVC];
//    ddmenuControler.rightViewController=nav3;
//    self.AllNav = [[UINavigationController alloc] initWithRootViewController:ddmenuControler];
//    self.AllNav.navigationBarHidden=YES;
    self.window.rootViewController = nav;
    
    //jjy
    [TKHttpRequest ShareCache];
    [DataBase clearOrderMenu];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //判断程序是否是第一次安装运行
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次如果是加载用户帮助文件
       // [[UIApplication sharedApplication]setStatusBarHidden:YES];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"helpFileView" object:nil];
//        HelpViewController *hel0=[[HelpViewController alloc] init];
//        [self.viewController.navigationController pushViewController:hel0 animated:YES];
        
    }
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
      
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  [[NSNotificationCenter defaultCenter] postNotificationName:@"tapGesture" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
