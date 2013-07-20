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
#import "UMFeedback.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"left");
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"设置";
    self.navigationController.navigationBar.tintColor=[UIColor orangeColor];
    self.navigationController.navigationBar.hidden=YES;
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"设置导航"];
    [self.view addSubview:aImageView];
    // Do any additional setup after loading the view from its nib.
    //手势
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    UIImageView *aImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 104)];
    aImage.backgroundColor=[UIColor grayColor];
    aImage.image=[UIImage imageNamed:@"为您图"];
    [self.view addSubview:aImage];
    
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 104+44, 300, 44*7)style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
     aTableView.scrollEnabled=NO;
    [self.view addSubview:aTableView];
    ary=[[NSArray alloc] initWithObjects:@"我的收藏",@"我的订单",@"关于我们",@"使用帮助",@"意见反馈",@"检查更新",@"好友推荐", nil];
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
		//单元格的选择风格，选择时单元格不出现蓝条
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textColor=[UIColor grayColor];
    cell.textLabel.text=[ary objectAtIndex:indexPath.row];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
    if (indexPath.row==0)
    {
        CollectViewController *collectVC=[[CollectViewController alloc] init];
        [self.navigationController pushViewController:collectVC animated:YES];
    }
    if (indexPath.row==1)
    {
        MyIndentViewController *myindentVC=[[MyIndentViewController alloc] init];
        [self.navigationController pushViewController:myindentVC animated:YES];

    }
    if (indexPath.row==2)
    {
        AboutViewController *aboutVC=[[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];

    }
    if (indexPath.row==3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"helpFileView" object:nil];
        [self performSelector:@selector(helpView) withObject:nil afterDelay:0];
        
         
    }
    if (indexPath.row==4)
    {
        FeedbackViewController *feedbackVC=[[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
//        [UMFeedback showFeedback:self withAppkey:@"51dccb0456240b7f87001d5e"];
    }
    if (indexPath.row==5)
    {
//        VersionViewController *versionVC=[[VersionViewController alloc] init];
//        [self.navigationController pushViewController:versionVC animated:YES];
        UIAlertView *aLertView=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"您使用的是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aLertView show];
    }
    if (indexPath.row==6)
    {
        ShareViewController *shareVC=[[ShareViewController alloc] init];
        [self.navigationController pushViewController:shareVC animated:YES];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
