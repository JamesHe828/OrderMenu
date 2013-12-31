//
//  EateryViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-8-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "EateryViewController.h"
#import "CustomCell.h"
#import "SearchViewController.h"
#import "RefreshHeaderAndFooterView.h"
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "HelpViewController.h"
#import "NSString+JsonString.h"
#import "UIImageView+WebCache.h"
#import "MyActivceView.h"
#import "Reachability.h"
#import "DetailViewController.h"
#import "TKHttpRequest.h"
#import "DataBase.h"
#import "MyAlert.h"
#import "Chain_EateryViewController.h"
#import "MapViewController.h"
#import "Near_ListViewController.h"
#import "DispalayMapViewController.h"
#import "AppDelegate.h"
#import "OtherLocationViewController.h"

@interface EateryViewController ()<RefreshHeaderAndFooterViewDelegate,UIScrollViewDelegate>
{
    RefreshHeaderAndFooterView *heardview ;
}
@property(nonatomic,strong)RefreshHeaderAndFooterView * refreshHeaderAndFooterView;
@property(nonatomic,assign)BOOL reloading;
@end

@implementation EateryViewController
@synthesize refreshHeaderAndFooterView = _refreshHeaderAndFooterView;
@synthesize reloading = _reloading;
@synthesize pageC;
@synthesize aTableView;
@synthesize numberStr;
@synthesize searchAry;
@synthesize resultTableView;
@synthesize ascrollview;
@synthesize nameAry,styleAry;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"餐馆列表导航.png"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    aBtn.showsTouchWhenHighlighted=YES;
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(320-49, 0, 44, 44);
    searchBtn.showsTouchWhenHighlighted=YES;
    //[searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden = YES;
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,44+34, 320, [UIScreen mainScreen].bounds.size.height-44-20-34) style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
//    [self.view addSubview:aTableView];
    ary=[[NSMutableArray alloc] init];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailFileview:) name:@"detailViewC" object:nil];
    pageID=1;
    isAll=0;
    upOrClick=0;
   // [self reloadData2];
