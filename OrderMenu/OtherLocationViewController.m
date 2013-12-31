//
//  OtherLocationViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-11-26.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "OtherLocationViewController.h"
#import "NSString+JsonString.h"
#import "ASIHTTPRequest.h"
#import "TKHttpRequest.h"
#import "DetailViewController.h"
#import "CustomCell.h"
#import "DispalayMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "iflyMSC/IFlyUserWords.h"
#import "AppDelegate.h"

#define IPHONE_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
@interface OtherLocationViewController ()
{
    NSDictionary * dicLocation;
}
-(void)listMap:(NSMutableArray *)aList;
@end

@implementation OtherLocationViewController

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
    aImageView.image=[UIImage imageNamed:@"map11.png"];
    [self.view addSubview:aImageView];
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
    lab.backgroundColor=[UIColor clearColor];
    lab.text=@"搜索位置";
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:16.0];
    lab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.showsTouchWhenHighlighted=YES;
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(back_Click) forControlEvents:UIControlEventTouchUpInside];
    
    //地图显示
    UIButton *mapButton=[UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.showsTouchWhenHighlighted=YES;
    mapButton.frame=CGRectMake(276, 0, 44, 44);
    //mapButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:mapButton];
    [mapButton addTarget:self action:@selector(listMap:) forControlEvents:UIControlEventTouchUpInside];
    
    //搜索栏
    aSearchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320-42, 41)];
    aSearchBar.delegate=self;
    aSearchBar.placeholder=@"请输入您想去的道路名称";
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
    //[aSearchBar becomeFirstResponder];
    ary=[[NSMutableArray alloc] init];
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,44+41, 320, [UIScreen mainScreen].bounds.size.height-44-20-41) style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    [self.view addSubview:aTableView];
    
    alab=[[UILabel alloc] initWithFrame:CGRectMake(60, 2, 200, 50)];
    alab.backgroundColor=[UIColor clearColor];
    alab.textAlignment=NSTextAlignmentCenter;
    [aTableView addSubview:alab];
    
    //语音云
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID ];
    _iFlyRecognizerView = [[IFlyRecognizerView alloc] initWithOrigin:CGPointMake(15, 60) initParam:initString];
    _iFlyRecognizerView.delegate = self;
    [self onLogin:nil];
    
    _uploader = [[IFlyDataUploader alloc] initWithDelegate:nil pwd:nil params:nil delegate:self];
    UIButton *voiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //voiceBtn.showsTouchWhenHighlighted=YES;
