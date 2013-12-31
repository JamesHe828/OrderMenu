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
#import "iflyMSC/IFlyUserWords.h"
#import "AppDelegate.h"
#define IPHONE_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
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
    self.navigationController.navigationBar.hidden=YES;
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"搜索"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    aBtn.showsTouchWhenHighlighted=YES;
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    //搜索栏
    aSearchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320-42, 41)];
    aSearchBar.delegate=self;
    aSearchBar.placeholder=@"请输入您想去的餐馆名";
    [self.view addSubview:aSearchBar];
    aSearchBar.barStyle=UIBarStyleDefault;
    if (IPHONE_IOS7)
    {
        
    }
    else
    {
        UIView *segment=[aSearchBar.subviews objectAtIndex:0];
        [segment removeFromSuperview];
        
    }
    aSearchBar.backgroundColor=[UIColor whiteColor];
    aSearchBar.tintColor=[UIColor colorWithRed:252.0/255.0 green:33.0/255.0 blue:47.0/255.0 alpha:1.0];
    //aSearchBar.tintColor=[UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:212.0/255.0 alpha:1.0];
    
    //[aSearchBar becomeFirstResponder];
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
    //手势
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
//    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [[self view] addGestureRecognizer:recognizer];
    //语音云
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID ];
    _iFlyRecognizerView = [[IFlyRecognizerView alloc] initWithOrigin:CGPointMake(15, 60) initParam:initString];
    _iFlyRecognizerView.delegate = self;
    [self onLogin:nil];
    
    _uploader = [[IFlyDataUploader alloc] initWithDelegate:nil pwd:nil params:nil delegate:self];
    UIButton *voiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //voiceBtn.showsTouchWhenHighlighted=YES;
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"语音"] forState:UIControlStateNormal];
    voiceBtn.frame=CGRectMake(320-42, 46, 35, 35);
    [self.view addSubview:voiceBtn];
    [voiceBtn addTarget:self action:@selector(voiceBtn_Click) forControlEvents:UIControlEventTouchUpInside];
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
    //searchBar.showsCancelButton=YES;
    if (IPHONE_IOS7)
    {

    }
    else{
        for( id cc in [searchBar subviews]){
            if([cc isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
            }
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
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
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
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/Restaurant.asmx?op=ListForSearch",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <ListForSearch xmlns=\"http://tempuri.org/\">\
                       <key>%@</key>\
                       <RestaurantID>%@</RestaurantID>\
                       </ListForSearch>\
                       </soap:Body>\
                       </soap:Envelope>",self.seatchStr,@""];
    [request addRequestHeader:@"Host" value:Domain_Name];
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
    NSLog(@"-==-=- %@",searchReslutVC.ary);
    [self.navigationController pushViewController:searchReslutVC animated:YES];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}
-(void)backClick
{
//    [aSearchBar resignFirstResponder];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchGesture" object:nil];
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app showBotomBar];
    [self.navigationController popViewControllerAnimated:YES];
}
//网络判断
-(Boolean)isconnectok{
    NSURL *url1 = [NSURL URLWithString:@"http://www.baidu.com"];
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
#pragma mark ---voice ---
-(void)voiceBtn_Click
{
    [aSearchBar resignFirstResponder];
    [_iFlyRecognizerView setParameter:@"grammarID" value:_grammarID];
    
    // 参数设置
    [_iFlyRecognizerView setParameter:@"domain" value:_ent];
    [_iFlyRecognizerView setParameter:@"sample_rate" value:@"16000"];
    [_iFlyRecognizerView setParameter:@"vad_eos" value:@"1800"];
    [_iFlyRecognizerView setParameter:@"vad_bos" value:@"6000"];
    [_iFlyRecognizerView start];
}
-(void) onLogin:(id) sender
{
    if (![IFlySpeechUser isLogin]) {
        
        //        _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"正在登录" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        //        [_alertView show];
        
        // 需要先登录
        IFlySpeechUser *loginUser = [[IFlySpeechUser alloc] initWithDelegate:self];
        
        // user 和 pwd 都传入nil时表示是匿名登录
        NSString *loginString = [[NSString alloc] initWithFormat:@"appid=%@",APPID];
        [loginUser login:nil pwd:nil param:loginString];
        // [loginString release];
    }
    else {
        //        _alertView = [[UIAlertView alloc] initWithTitle:@"已登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [_alertView show];
    }
}
//
- (void) onUpload:(id)sender
{
    //    _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"正在上传" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    //    [_alertView show];
    
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:USERWORDS];
    [_uploader uploadData:NAME params:PARAMS data:[iFlyUserWords toString]];
}
- (void) onEnd:(IFlySpeechUser *)iFlySpeechUser error:(IFlySpeechError *)error
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (![error errorCode]) {
        //        _alertView = [[UIAlertView alloc] initWithTitle:@"登录成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [_alertView show];
        [self onUpload:nil];
    }
    else {
        //        _alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:[error errorDesc] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [_alertView show];
        
    }
}
//
- (void) onEnd:(IFlyDataUploader*) uploader grammerID:(NSString *)grammerID error:(IFlySpeechError *)error
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    
    NSLog(@"%d",[error errorCode]);
    
    if (![error errorCode]) {
        //        _alertView = [[UIAlertView alloc] initWithTitle:@"上传成功" message:grammerID delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [_alertView show];
    }
    else {
        //        _alertView = [[UIAlertView alloc] initWithTitle:@"上传失败" message:[error errorDesc] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [_alertView show];
    }
}

- (void) onResult:(IFlyRecognizerView *)iFlyRecognizerView theResult:(NSArray *)resultArray
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@(置信度:%@)\n",key,[dic objectForKey:key]];
        NSLog(@"%@",key);
        aSearchBar.text= [key substringWithRange:NSMakeRange(0, key.length-1)];
        [aSearchBar becomeFirstResponder];
    }
}
- (void)onEnd:(IFlyRecognizerView *)iFlyRecognizerView theError:(IFlySpeechError *) error
{
    NSLog(@"recognizer end");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
