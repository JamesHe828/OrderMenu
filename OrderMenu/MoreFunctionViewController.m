//
//  MoreFunctionViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "MoreFunctionViewController.h"
#import "SearchViewController.h"
#import "MapViewController.h"
@interface MoreFunctionViewController ()

@end

@implementation MoreFunctionViewController
@synthesize _array;

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
   // NSLog(@"right");
    [aTableView reloadData];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden=YES;
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"11"];
    [self.view addSubview:aImageView];
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
    lab.backgroundColor=[UIColor clearColor];
    lab.text=@"分类搜索";
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:16.0];
    lab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.showsTouchWhenHighlighted=YES;
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(back_Click) forControlEvents:UIControlEventTouchUpInside];
    _array=[[NSMutableArray alloc] initWithObjects:[[NSArray alloc]initWithObjects:@"二七区",@"金水区",@"中原区",@"惠济区",@"管城回族区",@"郑东新区",@"荥阳市",@"上街区",@"新郑市",@"新密市",@"中牟县",@"巩义市", nil],
            [[NSArray alloc]initWithObjects:@"川菜",@"粤菜",@"鲁菜",@"豫菜",@"湘菜",@"浙菜",@"苏菜",@"闽菜",@"徽菜", nil],
            [[NSArray alloc]initWithObjects:@"列表形式",@"地图形式",nil],
            [[NSArray alloc]initWithObjects:nil],nil];
    //手势
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height - 44 -20)style:UITableViewStyleGrouped];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    [self.view addSubview:aTableView];
    ary=[[NSArray alloc] initWithObjects:@"按地区搜索",@"按菜系搜索",@"按位置搜索",@"关键字搜索",nil];
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchGesture" object:nil];
    }
    
}
# pragma mark - tableview 
//返回分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self._array count];
}
// 返回每个分区的行的个数,启始返回0，点啥返回相应的分区的行的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//根据flag数组所对应的布尔值为真就返回正确的行数
	//如果flag数组所应对的布尔值为假就返回0
	NSInteger ns=[self numberOfRowsInSection2:section];
	return ns;
}
//返回每个分区的行数，根据flag数组对应的布尔值返回
- (int)numberOfRowsInSection2:(NSInteger)section
{
	
	if (flag[section])
    {//如果某个分区对应的布尔值是真，则给相应分区制定行数
		return [[self._array objectAtIndex:section] count];
	}
	else
	{
		return 0;
	}
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
    NSString *aStr=[[self._array objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text=aStr;
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2)
    {
        if (indexPath.row==1)
        {
            MapViewController *mapVC=[[MapViewController alloc] init];
            [self.navigationController pushViewController:mapVC animated:YES];
        }
    }
   // [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 320, 44);
    [btn setTitle:[ary objectAtIndex:section] forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor blackColor];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [aview  addSubview:btn];
    [tableView addSubview:aview];
    btn.tag=section;
    return aview;
}
-(void)click:(id)sender
{
    UIButton *aBtn=(UIButton *)sender;
    if (aBtn.tag==3)
    {
        SearchViewController *searVC=[[SearchViewController alloc] init];
        [self.navigationController pushViewController:searVC animated:YES];
    }
    flag[aBtn.tag]= !flag[aBtn.tag];
    //[_tableView reloadData];
    NSIndexSet *set=[NSIndexSet indexSetWithIndex:aBtn.tag];
    [aTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}
-(void)back_Click
{
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchGesture" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
