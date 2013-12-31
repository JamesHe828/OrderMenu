//
//  ThirdChangeViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-12-26.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "ThirdChangeViewController.h"
#import "SearchViewController.h"
#import "TKHttpRequest.h"
#import "ASIHTTPRequest.h"
#import "CustomCell.h"
#import "DataBase.h"
#import "DetailViewController.h"
#import "MoreClassfyViewController.h"
#import "UIScrollView+SpiralPullToRefresh.h"
#import "EateryListViewController.h"
#import "Chain_EateryViewController.h"
@interface ThirdChangeViewController ()

@property (nonatomic, strong) NSTimer *workTimer;

@end
@interface ThirdChangeViewController ()

@end

@implementation ThirdChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"第三次导航.png"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    aBtn.showsTouchWhenHighlighted=YES;
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(320-49, 0, 44, 44);
    searchBtn.showsTouchWhenHighlighted=YES;
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden = YES;
    NSArray *abtnImageAry=[NSArray arrayWithObjects:@"外卖.png",@"火锅.png",@"小吃快餐.png",@"自助.png", nil];
    NSArray *cImmgeAry=[NSArray arrayWithObjects:@"西餐.png",@"酒店.png",@"咖啡酒吧.png",@"更多分类.png", nil];
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-44-50)];
//    scrollView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.alpha=0;
    
    [self.view addSubview:scrollView];
    for (int i=0; i<4; i++)
    {
        UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        aBtn.frame=CGRectMake(80*i, 0, 80,82);
        [aBtn setBackgroundImage:[UIImage imageNamed:[abtnImageAry objectAtIndex:i]] forState:UIControlStateNormal];
        aBtn.tag=i+100;
        [aBtn addTarget:self action:@selector(aBtn_click:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:aBtn];
        UIButton *bBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        bBtn.frame=CGRectMake(80*i, 82, 80,82);
        [bBtn setImage:[UIImage imageNamed:[cImmgeAry objectAtIndex:i]] forState:UIControlStateNormal];
        bBtn.tag=i+200;
        [bBtn addTarget:self action:@selector(bBtn_click:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:bBtn];
    }
    ary=[[NSArray alloc] init];
    [self getAdsListRequest];
    //下拉刷新
    __typeof (&*self) __weak weakSelf = self;
    
    [scrollView addPullToRefreshWithActionHandler:^ {
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf refreshTriggered];
        });
    }];
    scrollView.pullToRefreshController.waitingAnimation = SpiralPullToRefreshWaitAnimationCircular;
}
#pragma mark -----pull---
- (void)refreshTriggered
{
    [self statTodoSomething];
}
- (void)statTodoSomething
{
    
    [self.workTimer invalidate];
    
    self.workTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onAllworkDoneTimer) userInfo:nil repeats:NO];
}
- (void)onAllworkDoneTimer {
    [self.workTimer invalidate];
    self.workTimer = nil;
    [scrollView.pullToRefreshController didFinishRefresh];
}
#pragma mark --Btn_click_event
-(void)aBtn_click:(id)sender
{
    UIButton *aBtn=(UIButton *)sender;
    EateryListViewController *eateryVC=[[EateryListViewController alloc] init];
    switch (aBtn.tag)
    {
       
        case 100:
        {
            eateryVC.classID=0;
            eateryVC.titleLabStr=@"外卖";
        }
            break;
        case 101:
        {
            eateryVC.classID=62;
             eateryVC.titleLabStr=@"火锅";
        }
            break;
        case 102:
        {
            eateryVC.classID=63;
             eateryVC.titleLabStr=@"小吃快餐";
        }
            break;
        case 103:
        {
            eateryVC.classID=64;
             eateryVC.titleLabStr=@"自助";

        }
            break;

        default:
            break;
    }
    eateryVC.hideStr=@"show";
    eateryVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:eateryVC animated:YES];
}
-(void)bBtn_click:(id)sender
{
    UIButton *bBtn=(UIButton *)sender;
     EateryListViewController *eateryVC=[[EateryListViewController alloc] init];
    eateryVC.hideStr=@"show";
    switch (bBtn.tag)
    {
        case 200:
        {
            eateryVC.classID=5;
            eateryVC.titleLabStr=@"西餐";
            eateryVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:eateryVC animated:YES];
        }
            break;
        case 201:
        {
            eateryVC.classID=65;
            eateryVC.titleLabStr=@"酒店";
            eateryVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:eateryVC animated:YES];
        }
            break;
        case 202:
        {
              eateryVC.classID=66;
             eateryVC.titleLabStr=@"咖啡酒吧";
            eateryVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:eateryVC animated:YES];
        }
            break;
        case 203:
        {
                MoreClassfyViewController *moreVC=[[MoreClassfyViewController alloc] init];
                moreVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:moreVC animated:YES];
        }
            break;
        default:
            break;
    }


}
-(void)aImageBtn_click:(id)sender
{
//    NSLog(@"点击");
    UIButton *aBtn=(UIButton *)sender;
    DetailViewController *detailVC=[[DetailViewController alloc] init];
    detailVC.hideStr=@"show";
    detailVC.pID=[[guanggaoAry objectAtIndex:aBtn.tag-1000] valueForKey:@"ResId"];
    detailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)searchClick
{
    SearchViewController *searchVC2=[[SearchViewController alloc] init];
    searchVC2.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchVC2 animated:YES];

}
#pragma mark --request delegate
-(void)getAdsListRequest
{
    [MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/ads.asmx?op=GetAdsList",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <GetAdsList xmlns=\"http://tempuri.org/\">\
                       <num>%d</num>\
                       </GetAdsList>\
                       </soap:Body>\
                       </soap:Envelope>",4];
    request.tag=001;
    [request addRequestHeader:@"Host" value:Domain_Name];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetAdsList"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    request.delegate=self;
    [request startAsynchronous];
}
-(void)getResListRequest
{
    //[MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/Restaurant.asmx?op=getFirstRest3",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <getFirstRest3 xmlns=\"http://tempuri.org/\">\
                       <pageIndex>%d</pageIndex>\
                       </getFirstRest3>\
                       </soap:Body>\
                       </soap:Envelope>",1];
    request.tag=002;
    [request addRequestHeader:@"Host" value:Domain_Name];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/getFirstRest3"];
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
    if (request.tag==001)
    {
        
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"GetAdsList"];
        guanggaoAry=[[NSArray alloc] init];
        guanggaoAry=resultAry;
        NSLog(@"res  %@",guanggaoAry);
        for (int p=0; p<[resultAry count]; p++)
        {
            UIImageView *aImage=[[UIImageView alloc] initWithFrame:CGRectMake(8+p%2*156, 82*2+8+p/2*68, 148, 60)];
            [aImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",Domain_Name,[[resultAry objectAtIndex:p] valueForKey:@"ImgUrl"]]] placeholderImage:[UIImage imageNamed:@"A.png"]];
            [scrollView addSubview:aImage];
            UIButton *aImageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            aImageBtn.frame=CGRectMake(8+p%2*156, 82*2+8+p/2*68, 148, 60);
            [aImageBtn addTarget:self action:@selector(aImageBtn_click:) forControlEvents:UIControlEventTouchUpInside];
            aImageBtn.tag=p+1000;
            [scrollView addSubview:aImageBtn];
        }
        [self getResListRequest];
    }
    if (request.tag==002)
    {
        [MyActivceView stopAnimatedInView:self.view];
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"getFirstRest3"];
        ary=[resultAry valueForKey:@"Restaurant"];
        aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 82*2+8+guanggaoAry.count/2*68+68+5, 320,83*[ary count]+22) style:UITableViewStylePlain];
        aTableView.delegate=self;
        aTableView.dataSource=self;
        aTableView.scrollEnabled=NO;
        [scrollView addSubview:aTableView];
        
        scrollView.alpha=1;
        scrollView.contentSize=CGSizeMake(320,[UIScreen mainScreen].bounds.size.height-44-50+83*[ary count]);
    }

}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
   // [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
    if (request.tag==001)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"网络状态不佳,点击确定继续请求数据" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self getAdsListRequest];
    }
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
    
