//
//  Near_ListViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-11-23.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "Near_ListViewController.h"
#import "CustomCell.h"
#import "TKHttpRequest.h"
#import "DetailViewController.h"
#import "DispalayMapViewController.h"
#import "AppDelegate.h"
#import "Chain_EateryViewController.h"
@interface Near_ListViewController ()

@end

@implementation Near_ListViewController
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
    aImageView.image=[UIImage imageNamed:@"11.png"];
    [self.view addSubview:aImageView];
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
    lab.backgroundColor=[UIColor clearColor];
    lab.text=@"附近餐馆";
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:16.0];
    lab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.showsTouchWhenHighlighted=YES;
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(back_Click) forControlEvents:UIControlEventTouchUpInside];
    //定位
//   locationManager = [[CLLocationManager alloc] init];
//   locationManager.delegate = self;
//   locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//   locationManager.distanceFilter = 1000.0f;
//   [locationManager startUpdatingLocation];
//    
//    NSLog(@"===%d",[CLLocationManager authorizationStatus]);
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
//    {
//        [MyAlert ShowAlertMessage:@"没有开启定位。" title:@"提示"];
//    }
//    
//    //地图
//    mapView=[[MKMapView alloc] init];
//    mapView.mapType =MKMapTypeStandard;
//    mapView.showsUserLocation=YES;
//    mapView.delegate=self;
//    //mapView.userLocation.title=@"您的位置";
//    mapView.frame=CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-44);
//    //[self.view addSubview:mapView];
    
    //地图显示
//    UIButton *mapButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    mapButton.showsTouchWhenHighlighted=YES;
//    mapButton.frame=CGRectMake(276, 0, 44, 44);
//    //mapButton.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:mapButton];
//    [mapButton addTarget:self action:@selector(listMap:) forControlEvents:UIControlEventTouchUpInside];

    
//    ary=[[NSMutableArray alloc] init];
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, [UIScreen mainScreen].bounds.size.height-44-20) style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    [self.view addSubview:aTableView];
    
    
}
-(void)listMap:(NSMutableArray *)aList
{
    if (ary.count>0)
    {
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
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    else
    {
        [MyAlert ShowAlertMessage:@"当前位置附近没有餐馆。" title:@"提示"];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *str1= [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *str2 = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    NSLog(@"str1== %@,str2==%@",str1,str2);
    [manager stopUpdatingLocation];
    if ([str1 isEqualToString:@""])
    {
        [MyAlert ShowAlertMessage:@"请打开定位服务" title:@"温馨提醒"];
    }
    else
    {
        [self restaurantListRequest:str1 longitude:str2];
    }
    
}
-(void)restaurantListRequest:(NSString *)latitude longitude:(NSString *)longitude
{
   
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
     [MyActivceView startAnimatedInView:self.view];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
    if (request.tag==0000)
    {
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"getRestListByLL"];
        ary=[NSMutableArray arrayWithArray:resultAry];
        [self.view addSubview:aTableView];
        [aTableView reloadData];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
    [MyAlert ShowAlertMessage:@"网速不给力啊" title:@"温馨提醒"];
}
-(void)back_Click
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBotomBar" object:nil];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app showBotomBar];
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *linkID=[[ary objectAtIndex:indexPath.row]valueForKey:@"LinkID"];

   if ([linkID intValue]==-1)
    {
            DetailViewController *detailVC=[[DetailViewController alloc] init];
            detailVC.hideStr=@"hide";
            detailVC.resInfoArr = [ary objectAtIndex:indexPath.row];
            detailVC.pID=[[ary objectAtIndex:indexPath.row]valueForKey:@"id"];
            [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        Chain_EateryViewController *chainVC=[[Chain_EateryViewController alloc] init];
        chainVC.pID=[[ary objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:chainVC animated:YES];
    }
    //点击 蓝色慢慢消失
    [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
