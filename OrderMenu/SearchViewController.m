//
//  SearchViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-11.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize ary;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"搜索"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame=CGRectMake(0, 0, 60, 60);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    //搜索栏
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 41)];
    searchBar.delegate=self;
    searchBar.placeholder=@"请输入您想去的餐馆名";
    [self.view addSubview:searchBar];
    UIView *segment=[searchBar.subviews objectAtIndex:0];
    [segment removeFromSuperview];
    searchBar.backgroundColor=[UIColor whiteColor];
    searchBar.tintColor=[UIColor orangeColor];
    
    
    //表
    UITableView *resultTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44+41, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    resultTableView.delegate=self;
    resultTableView.dataSource=self;
    resultTableView.scrollEnabled=NO;
    [self.view addSubview:resultTableView];
 
    ary=[[NSArray alloc] initWithObjects:@"糖醋里脊",@"红烧牛肉",@"水煮鱼",@"咖啡",@"柠檬",@"八宝粥", nil];
    
}
#pragma mark ------ tableview delegate
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ary count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sss=@"历史搜索";
    return sss;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //右边小箭头
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//单元格的选择风格，选择时单元格不出现蓝条
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=[ary objectAtIndex:indexPath.row];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self resultViewController];
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UILabel *aLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 5, 160, 30)];
    aLab.textAlignment=NSTextAlignmentCenter;
    aLab.text=@"清空历史记录";
    aLab.baselineAdjustment=UIBaselineAdjustmentAlignBaselines;
    aLab.backgroundColor=[UIColor clearColor];
    [aView addSubview:aLab];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(52, 10, 250, 50);
    [btn addTarget:self action:@selector(delegateData) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:btn];
    return aView;
}
# pragma mark - --- searchbar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
        searchBar.showsCancelButton=YES;
    for( id cc in [searchBar subviews]){
        if([cc isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    //
    //    resultTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320,[UIScreen mainScreen].bounds.size.height-41-44) style:UITableViewStylePlain];
    ////    resultTableView.delegate=self;
    ////    resultTableView.dataSource=self;
    //    [self.view addSubview:resultTableView];
    //    [UIView animateWithDuration:.3 animations:^{
    //        resultTableView.frame=CGRectMake(0, 44+41, 320,[UIScreen mainScreen].bounds.size.height-41-44);
    //    }];
    
    
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing");
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldEndEditing");
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidEndEditing");
    //清空查询结果表
//	[searchAry removeAllObjects];
//    for (NSString *str in nameAry)
//    {
//        //截取str字符串[searchText length]长，然后和searchText进行比较，如果相等，就取出来
//        NSComparisonResult result=[str compare:searchBar.text
//                                       options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
//                                         range:NSMakeRange(0, [searchBar.text length])];
//        if (result==NSOrderedSame)
//        {
//            [searchAry addObject:str];
//            NSLog(@"%@",searchAry);
//        }
//        
//    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //    NSLog(@"textDidChange");
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClickedv");
    [searchBar resignFirstResponder];
    [self resultViewController];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
}
#pragma mark ----
-(void)delegateData
{
    NSLog(@"+++++++++>>>>");
}
-(void)resultViewController
{
    SearchResultViewController *searchReslutVC=[[SearchResultViewController alloc] init];
    [self.navigationController pushViewController:searchReslutVC animated:YES];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