//    p=indexPath.row;
//    //    NSLog(@"++++++++resInfoArr = %@",[ary objectAtIndex:indexPath.row]);
//    //    NSLog(@"%@",[[ary objectAtIndex:indexPath.row]valueForKey:@"LinkID"]);
    NSString *linkID=[[ary objectAtIndex:indexPath.row]valueForKey:@"LinkID"];
    if ([linkID intValue]==-1)
    {
        DetailViewController *detailVC=[[DetailViewController alloc] init];
        detailVC.hideStr=@"show";
        //detailVC.hide=@"show";
        detailVC.resInfoArr = [ary objectAtIndex:indexPath.row];
        detailVC.pID=[[ary objectAtIndex:indexPath.row]valueForKey:@"id"];
        detailVC.hidesBottomBarWhenPushed=YES;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    aView.backgroundColor=[UIColor whiteColor];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
    titleLab.backgroundColor=[UIColor clearColor];
    titleLab.text=@"最佳推荐";
    [aView addSubview:titleLab];
    UIImageView *aImge=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    aImge.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [aView addSubview:aImge];
    UIImageView *bImge=[[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 320, 1)];
    bImge.backgroundColor=[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0];
    [aView addSubview:bImge];
    return aView;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    aView.backgroundColor=[UIColor whiteColor];
//    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    titleLab.backgroundColor=[UIColor clearColor];
//    titleLab.text=@"查看更多";
//    titleLab.textAlignment=NSTextAlignmentCenter;
//    [aView addSubview:titleLab];
//    UIButton *bottomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    bottomBtn.frame=CGRectMake(0, 0, 320, 30);
//    [bottomBtn addTarget:self action:@selector(more_btnClick) forControlEvents:UIControlEventTouchUpInside];
//    [aView addSubview:bottomBtn];
//    UIImageView *aImge=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    aImge.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [aView addSubview:aImge];
//    UIImageView *bImge=[[UIImageView alloc] initWithFrame:CGRectMake(0, 29, 320, 1)];
//    bImge.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [aView addSubview:bImge];
//    return aView;
//}
-(void)more_btnClick
{
    MoreClassfyViewController *moreVC=[[MoreClassfyViewController alloc] init];
    moreVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:moreVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
