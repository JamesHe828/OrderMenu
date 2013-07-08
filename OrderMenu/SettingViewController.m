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
//    self.navigationController.navigationBar.hidden=YES;
    // Do any additional setup after loading the view from its nib.
    //手势
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    UIImageView *aImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    aImage.backgroundColor=[UIColor grayColor];
    [self.view addSubview:aImage];
    
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 120, 300, [UIScreen mainScreen].bounds.size.height - 120 -20)style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    [self.view addSubview:aTableView];
    ary=[[NSArray alloc] initWithObjects:@"收藏",@"向好友推荐",@"使用版本",@"关于",@"使用帮助",@"用户反馈", nil];
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
        ShareViewController *shareVC=[[ShareViewController alloc] init];
        [self.navigationController pushViewController:shareVC animated:YES];
    }
    if (indexPath.row==2)
    {
        VersionViewController *versionVC=[[VersionViewController alloc] init];
        [self.navigationController pushViewController:versionVC animated:YES];
    }
    if (indexPath.row==3)
    {
        AboutViewController *aboutVC=[[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    if (indexPath.row==4)
    {
        HelpViewController *helpVC=[[HelpViewController alloc] init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
    if (indexPath.row==5)
    {
        FeedbackViewController *feedbackVC=[[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
