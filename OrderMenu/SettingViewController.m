//
//  SettingViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "SettingViewController.h"
#import "CustomCell.h"
#import "CollectViewController.h"
#import "ShareViewController.h"
#import "VersionViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "FeedbackViewController.h"
#import "MyIndentViewController.h"
#import "OrderListViewController.h"
#import "AppDelegate.h"
#import "ErWeiMaViewController.h"
#import "ShakeViewController.h"
#import "AppDelegate.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.window.clipsToBounds =YES;
//        
//        NSLog(@"=====%f=======",delegate.window.frame.size.height);
//        if (IPhone5)
//        {
//            delegate.window.bounds = CGRectMake(0, 0, 320, 548);
//            delegate.window.frame =  CGRectMake(0,20,320,548);
//        }
//        else
//        {
//            delegate.window.bounds = CGRectMake(0, 0, 320, 460);
//            delegate.window.frame =  CGRectMake(0,20,320,460);
//        }
//        
//    }

    
    self.navigationItem.title=@"设置";
    self.navigationController.navigationBar.tintColor=[UIColor orangeColor];
    self.navigationController.navigationBar.hidden=YES;

    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aView.backgroundColor=[UIColor colorWithRed:252.0/255.0 green:33.0/255.0 blue:47.0/255.0 alpha:1.0];
    [self.view addSubview:aView];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
    titleLab.backgroundColor=[UIColor clearColor];
    titleLab.textColor=[UIColor whiteColor];
    titleLab.text=@"更多分类";
    titleLab.textAlignment=NSTextAlignmentCenter;
    [aView addSubview:titleLab];
    
//    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    aBtn.frame=CGRectMake(0, 0, 44, 44);
//    [self.view addSubview:aBtn];
//    aBtn.showsTouchWhenHighlighted=YES;
//    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    //手势
//    UISwipeGestureRecognizer *recognizer;
//    
//    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [[self view] addGestureRecognizer:recognizer];
//    
//    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [[self view] addGestureRecognizer:recognizer];
    
    UIImageView *aImage=[[UIImageView alloc] initWithFrame:CGRectMake(45, 44+16, 228, 72)];
    aImage.backgroundColor=[UIColor clearColor];
    aImage.image=[UIImage imageNamed:@"为您"];
//    aImage.center=CGPointMake(160, 44+36);
    [self.view addSubview:aImage];
    UIScrollView *acroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 104+44, 320, [UIScreen mainScreen].bounds.size.height-104-44-50)];
    acroll.backgroundColor=[UIColor clearColor];
    acroll.contentSize=CGSizeMake(300, [UIScreen mainScreen].bounds.size.height-104-50);
    [self.view addSubview:acroll];
        ary=[[NSArray alloc] initWithObjects:@"摇出美味",@"关于我们",@"意见反馈",@"检查更新",@"好友推荐",@"评价一下", nil];
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 44*[ary count])style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
     aTableView.scrollEnabled=NO;
    [acroll addSubview:aTableView];

}
//手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        //NSLog(@"swipe left");
        //执行程序
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchGesture" object:nil];
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        //        NSLog(@"swipe right");
        //执行程序
    }
    
}
#pragma mark ----tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [ary count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //右边小箭头
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor=[UIColor grayColor];
    cell.textLabel.text=[ary objectAtIndex:indexPath.row];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];

//    if (indexPath.row==0)
//    {
//        OrderListViewController * orderList;
//        if (IPhone5)
//        {
//            orderList = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:nil];
//        }
//        else
//        {
//            orderList = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController4" bundle:nil];
//        }
////        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////        [delegate.ddmenuControler showRootController:YES];
////        [delegate.AllNav pushViewController:orderList animated:YES];
//        [self.navigationController pushViewController:orderList animated:YES];
//    }
//    if (indexPath.row==1)
//    {
//        CollectViewController *collectVC=[[CollectViewController alloc] init];
//        [self.navigationController pushViewController:collectVC animated:YES];
//    }
    if (indexPath.row==0)
    {
        ShakeViewController *shakeVC=[[ShakeViewController alloc] init];
        shakeVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:shakeVC animated:YES];
    }
    if (indexPath.row==1)
    {
        AboutViewController *aboutVC=[[AboutViewController alloc] init];
        aboutVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:aboutVC animated:YES];

    }
    if (indexPath.row==2)
    {
        FeedbackViewController *feedbackVC=[[FeedbackViewController alloc] init];
        feedbackVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:feedbackVC animated:YES];
//        [UMFeedback showFeedback:self withAppkey:@"51dccb0456240b7f87001d5e"];
    }
    if (indexPath.row==3)
    {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/dian-mei-dian/id678946071?ls=1&mt=8"];
        [[UIApplication sharedApplication]openURL:url];
    }
    if (indexPath.row==4)
    {
        ShareViewController *shareVC=[[ShareViewController alloc] init];
        shareVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:shareVC animated:YES];
    }
    if (indexPath.row==5)
    {
        NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",678946071];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
-(void)helpView
{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchGesture" object:nil];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell

forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // NSInteger realRow = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
    NSInteger realRow =[self realRowNumberForIndexPath:indexPath inTableView:tableView];
    cell.backgroundColor = (realRow%2)?[UIColor whiteColor]:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    
}
- (NSInteger)realRowNumberForIndexPath:(NSIndexPath *)indexPath

                           inTableView:(UITableView *)tableView
{
    
//    NSInteger retInt = 0;
//    
//    if (!indexPath.section) {
//        
//        return indexPath.row;
//        
//    }
//    
//    for (int i=0; i<indexPath.section;i++) {
//        
//        retInt += [tableView numberOfRowsInSection:i];
//        
//    }
//    
//    return retInt + indexPath.row;
    return indexPath.row;
}
-(void)backClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchGesture" object:nil];
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
