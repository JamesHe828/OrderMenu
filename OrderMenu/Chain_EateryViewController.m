//
//  Chain_EateryViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-9-25.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "Chain_EateryViewController.h"
#import "CustomCell.h"
#import "DetailViewController.h"
#import "TKHttpRequest.h"
#import <QuartzCore/QuartzCore.h>
@interface Chain_EateryViewController ()

@end

@implementation Chain_EateryViewController
@synthesize pID;
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
    aImageView.image=[UIImage imageNamed:@"餐厅列表导航"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    aBtn.showsTouchWhenHighlighted=YES;
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, [UIScreen mainScreen].bounds.size.height-44-20) style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    [self.view addSubview:aTableView];
    ary=[[NSArray alloc] init];
    [self restaurantListRequest];
}
-(void)restaurantListRequest
{
    [MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/Restaurant.asmx?op=ListForSearch",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <ListForSearch xmlns=\"http://tempuri.org/\">\
                       <key>%@</key>\
                       <RestaurantID>%@</RestaurantID>\
                       </ListForSearch>\
                       </soap:Body>\
                       </soap:Envelope>",@"",self.pID];
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
    [MyActivceView stopAnimatedInView:self.view];
    if (request.tag==0000)
    {
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"ListForSearch"];
        ary=resultAry;
        NSLog(@"000%@",resultAry);
        [aTableView reloadData];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
    [MyAlert ShowAlertMessage:@"网速不给力啊！" title:@"温馨提醒"];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lab.font = [UIFont fontWithName:@"Arial" size:18.0f];
    cell.lab.textColor=[UIColor blackColor];
    cell.lab2.textColor=[UIColor grayColor];
    cell.renjunLab.textColor=[UIColor grayColor];
    cell.timeLab.textColor=[UIColor grayColor];
//    numberStr=cell.timeLab.text;
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
    
    //jjy code
    [[NSUserDefaults standardUserDefaults] setValue:[[ary objectAtIndex:indexPath.row] valueForKey:@"status"] forKey:REST_STATUS];
    int p;
    p=indexPath.row;
    DetailViewController *detailVC=[[DetailViewController alloc] init];
    detailVC.hideStr=@"hide";
    detailVC.resInfoArr = [ary objectAtIndex:indexPath.row];
    detailVC.pID=[[ary objectAtIndex:p]valueForKey:@"id"];;
    [self.navigationController pushViewController:detailVC animated:YES];
    //点击 蓝色慢慢消失
    [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
    
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