//    [voiceBtn setBackgroundColor:[UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:212.0/255.0 alpha:1.0]];
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"语音"] forState:UIControlStateNormal];
    voiceBtn.frame=CGRectMake(320-42, 46, 35, 35);
    [self.view addSubview:voiceBtn];
    [voiceBtn addTarget:self action:@selector(voiceBtn_Click) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillAppear:(BOOL)animated
{
    [aTableView reloadData];
    [super viewWillAppear:animated];
}
# pragma mark - --- searchbar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
//    searchBar.showsCancelButton=YES;
//    searchBar.showsScopeBar=YES;
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

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //    NSLog(@"textDidChange");
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSDictionary *dic= [NSString getLatAndLongitToAdress:searchBar.text];
    dicLocation = [NSDictionary dictionaryWithDictionary:dic];
    NSLog(@"dic  %@",dic);
    NSString *longStr=[dic objectForKey:@"lng"];
    NSString *latStr=[dic objectForKey:@"lat"];
    [self restaurantListRequest:latStr longitude:longStr];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(void)restaurantListRequest:(NSString *)latitude longitude:(NSString *)longitude
{
    [MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/Restaurant.asmx?op=getRestListByLL",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <getRestListByLL xmlns=\"http://tempuri.org/\">\
                       <longitude>%@</longitude>\
                       <latitude>%@</latitude>\
                       </getRestListByLL>\
                       </soap:Body>\
                       </soap:Envelope>",longitude,latitude];
    request.tag=0000;
    [request addRequestHeader:@"Host" value:Domain_Name];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/getRestListByLL"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    request.delegate=self;
    [request startAsynchronous];
}
#pragma mark - asihttprequest
- (void)requestStarted:(ASIHTTPRequest *)request
{
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
    if (request.tag==0000)
    {
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"getRestListByLL"];
        ary=[NSMutableArray arrayWithArray:resultAry];
//        [self.view addSubview:aTableView];
        [aTableView reloadData];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
    [MyAlert ShowAlertMessage:@"网速不给力啊" title:@"温馨提醒"];
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([ary count]==0)
    {
        alab.text=@"没有餐馆信息";
    }
    else
    {
        alab.text=nil;
    }
	return [ary count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // static NSString *CellIdentifier;
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    
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
    cell.aimage.hidden=YES;
    UILabel *distanceLab=[[UILabel alloc] initWithFrame:CGRectMake(260, 25, 60, 30)];
    distanceLab.backgroundColor=[UIColor clearColor];
    distanceLab.text=[NSString stringWithFormat:@"%@m",[[ary objectAtIndex:indexPath.row] valueForKey:@"Distance"]];
    distanceLab.textColor=[UIColor colorWithRed:251.0/255.0 green:33.0/255.0 blue:47.0/255.0 alpha:1.0];
    [cell addSubview:distanceLab];
    //cell.textLabel.text=[ary objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lab.font = [UIFont fontWithName:@"Arial" size:18.0f];
    cell.lab.textColor=[UIColor blackColor];
    cell.lab2.textColor=[UIColor grayColor];
    cell.renjunLab.textColor=[UIColor grayColor];
    cell.timeLab.textColor=[UIColor grayColor];
    // numberStr=cell.timeLab.text;
    cell.lab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"restname"];
    [cell.imag setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",Domain_Name,[[ary objectAtIndex:indexPath.row] valueForKey:@"restimg"]]] placeholderImage:[UIImage imageNamed:@"加载中"]];
    cell.imag.layer.borderColor=[[UIColor grayColor] CGColor];
    cell.imag.layer.borderWidth=1;
    cell.lab2.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"restaddress"];
    cell.timeLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"restphone"];
    cell.renjunLab.text=[NSString stringWithFormat:@"人均￥%@",[[ary objectAtIndex:indexPath.row] valueForKey:@"restaverage"]];
    cell.jiamengLab.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:199.0/255.0 blue:188.0/255.0 alpha:1.0];
    cell.dazheLab.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:233.0/255.0 blue:214.0/255.0 alpha:1.0];
    cell.waimaiLab.backgroundColor=[UIColor colorWithRed:220.0/255.0 green:241.0/255.0 blue:255.0/255.0 alpha:1.0];
    cell.huodongLab.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:249.0/255.0 blue:205.0/255.0 alpha:1.0];
    cell.liansuoLab.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:216.0/255.0 blue:252.0/255.0 alpha:1.0];
    cell.jiamengLab.textColor=[UIColor grayColor];
    cell.jiamengLab.textAlignment=NSTextAlignmentCenter;
    cell.dazheLab.textColor=[UIColor grayColor];
    cell.dazheLab.textAlignment=NSTextAlignmentCenter;
    cell.waimaiLab.textColor=[UIColor grayColor];
    cell.waimaiLab.textAlignment=NSTextAlignmentCenter;
    cell.huodongLab.textColor=[UIColor grayColor];
    cell.huodongLab.textAlignment=NSTextAlignmentCenter;
    cell.liansuoLab.text=@"连锁";
    cell.liansuoLab.textColor=[UIColor grayColor];
    cell.liansuoLab.textAlignment=NSTextAlignmentCenter;
    //标签
    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"status"]intValue]==1)
    {
        cell.jiamengLab.text=@"加盟";
        if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"DiscountMark"] isEqualToString:@""])
        {
            cell.dazheLab.hidden=YES;
            if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"CarryoutTime"] isEqualToString:@""])
            {
                cell.waimaiLab.hidden=YES;
                
                if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"] isEqualToString:@""])
                {
                    cell.huodongLab.hidden=YES;
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(113, 61, 45, 21);
                    }
                }
                else
                {
                    cell.huodongLab.frame=CGRectMake(113, 61, 45, 21);
                    cell.huodongLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"];
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(165, 61, 45, 21);
                    }
                }
            }
            else
            {
                cell.waimaiLab.frame=CGRectMake(113, 61, 45, 21);
                cell.waimaiLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"CarryoutTime"];
                if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"] isEqualToString:@""]) {
                    cell.huodongLab.hidden=YES;
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(165, 61, 45, 21);
                    }
                }
                else
                {
                    cell.huodongLab.frame=CGRectMake(165, 61, 45, 21);
                    cell.huodongLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"];
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(217, 61, 45, 21);
                    }
                }
            }
        }
        else
        {
            cell.dazheLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"DiscountMark"];
            if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"CarryoutTime"] isEqualToString:@""])
            {
                cell.waimaiLab.hidden=YES;
                if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"] isEqualToString:@""]) {
                    cell.huodongLab.hidden=YES;
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(165, 61, 45, 21);
                    }
                }
                else
                {
                    cell.huodongLab.frame=CGRectMake(165, 61, 45, 21);
                    cell.huodongLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"];
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(217, 61, 45, 21);
                    }
                }
            }
            else
            {
                cell.waimaiLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"CarryoutTime"];
                if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"] isEqualToString:@""]) {
                    cell.huodongLab.hidden=YES;
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(217, 61, 45, 21);
                    }
                }
                else
                {
                    cell.huodongLab.frame=CGRectMake(217, 61, 45, 21);
                    cell.huodongLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"];
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                }
            }
        }
    }
    else
    {
        cell.jiamengLab.hidden=YES;
        if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"DiscountMark"] isEqualToString:@""])
        {
            cell.dazheLab.hidden=YES;
            if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"CarryoutTime"] isEqualToString:@""])
            {
                cell.waimaiLab.hidden=YES;
                if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"] isEqualToString:@""]) {
                    cell.huodongLab.hidden=YES;
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(66, 61, 45, 21);
                    }
                }
                else
                {
                    cell.huodongLab.frame=CGRectMake(66, 61, 45, 21);
                    cell.huodongLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"];
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(113, 61, 45, 21);
                    }
                }
            }
            else
            {
                cell.waimaiLab.frame=CGRectMake(66, 61, 45, 21);
                cell.waimaiLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"CarryoutTime"];
                if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"] isEqualToString:@""]) {
                    cell.huodongLab.hidden=YES;
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(113, 61, 45, 21);
                    }
                }
                else
                {
                    cell.huodongLab.frame=CGRectMake(113, 61, 45, 21);
                    cell.huodongLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"];
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(165, 61, 45, 21);
                    }
                }
            }
        }
        else
        {
            cell.dazheLab.frame=CGRectMake(66, 61, 45, 21);
            cell.dazheLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"DiscountMark"];
            if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"CarryoutTime"] isEqualToString:@""])
            {
                cell.waimaiLab.hidden=YES;
                if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"] isEqualToString:@""])
                {
                    cell.huodongLab.hidden=YES;
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(113, 61, 45, 21);
                    }
                }
                else
                {
                    cell.huodongLab.frame=CGRectMake(113, 61, 45, 21);
                    cell.huodongLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"];
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(165, 61, 45, 21);
                    }
                }
            }
            else
            {
                cell.waimaiLab.frame=CGRectMake(113, 61, 45, 21);
                cell.waimaiLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"CarryoutTime"];
                if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"] isEqualToString:@""]) {
                    cell.huodongLab.hidden=YES;
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(165, 61, 45, 21);
                    }
                }
                else
                {
                    cell.huodongLab.frame=CGRectMake(165, 61, 45, 21);
                    cell.huodongLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"Active"];
                    if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"LinkID"]intValue]==-1)
                    {
                        cell.liansuoLab.hidden=YES;
                    }
                    else
                    {
                        cell.liansuoLab.frame=CGRectMake(217, 61, 45, 21);
                    }
                }
            }
        }
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [DataBase clearOrderMenu];
    //
    //    //jjy code
    //    [[NSUserDefaults standardUserDefaults] setValue:[[ary objectAtIndex:indexPath.row] valueForKey:@"status"] forKey:REST_STATUS];
    //
    //    //    NSLog(@"++++++++resInfoArr = %@",[ary objectAtIndex:indexPath.row]);
    //    //    NSLog(@"%@",[[ary objectAtIndex:indexPath.row]valueForKey:@"LinkID"]);
    //    NSString *linkID=[[ary objectAtIndex:indexPath.row]valueForKey:@"LinkID"];
    //    if ([linkID intValue]==0)
    //    {
    //        Chain_EateryViewController *chainVC=[[Chain_EateryViewController alloc] init];
    //        chainVC.pID=[[ary objectAtIndex:p]valueForKey:@"id"];
    //        [self.navigationController pushViewController:chainVC animated:YES];
    //    }
    //    else if ([linkID intValue]==-1)
    //    {
    DetailViewController *detailVC=[[DetailViewController alloc] init];
    detailVC.resInfoArr = [ary objectAtIndex:indexPath.row];
    detailVC.pID=[[ary objectAtIndex:indexPath.row]valueForKey:@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
    //    }
    //点击 蓝色慢慢消失
    [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
    
}

-(void)back_Click
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app showBotomBar];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)listMap:(NSMutableArray *)aList
{
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [MyAlert ShowAlertMessage:@"没有开启定位。" title:@"提示"];
    }
    else
    {
        if (ary.count>0)
        {
            //把当前位置加上去
            NSMutableDictionary * dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic2 setValue:[NSString stringWithFormat:@"%g",[[dicLocation valueForKey:@"lat"] doubleValue]] forKey:@"Latitude"];
            [dic2 setValue:[NSString stringWithFormat:@"%g",[[dicLocation valueForKey:@"lng"] doubleValue]] forKey:@"Longitude"];
            [dic2 setValue:@"指定位置" forKey:@"restname"];
            
            NSMutableArray * arryTemp = [NSMutableArray arrayWithArray:ary];
            [arryTemp addObject:dic2];
            // [ary addObject:dic2];
            
            DispalayMapViewController * mapVC;
            if (IPhone5)
            {
                mapVC=[[DispalayMapViewController alloc] initWithNibName:@"DispalayMapViewController" bundle:nil];
            }
            else
            {
                mapVC=[[DispalayMapViewController alloc] initWithNibName:@"DispalayMapViewController4" bundle:nil];
            }
            mapVC.dataArr = arryTemp;
            [self.navigationController pushViewController:mapVC animated:YES];
        }
        else
        {
            [MyAlert ShowAlertMessage:@"指定位置附近没有餐馆。" title:@"提示"];
        }
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
