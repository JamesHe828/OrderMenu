//
//  SearchViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-11.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "SearchViewController.h"
#import "ASIHTTPRequest.h"
#import "NSString+JsonString.h"
#import "Reachability.h"
#import "SearchResultViewController.h"
#import "MyActivceView.h"
#import "TKHttpRequest.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize ary,searcharry;
@synthesize seatchStr;
@synthesize alab;
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
    aSearchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 41)];
    aSearchBar.delegate=self;
    aSearchBar.placeholder=@"请输入您想去的餐馆名";
    [self.view addSubview:aSearchBar];
    UIView *segment=[aSearchBar.subviews objectAtIndex:0];
    [segment removeFromSuperview];
    aSearchBar.backgroundColor=[UIColor whiteColor];
    aSearchBar.tintColor=[UIColor orangeColor];
    
    
    //表
    resultTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44+41, 320, [UIScreen mainScreen].bounds.size.height-44-41) style:UITableViewStylePlain];
    resultTableView.delegate=self;
    resultTableView.dataSource=self;
    [self.view addSubview:resultTableView];
    
    alab=[[UILabel alloc] initWithFrame:CGRectMake(120, 20, 200, 50)];
    alab.backgroundColor=[UIColor clearColor];
    [resultTableView addSubview:alab];
    
    self.ary=[NSMutableArray arrayWithCapacity:0];
    self.searcharry=[[NSArray alloc] init];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.ary = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"historyAry"]];
   // NSLog(@"self.array = %@",ary);
    
    if ([ary count] != 0)
    {
        alab.text=nil;
    }
  
    // 按时间排序
    self.searcharry = [self.ary sortedArrayUsingComparator:^(id obj1, id obj2)
                            
                            
                            {
                                
                                
                                NSComparisonResult result = [obj1 compare:obj2];
                                
                                
                                switch(result)
                                {
                                    case NSOrderedAscending:
                                        return NSOrderedDescending;
                                    case NSOrderedDescending:
                                        return NSOrderedAscending;
                                    case NSOrderedSame:
                                        return NSOrderedSame;
                                    default:
                                        return NSOrderedSame;
                                } // 时间从近到远（远近相对当前时间而言）
                                
                                
                            }];
    NSLog(@"sortedArray  %@",searcharry);
      [resultTableView reloadData];
    [super viewWillAppear:animated];
}
#pragma mark ------ tableview delegate
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.searcharry count]==0)
    {
        alab.text=@"无搜索记录";
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searcharry count];
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
    }
    cell.textLabel.text=[self.searcharry objectAtIndex:indexPath.row];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    self.seatchStr=[self.searcharry objectAtIndex:indexPath.row];
    [self resultViewController];
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
////   UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
////    [aView addSubview:aSearchBar];
//    return aSearchBar;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UILabel *aLab2=[[UILabel alloc] initWithFrame:CGRectMake(90, 5, 160, 30)];
    aLab2.textAlignment=NSTextAlignmentCenter;
    if ([self.searcharry count]!= 0)
    {
        aLab2.text=@"清空历史记录";
    }
    else
    {
        aLab2.text=@"";
    }
    
    aLab2.baselineAdjustment=UIBaselineAdjustmentAlignBaselines;
    aLab2.backgroundColor=[UIColor clearColor];
    [aView addSubview:aLab2];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(52, 10, 250, 50);
    [btn addTarget:self action:@selector(delegateData) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:btn];
    return aView;
}
//滑动删除
////要求委托方的编辑风格在表视图的一个特定的位置。
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
//    if ([tableView isEqual:resultTableView]) {
//        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
//    }
//    return result;
//}
//-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
//    [super setEditing:editing animated:animated];
//    [resultTableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
//}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
//    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
//        if (indexPath.row<[self.searcharry count]) {
//            [self.searcharry removeObjectAtIndex:indexPath.row];//移除数据源的数据
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
//            [[NSUserDefaults standardUserDefaults] setObject:self.searcharry forKey:@"historyAry"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//    }
//}
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
    //NSLog(@"searchBarTextDidBeginEditing");
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
   // NSLog(@"searchBarShouldEndEditing");
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
   // NSLog(@"searchBarTextDidEndEditing");
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
    [self.ary addObject:searchBar.text];
    self.seatchStr=searchBar.text;
    [searchBar resignFirstResponder];
    [self resultViewController];
    searchBar.text=nil;
    [[NSUserDefaults standardUserDefaults] setObject:self.ary forKey:@"historyAry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
}
#pragma mark ----
-(void)delegateData
{
    self.ary = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"historyAry"]];
    [self.ary removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:self.ary forKey:@"historyAry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.searcharry=[[NSArray alloc] init];
//    self.ary=[NSMutableArray arrayWithCapacity:0];
    [resultTableView reloadData];
}
-(void)resultViewController
{
    if ([self isconnectok])
    {
        [self searchRequest];
        [MyActivceView startAnimatedInView:self.view];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }

}
-(void)searchRequest
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl: @"http://interface.hcgjzs.com/OM_Interface/Restaurant.asmx"];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <ListForSearch xmlns=\"http://tempuri.org/\">\
                       <key>%@</key>\
                       </ListForSearch>\
                       </soap:Body>\
                       </soap:Envelope>",self.seatchStr];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/ListForSearch"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    request.delegate=self;
    [request startAsynchronous];
}
#pragma mark - asihttprequest
- (void)requestStarted:(ASIHTTPRequest *)request
{
  //  NSLog(@"请求开始");
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
   // NSLog(@"----->>%@",request.responseString);
    //解析
    //    SBJSON  *sbJson=[[SBJSON alloc] init];
    //    NSDictionary *dic=[sbJson objectWithString:request.responseString error:nil];
    //    NSString *nameStr=[dic objectForKey:@""];
    //NSArray *ary2=[NSString ConverfromData:request.responseData name:@"ListForSearch"];
   // NSLog(@"______------%@",ary2);
    //searchReslutVC.ary=ary2;
    [MyActivceView stopAnimatedInView:self.view];
    searchReslutVC=[[SearchResultViewController alloc] init];
    searchReslutVC.ary=[NSString ConverfromData:request.responseData name:@"ListForSearch"];
    [self.navigationController pushViewController:searchReslutVC animated:YES];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//网络判断
-(Boolean)isconnectok{
    NSURL *url1 = [NSURL URLWithString:@"http://www.tiankong360.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
    if (response == nil) {
        return false;
    }
    else{
        //通了之后再判断连接类型
        Reachability *r = [Reachability reachabilityForInternetConnection];
        //        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        switch ([r currentReachabilityStatus]) {
            case ReachableViaWWAN:
                //                [userDefaults setObject:@"1" forKey:@"DownLoad"];
                return true;
                // break;
            case ReachableViaWiFi:
                //                [userDefaults setObject:@"0" forKey:@"DownLoad"];
                return true;
                // break;
        }
        return true;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
