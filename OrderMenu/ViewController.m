//
//  ViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "DetailViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize pageC;
@synthesize aTableView;
@synthesize numberStr;
@synthesize searchVC;
@synthesize searchAry;
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"导航"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame=CGRectMake(0, 0, 60, 60);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(leftVCClick) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=[UIColor whiteColor];
    //搜索栏
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 41)];
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
//    searchBar.showsCancelButton=YES;
    for( id cc in [searchBar subviews]){
        if([cc isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
//    for (UIButton *cc in [searchBar subviews])
//    {
//        [cc setTitle:@"取消" forState:UIControlStateNormal];
//    }
    UIView *segment=[searchBar.subviews objectAtIndex:0];
    [segment removeFromSuperview];
    searchBar.backgroundColor=[UIColor whiteColor];
   // 
    searchBar.tintColor=[UIColor orangeColor];
//	[searchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"按餐馆查询",@"按菜品查询",nil]];
    searchBar.placeholder=@"请输入餐馆名或者菜品名";
    searchAry=[[NSMutableArray alloc] initWithCapacity:0];
    //养生图片
	ascrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+41, 320, 132)];
    [self.view addSubview:ascrollview];
    ascrollview.pagingEnabled=YES;
    ascrollview.showsHorizontalScrollIndicator=NO;
    ascrollview.delegate=self;
    ascrollview.contentSize=CGSizeMake(320*5, 132);
    for (int i = 0 ; i<5; i++) {
        UIImageView *aImage = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 132)];
        aImage.userInteractionEnabled = YES;
//         aImage.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:212.0/255.0 blue:217.0/255.0 alpha:1];
        aImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"最佳推荐%d",i+1]];
        [ascrollview addSubview:aImage];
        
    }
    for (int j=0; j<5; j++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(320*j, 0, 320, 132);
        [btn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
        [ascrollview addSubview:btn];
    }
    pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(120,126+44+41-14+10, 100, 10)];
    pageC.numberOfPages = 5;
    pageC.currentPage=0;
    [self.view addSubview:pageC];
    
    self.navigationItem.title=@"美食推荐";
    self.navigationController.navigationBar.tintColor=[UIColor orangeColor];
    self.navigationController.navigationBar.hidden=YES;
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,146+44+41-14, 320, [UIScreen mainScreen].bounds.size.height - 146-44-41) style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    //[aTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:aTableView];
    self.aTableView.backgroundColor=[UIColor clearColor];
    ary=[[NSArray alloc] initWithObjects:@"a.jpg",@"b.jpg",@"c.jpg",@"d.jpg",@"e.jpg",@"f.jpg",@"f.jpg",@"f.jpg",@"f.jpg",@"f.jpg", nil];
    nameAry=[[NSArray alloc] initWithObjects:@"汉丽轩",@"金汉斯",@"徐同泰",@"阳光小餐厅",@"卷凉皮",@"河南天空",@"aaa",@"bbb",@"111",@"000", nil];
    addressAry=[[NSArray alloc] initWithObjects:@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西", nil];
}
-(void)leftVCClick
{
    NSLog(@"---------");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLeftVC" object:nil];
}
-(void)detailClick:(id)sender
{
//    DetailViewController *detailVC=[[DetailViewController alloc] init];
//    [self.navigationController pushViewController:detailVC animated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_NO" object:nil];
   
}
-(void)viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_YES" object:nil];
    [super viewWillAppear:animated];
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [ary count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //记载xib相当于创建了xib当中的内容，返回的数组里面包含了xib当中的对象
        // NSLog(@"新创建的cell  %d",indexPath.row);
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
		
        for (NSObject *object in array)
        {
            //判断数组中的对象是不是CustomCell 类型的
            if([object isKindOfClass:[CustomCell class]])
            {
                //如果是，赋给cell指针
                cell = (CustomCell *)object;
                //找到之后不再寻找
                break;
            }
        }
    }
    //右边小箭头
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imag.image=[UIImage imageNamed:[ary objectAtIndex:indexPath.row]];
    cell.lab.text=[nameAry objectAtIndex:indexPath.row];
    cell.lab.font = [UIFont fontWithName:@"Arial" size:17.0f];
    cell.lab.textColor=[UIColor colorWithRed:255.0/255.0 green:137.0/255.0 blue:3.0/255.0 alpha:1.0];
    cell.lab2.textColor=[UIColor grayColor];
    cell.lab2.text=[addressAry objectAtIndex:indexPath.row];
    cell.renjunLab.text=@"人均 ￥50";
    cell.renjunLab.textColor=[UIColor grayColor];
    cell.timeLab.textColor=[UIColor grayColor];
    cell.timeLab.text=@"0371-88888815";
    numberStr=cell.timeLab.text;
    [cell.abtn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bbtn addTarget:self action:@selector(callNum:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 66;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [self detailClick:nil];
  //  [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
}
#pragma mark - - searchbar delegate
//-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
//{
//   	//清空查询结果表
//	[searchAry removeAllObjects];
//    for (NSString *str in nameAry)
//    {
//        //截取str字符串[searchText length]长，然后和searchText进行比较，如果相等，就取出来
//        NSComparisonResult result=[str compare:searchText
//                                                        options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
//                                                          range:NSMakeRange(0, [searchText length])];
//        if (result==NSOrderedSame) 
//        {
//            [searchAry addObject:str];
//        }
//
//    }
//}
//- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
//{
//    tableView.frame = CGRectMake(0, 44+41, 320, [UIScreen mainScreen].bounds.size.height-44-41);
//}
////输入框中字符串改变
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    NSLog(@"+++++++");
//	[self filterContentForSearchText:searchString scope:[[self.searchVC.searchBar scopeButtonTitles] objectAtIndex:[self.searchVC.searchBar selectedScopeButtonIndex]]];
//    return YES;
//}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    searchBar.showsCancelButton=YES;
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
	[searchAry removeAllObjects];
    for (NSString *str in nameAry)
    {
        //截取str字符串[searchText length]长，然后和searchText进行比较，如果相等，就取出来
        NSComparisonResult result=[str compare:searchBar.text
                                       options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                         range:NSMakeRange(0, [searchBar.text length])];
        if (result==NSOrderedSame)
        {
            [searchAry addObject:str];
            NSLog(@"%@",searchAry);
        }
        
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    NSLog(@"textDidChange");
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClickedv");
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
}
//打电话
-(void)callNum:(id)sender
{
    UIWebView *callPhoneWebVw = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numberStr]]];
    NSLog(@"%@",numberStr);
    [callPhoneWebVw loadRequest:request];
    [self.view addSubview:callPhoneWebVw];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numberStr]]];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView==ascrollview)
    {
        int page2=ascrollview.contentOffset.x/320;
        self.pageC.currentPage=page2;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