//    else
//    {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    //**********//
    //导航下方工具栏
    btn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame=CGRectMake(4, 46, 101, 30);
    [btn1 setTitle:@"地区" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(region_table) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    btn2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame=CGRectMake(101+4*2, 46, 101, 30);
    [btn2 setTitle:@"类别" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(style_table) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    btn3=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(near_table) forControlEvents:UIControlEventTouchUpInside];
    btn3.frame=CGRectMake(101*2+4*3, 46, 101, 30);
    [btn3 setTitle:@"查找" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    nameAry=[[NSMutableArray alloc] initWithObjects:@"全部", nil];
     styleAry=[[NSMutableArray alloc] initWithObjects:@"全部",nil];
    [self restaurantListRequest];
    [self get_style:@"1"];
    [self get_region:@"2"];
    departStr=@"0";
    typedStr=@"0";
   //检查网络连接
   // [self isconnectok];
}
//地区表
-(void)region_table
{
    
    if (regionid==0)
    {
        [self tap];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"红按钮.png"] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        up_view_region=[[UIView alloc] initWithFrame:CGRectMake(4, 46+30, 101, 0)];
        [up_view_region setClipsToBounds:YES];
        [self.view addSubview:up_view_region];
        for (int a = 0; a<[nameAry count]; a++)
        {
            aNameBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            aNameBtn.frame=CGRectMake(.5,30*a, 100, 30);
            aNameBtn.tag=a+2;
            [aNameBtn setTitle:[nameAry objectAtIndex:a]forState:UIControlStateNormal];
            [aNameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [aNameBtn addTarget:self action:@selector(region_table_click:) forControlEvents:UIControlEventTouchUpInside];
            [up_view_region addSubview:aNameBtn];
            [aNameBtn setBackgroundImage:[UIImage imageNamed:@"321123.png"] forState:UIControlStateNormal];
            
        }
        [UIView animateWithDuration:0.5 animations:^{
            up_view_region.frame=CGRectMake(4, 46+30, 101, 30*[nameAry count]);
        } completion:^(BOOL finished) {
            
        }];
        regionid=1;
        
    }
    else
    {
        [up_view_region removeFromSuperview];
        regionid=0;
        [btn1 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }

}
-(void)region_table_click:(id)sender
{
    //下拉列表是否出现
    regionid=0;
    //上拉刷新
    isAll=1;
    //分类选择变量
    pageID2=1;
    //是上拉 还是点击
    upOrClick=1;
    UIButton *regionBtn=(UIButton *)sender;
    [btn1 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn1 setTitle:[nameAry objectAtIndex:regionBtn.tag-2] forState:UIControlStateNormal];
    [up_view_region removeFromSuperview];
    [backview removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_YES" object:nil];
    //请求数据
     [ary removeAllObjects];
    if (regionBtn.tag==2)
    {
        departStr=@"0";
    }
    else
    {
        departStr=[[departAry objectAtIndex:regionBtn.tag-3] valueForKey:@"id"];

    }
     [heardview removeFromSuperview];
    [self region_style_ListRequest:departStr style:typedStr];
   
}
//菜系表
-(void)style_table
{
    if (styleid==0)
    {
        [self tap];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"红按钮.png"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        up_view_style=[[UIView alloc] initWithFrame:CGRectMake(101+4*2, 46+30, 101, 0)];
        [up_view_style setClipsToBounds:YES];
        [self.view addSubview:up_view_style];
        for (int a = 0; a<[styleAry count]; a++)
        {
            UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            aBtn.frame=CGRectMake(0.5,30*a, 100, 30);
            aBtn.tag=a+1;
            [aBtn setTitle:[styleAry objectAtIndex:a]forState:UIControlStateNormal];
            [aBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [aBtn addTarget:self action:@selector(style_table_click:) forControlEvents:UIControlEventTouchUpInside];
            [up_view_style addSubview:aBtn];
            [aBtn setBackgroundImage:[UIImage imageNamed:@"321123.png"] forState:UIControlStateNormal];
        }
        [UIView animateWithDuration:0.5 animations:^{
            up_view_style.frame=CGRectMake(101+4*2, 46+30, 101, 30*[styleAry count]);
        } completion:^(BOOL finished) {
            
        }];
        styleid=1;
        
    }
    
    else
    {
        [up_view_style removeFromSuperview];
        styleid=0;
        [btn2 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }

}
-(void)style_table_click:(id)sender
{
    styleid=0;
    pageID2=1;
    isAll=1;
    //是上拉 还是点击
    upOrClick=1;
    UIButton *abtn=(UIButton *)sender;
    [btn2 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn2 setTitle:[styleAry objectAtIndex:abtn.tag-1] forState:UIControlStateNormal];
    [up_view_style removeFromSuperview];
    [backview removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_YES" object:nil];
    //请求数据
     [ary removeAllObjects];
    if (abtn.tag==1)
    {
       typedStr=@"0";
    }
    else
    {
       typedStr=[[typedAry objectAtIndex:abtn.tag-2] valueForKey:@"id"];
    }
    [heardview removeFromSuperview];
    [self region_style_ListRequest:departStr style:typedStr];
}
//附近餐馆表
-(void)near_table
{
    if (nearid==0)
    {
        [self tap];
        [btn3 setBackgroundImage:[UIImage imageNamed:@"红按钮.png"] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSArray *nameAry2=[[NSArray alloc] initWithObjects:@"我的位置",@"其他位置", nil];
        up_view_near=[[UIView alloc] initWithFrame:CGRectMake(101*2+4*3, 46+30, 101, 0)];
        [up_view_near setClipsToBounds:YES];
        [self.view addSubview:up_view_near];
        for (int a = 0; a<2; a++)
        {
            UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            aBtn.frame=CGRectMake(0.5,30*a, 100, 30);
            aBtn.tag=a+1;
            [aBtn setTitle:[nameAry2 objectAtIndex:a]forState:UIControlStateNormal];
            [aBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [aBtn addTarget:self action:@selector(near_table_click:) forControlEvents:UIControlEventTouchUpInside];
            [up_view_near addSubview:aBtn];
            [aBtn setBackgroundImage:[UIImage imageNamed:@"321123.png"] forState:UIControlStateNormal];
        }
        [UIView animateWithDuration:0.5 animations:^{
            up_view_near.frame=CGRectMake(101*2+4*3, 46+30, 101, 30*2);
        } completion:^(BOOL finished) {
            
        }];
        nearid=1;
        
    }
    else
    {
        [up_view_near removeFromSuperview];
        nearid=0;
        [btn3 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }

}
-(void)near_table_click:(id)sender
{
    UIButton *nearBtn=(UIButton *)sender;
    switch (nearBtn.tag) {
        case 1://列表
        {
            Near_ListViewController *nearVC=[[Near_ListViewController alloc] init];
            [self.navigationController pushViewController:nearVC animated:YES];
        }
            break;
        case 2://地图
        {
            OtherLocationViewController *otherLocVC=[[OtherLocationViewController alloc] init];
            [self.navigationController pushViewController:otherLocVC animated:YES];
        }
            
            break;
        default:
            break;
    }
    nearid=0;
    [btn3 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [up_view_near removeFromSuperview];
    [backview removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_YES" object:nil];
}
-(void)tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_NO" object:nil];
    backview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    backview.backgroundColor=[UIColor clearColor];
    backview.alpha=1;
    backview.userInteractionEnabled=YES;
    [self.view addSubview:backview];
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
   // singleTapRecognizer.numberOfTapsRequired = 1; // 单击
    [backview addGestureRecognizer:singleRecognizer];
    UISwipeGestureRecognizer *swipe;
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeSingleTapFrom:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [backview addGestureRecognizer:swipe];
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeSingleTapFrom:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [backview addGestureRecognizer:swipe];
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeSingleTapFrom:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [backview addGestureRecognizer:swipe];
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeSingleTapFrom:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [backview addGestureRecognizer:swipe];

    
}
-(void)handleSingleTapFrom:(UITapGestureRecognizer *)recognizer
{
    [up_view_region removeFromSuperview];
    [up_view_style removeFromSuperview];
    [up_view_near removeFromSuperview];
    regionid=0;
    styleid=0;
    nearid=0;
    [btn1 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    backview.userInteractionEnabled=NO;
    [backview removeGestureRecognizer:recognizer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_YES" object:nil];
}
-(void)handleSwipeSingleTapFrom:(UISwipeGestureRecognizer *)recognizer
{
    [up_view_region removeFromSuperview];
    [up_view_style removeFromSuperview];
    [up_view_near removeFromSuperview];
    regionid=0;
    styleid=0;
    nearid=0;
    [btn1 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"白色按钮.png"] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    backview.userInteractionEnabled=NO;
    [backview removeGestureRecognizer:recognizer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_YES" object:nil];
}
//网络判断
-(Boolean)isconnectok
{
    NSURL *url1 = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
    if (response == nil)
    {
        [MyAlert ShowAlertMessage:@"无网络连接,请检查网络连接" title:@"温馨提醒"];
        return false;
    }
    else{
        [self restaurantListRequest];
        NSLog(@"有网络连接");
        //通了之后再判断连接类型
        Reachability *r = [Reachability reachabilityForInternetConnection];
        //        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        switch ([r currentReachabilityStatus])
        {
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
-(void)detailFileview:(NSNotification *)aNotification
{
    NSDictionary * dic = aNotification.userInfo;
    NSString * title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"key"]];
    DetailViewController *detailVC=[[DetailViewController alloc] init];
    detailVC.pID=title;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)reloadData2
{
//    if (heardview!=nil ||self.refreshHeaderAndFooterView!=nil) {
//        [heardview removeFromSuperview];
//        [self.refreshHeaderAndFooterView removeFromSuperview];
//    }
    heardview = [[RefreshHeaderAndFooterView alloc] initWithFrame:CGRectMake(0, 0, self.aTableView.frame.size.width, 0.000000)];
    heardview.delegate = self;
    self.refreshHeaderAndFooterView = heardview;
    [self.refreshHeaderAndFooterView.refreshHeaderView updateRefreshDate:[NSDate date]];
    self.reloading = NO;
    [self.refreshHeaderAndFooterView RefreshScrollViewDataSourceDidFinishedLoading:self.aTableView];
  
    
}
#pragma mark -
#pragma mark RefreshHeaderAndFooterViewDelegate Methods

- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView*)view
{
	self.reloading = YES;
    if (view.refreshHeaderView.state == PullRefreshLoading)
    {//下拉刷新动作的内容
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
//        [ary removeAllObjects];
//        [aTableView reloadData];
//        [heardview removeFromSuperview];
//        pageID=1;
//        [self performSelector:@selector(restaurantListRequest)];
        
    }
    else if(view.refreshFooterView.state == PullRefreshLoading){//上拉加载更多动作的内容
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
        if (isAll==0)
        {
            if ([page_ID intValue]==0)
            {
                pageID++;
                [heardview removeFromSuperview];
                [self.refreshHeaderAndFooterView removeFromSuperview];
                [self restaurantListRequest];
            }
            else
            {
                
            }
        }
        else if (isAll==1)
        {
            if ([page_ID2 intValue]==0)
            {
                pageID2++;
                [heardview removeFromSuperview];
                [self.refreshHeaderAndFooterView removeFromSuperview];
                [self region_style_ListRequest:departStr style:typedStr];
            }
            else
            {}
            upOrClick=0;
        }
    }
    
}
- (BOOL)RefreshHeaderAndFooterDataSourceIsLoading:(RefreshHeaderAndFooterView*)view
{
	
	return self.reloading; // should return if data source model is reloading
	
}
- (NSDate*)RefreshHeaderAndFooterDataSourceLastUpdated:(RefreshHeaderAndFooterView*)view
{
    return [NSDate date];
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView==ascrollview)
    {
        int page2=ascrollview.contentOffset.x/320;
        self.pageC.currentPage=page2;
    }
    else
    {
        [self.refreshHeaderAndFooterView RefreshScrollViewDidScroll:self.aTableView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshHeaderAndFooterView RefreshScrollViewDidEndDragging:self.aTableView];
}
-(void)doneLoadingTableViewData
{
    self.reloading = NO;
    [self.refreshHeaderAndFooterView RefreshScrollViewDataSourceDidFinishedLoading:self.aTableView];
    [self.aTableView reloadData];
}
//全部
-(void)restaurantListRequest
{
    [MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/Restaurant.asmx?op=getFirstRest",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <getFirstRest xmlns=\"http://tempuri.org/\">\
                       <pageIndex>%d</pageIndex>\
                       </getFirstRest>\
                       </soap:Body>\
                       </soap:Envelope>",pageID];
    //NSLog(@"pageID= %d",pageID);
    request.tag=0000;
    [request addRequestHeader:@"Host" value:Domain_Name];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/getFirstRest"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    request.delegate=self;
    [request startAsynchronous];
}
//获得地区
-(void)get_region:(NSString *)aStr
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/channel.asmx?op=GetList",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <GetList xmlns=\"http://tempuri.org/\">\
                       <parentid>%d</parentid>\
                       <kindid>%d</kindid>\
                       </GetList>\
                       </soap:Body>\
                       </soap:Envelope>",1,[aStr intValue]];
    request.tag=2222;
    [request addRequestHeader:@"Host" value:Domain_Name];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetList"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    request.delegate=self;
    [request startAsynchronous];
}
//获得菜系类别
-(void)get_style:(NSString *)aStr
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/channel.asmx?op=GetList",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <GetList xmlns=\"http://tempuri.org/\">\
                       <parentid>%d</parentid>\
                       <kindid>%d</kindid>\
                       </GetList>\
                       </soap:Body>\
                       </soap:Envelope>",1,[aStr intValue]];
    request.tag=3333;
    [request addRequestHeader:@"Host" value:Domain_Name];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetList"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    request.delegate=self;
    [request startAsynchronous];
}
//地区 菜系 分类搜索
-(void)region_style_ListRequest:(NSString *)region style:(NSString *)style
{
    [MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/Restaurant.asmx?op=getFirstRest2",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <getFirstRest2 xmlns=\"http://tempuri.org/\">\
                       <pageIndex>%d</pageIndex>\
                       <typeid>%d</typeid>\
                       <departid>%d</departid>\
                       </getFirstRest2>\
                       </soap:Body>\
                       </soap:Envelope>",pageID2,[style intValue],[region intValue]];
    request.tag=1111;
    [request addRequestHeader:@"Host" value:Domain_Name];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/getFirstRest2"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    request.delegate=self;
    [request startAsynchronous];
}
#pragma mark - asihttprequest
- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"请求开始");
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    if (request.tag==0000)
    {
        [MyActivceView stopAnimatedInView:self.view];
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"getFirstRest"];
        NSArray *pageIDary=[resultAry valueForKey:@"Page"];
        NSString *page=[[pageIDary objectAtIndex:0]valueForKey:@"islastPage"];
        page_ID=page;
        [ary addObjectsFromArray:[resultAry valueForKey:@"Restaurant"]];
        [self reloadData2];
        heardview.p=[ary count];
        [self.view addSubview:aTableView];
        [self.aTableView addSubview:heardview];
        [self.aTableView reloadData];
    }
    else if (request.tag==1111)
    {
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"getFirstRest2"];
        NSArray *pageIDary=[resultAry valueForKey:@"Page"];
        NSString *page=[[pageIDary objectAtIndex:0]valueForKey:@"islastPage"];
        page_ID2=page;
        [ary addObjectsFromArray:[resultAry valueForKey:@"Restaurant"]];
        [self reloadData2];
        heardview.p=[ary count];
        [self.aTableView addSubview:heardview];
        [self.aTableView reloadData];
        if ([ary count]!=0&&upOrClick==1)
        {
            [aTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
        [MyActivceView stopAnimatedInView:self.view];
    }
    else if (request.tag==2222)
    {
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"GetList"];
        departAry=resultAry;
        NSMutableArray *titleAry=[[NSMutableArray alloc] init];
        for (int i=0; i<[resultAry count]; i++)
        {
            [titleAry addObject:[[resultAry objectAtIndex:i] valueForKey:@"title"]];
        }
        [nameAry addObjectsFromArray:titleAry];
    }
    else if (request.tag==3333)
    {
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"GetList"];
        typedAry=resultAry;
        NSMutableArray *titleAry=[[NSMutableArray alloc] init];
        for (int i=0; i<[resultAry count]; i++)
        {
            [titleAry addObject:[[resultAry objectAtIndex:i] valueForKey:@"title"]];
        }
        [styleAry addObjectsFromArray:titleAry];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
    if (request.tag==0000)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"网络状态不佳,点击确定继续请求数据" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else if (request.tag==1111)
    {
        [MyAlert ShowAlertMessage:@"网络状态不佳" title:@"温馨提醒"];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   // NSLog(@"====  %ld",(long)buttonIndex);
    if (buttonIndex==0)
    {
        [self restaurantListRequest];
    }
}
#pragma mark -----------------
- (void)scrollScrollView:(NSTimer *)timer
{
    
    CGPoint newScrollViewContentOffset = self.ascrollview.contentOffset;
    
    //向上移动 1px
    newScrollViewContentOffset.x += 320;
    
    
    newScrollViewContentOffset.x = MAX(0, newScrollViewContentOffset.x);
    
    //如果到顶了，timer中止
    if (newScrollViewContentOffset.x == 320*5) {
        //        [timer invalidate];
        newScrollViewContentOffset.x = 0;
    }
    
    //最后设置scollView's contentOffset
    self.ascrollview.contentOffset = newScrollViewContentOffset;
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
    numberStr=cell.timeLab.text;
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
    [DataBase clearOrderMenu];
    
    //jjy code
    [[NSUserDefaults standardUserDefaults] setValue:[[ary objectAtIndex:indexPath.row] valueForKey:@"status"] forKey:REST_STATUS];
    
    p=indexPath.row;
//    NSLog(@"++++++++resInfoArr = %@",[ary objectAtIndex:indexPath.row]);
//    NSLog(@"%@",[[ary objectAtIndex:indexPath.row]valueForKey:@"LinkID"]);
    NSString *linkID=[[ary objectAtIndex:indexPath.row]valueForKey:@"LinkID"];
    if ([linkID intValue]==0)
    {
        Chain_EateryViewController *chainVC=[[Chain_EateryViewController alloc] init];
        chainVC.pID=[[ary objectAtIndex:p]valueForKey:@"id"];
        [self.navigationController pushViewController:chainVC animated:YES];
    }
    else if ([linkID intValue]==-1)
    {
        DetailViewController *detailVC=[[DetailViewController alloc] init];
        detailVC.resInfoArr = [ary objectAtIndex:indexPath.row];
        detailVC.pID=[[ary objectAtIndex:p]valueForKey:@"id"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    //点击 蓝色慢慢消失
    [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
    
}
-(void)backClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLeftVC" object:nil];
}
-(void)searchClick
{
//    SearchViewController *searchVC2=[[SearchViewController alloc] init];
//    [self.navigationController pushViewController:searchVC2 animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showRightVC" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
