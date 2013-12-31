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
#import "EateryViewController.h"
#import "SearchViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ThirdChangeViewController.h"
#import "CollectViewController.h"
#import "OrderListViewController.h"
#import "OtherLocationViewController.h"
#import "LeveyTabBarController.h"
#import "DispalayMapViewController.h"
@implementation AppDelegate
@synthesize ddmenuControler;
@synthesize AllNav;
@synthesize leveyTabBarController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // [UMSocialData setAppKey:@"51dccb0456240b7f87001d5e"];
    [MobClick startWithAppkey:@"51dccb0456240b7f87001d5e"];
    [MobClick checkUpdate];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //微信
    [WXApi registerApp:@"wxd5d809494e8c8bf3"];
 // [UIApplication sharedApplication].statusBarHidden = YES;
//    //jjy code
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
           [application setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"ios7"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"ios7Login"];
    
    
    
//    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    EateryViewController *eateryVC=[[EateryViewController alloc] initWithNibName:@"EateryViewController" bundle:nil];
    SettingViewController *setVC=[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
//    SearchViewController *searchVC=[[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
//    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:eateryVC];
    nav_set=[[UINavigationController alloc] initWithRootViewController:setVC];
    nav_set.delegate=self;
//    UINavigationController *nav_searchVC=[[UINavigationController alloc] initWithRootViewController:searchVC];
//*****************************************third***3.0.0*******************************************
    //third change
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageNamed:@"Tab_首页.png"] forKey:@"Default"];
	[imgDic setObject:[UIImage imageNamed:@"Tab_首页红.png"] forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageNamed:@"Tab_首页红.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:@"Tab_位置.png"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:@"Tab_位置红.png"] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:@"Tab_位置红.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:@"Tab_收藏.png"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:@"Tab_收藏红.png"] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:@"Tab_收藏红.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageNamed:@"Tab_订单.png"] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:@"Tab_订单红.png"] forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageNamed:@"Tab_订单红.png"] forKey:@"Seleted"];
   	NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic5 setObject:[UIImage imageNamed:@"Tab_更多.png"] forKey:@"Default"];
	[imgDic5 setObject:[UIImage imageNamed:@"Tab_更多红.png"] forKey:@"Highlighted"];
	[imgDic5 setObject:[UIImage imageNamed:@"Tab_更多红.png"] forKey:@"Seleted"];
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic4,imgDic3,imgDic5,nil];
    OrderListViewController * orderList;
    if (IPhone5)
    {
        orderList = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:nil];
    }
    else
    {
        orderList = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController4" bundle:nil];
    }
    nav_orderList=[[UINavigationController alloc] initWithRootViewController:orderList];
    nav_orderList.delegate=self;
    CollectViewController *clloectVC=[[CollectViewController alloc] init];
    nav_collect=[[UINavigationController alloc] initWithRootViewController:clloectVC];
    nav_collect.delegate=self;
    DispalayMapViewController * mapVC;
    if (IPhone5)
    {
        mapVC=[[DispalayMapViewController alloc] initWithNibName:@"DispalayMapViewController" bundle:nil];
    }
    else
    {
        mapVC=[[DispalayMapViewController alloc] initWithNibName:@"DispalayMapViewController4" bundle:nil];
    }
    mapVC.isOtherLocation = NO;
    nav_map=[[UINavigationController alloc] initWithRootViewController:mapVC];
    nav_map.delegate=self;
    
    ThirdChangeViewController *thirdVC=[[ThirdChangeViewController alloc] init];
    nav_third=[[UINavigationController alloc] initWithRootViewController:thirdVC];
    nav_third.delegate=self;
//    ddmenuControler=[[DDMenuController alloc] initWithRootViewController:nav];
//    ddmenuControler.leftViewController=nav_set;
//    ddmenuControler.rightViewController=nav_searchVC;
     NSArray *ctrlArr = [NSArray arrayWithObjects:nav_third,nav_map,nav_orderList,nav_collect,nav_set,nil];
	leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
    leveyTabBarController.view.frame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height+30);
	[leveyTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"下导航.png"]];

	[leveyTabBarController setTabBarTransparent:[[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?YES:NO];
    self.window.rootViewController=leveyTabBarController;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBotomBar) name:@"showBotomBar" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBotmoBar) name:@"hideBotomBar" object:nil];
    [self showBotomBar];
//*************************************************************************************************

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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        
    }
    
    //jjy code
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:REST_STATUS];
    
    MKMapView * mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    mapView.showsUserLocation = YES;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if (navigationController==nav_third)
//    {
//        if (viewController.hidesBottomBarWhenPushed)
//        {
//            [leveyTabBarController hidesTabBar:YES animated:YES];
//        }
//        else
//        {
//            [leveyTabBarController hidesTabBar:NO animated:YES];
//        }
//    }
//    else
//    {
        if (viewController.hidesBottomBarWhenPushed)
        {
            [leveyTabBarController hidesTabBar:YES animated:YES];
        }
//    }
//    if (navigationController==nav_set||navigationController==nav_collect)
//    {
////         [leveyTabBarController hidesTabBar:YES animated:YES];
//        if (viewController.hidesBottomBarWhenPushed)
//        {
//            [leveyTabBarController hidesTabBar:YES animated:YES];
//        }
//    }


}
-(void)hideBotmoBar
{
    [leveyTabBarController hidesTabBar:YES animated:NO];
}
-(void)showBotomBar
{
    NSLog(@"-=-= 执行了吗");
    [leveyTabBarController hidesTabBar:NO animated:YES];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
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
