//
//  ViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "ViewController.h"
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
@interface ViewController ()<RefreshHeaderAndFooterViewDelegate,UIScrollViewDelegate>
{
    RefreshHeaderAndFooterView *heardview ;
}
@property(nonatomic,strong)RefreshHeaderAndFooterView * refreshHeaderAndFooterView;
@property(nonatomic,assign)BOOL reloading;
@end

@implementation ViewController
@synthesize refreshHeaderAndFooterView = _refreshHeaderAndFooterView;
@synthesize reloading = _reloading;
@synthesize pageC;
@synthesize aTableView;
@synthesize numberStr;
@synthesize searchAry;
@synthesize resultTableView;
@synthesize ascrollview;
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"主界面导航"];
    //aImageView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame=CGRectMake(0, 0, 60, 60);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(leftVCClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(216, 0, 47, 44);
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //养生图片
	ascrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 132)];
    [self.view addSubview:ascrollview];
    ascrollview.pagingEnabled=YES;
    ascrollview.showsHorizontalScrollIndicator=NO;
    ascrollview.delegate=self;
    ascrollview.contentSize=CGSizeMake(320*5, 132);
    for (int i = 0 ; i<5; i++) {
        UIImageView *aImage = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 132)];
        aImage.userInteractionEnabled = YES;
        aImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"最佳推荐%d",i+1]];
        [ascrollview addSubview:aImage];
        
    }
//    for (int j=0; j<5; j++)
//    {
//        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame=CGRectMake(320*j, 0, 320, 132);
//        [btn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
//        [ascrollview addSubview:btn];
//    }
    pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(120,126+44-14+10, 100, 10)];
    pageC.numberOfPages = 5;
    pageC.currentPage=0;
    [self.view addSubview:pageC];
    
    self.navigationController.navigationBarHidden = YES;
    
    
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,146+44-14, 320, [UIScreen mainScreen].bounds.size.height - 146-44+14-20) style:UITableViewStylePlain];  
    aTableView.delegate=self;
    aTableView.dataSource=self;
    //[aTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:aTableView];
    //self.aTableView.backgroundColor=[UIColor clearColor];
    ary=[[NSArray alloc] init];
    nameAry=[[NSArray alloc] init];

    
    //定时滚动
//    CGPoint bottomOffset = CGPointMake(self.ascrollview.contentOffset.x, self.ascrollview.contentSize.height - self.ascrollview.bounds.size.height);
//    CGPoint bottomOffset = CGPointMake(self.ascrollview.contentSize.width-self.ascrollview.bounds.size.width,self.ascrollview.contentOffset.y);
    //设置延迟时间
    float scrollDurationInSeconds = 5.0;
    
    //计算timer间隔
    [NSTimer scheduledTimerWithTimeInterval:scrollDurationInSeconds target:self selector:@selector(scrollScrollView:) userInfo:nil repeats:YES];
    
    [self reloadData2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(helpFileview) name:@"helpFileView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailFileview:) name:@"detailViewC" object:nil];
    if ([self isconnectok])
        
    {
        [self restaurantListRequest];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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
-(void)detailFileview:(NSNotification *)aNotification
{
    NSDictionary * dic = aNotification.userInfo;
    NSString * title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"key"]];
     DetailViewController *detailVC=[[DetailViewController alloc] init];
    detailVC.pID=title;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)helpFileview
{
    HelpViewController *helo=[[HelpViewController alloc] init];
    [self.navigationController pushViewController:helo animated:NO];
}
-(void)reloadData2
{
    if (heardview!=nil ||self.refreshHeaderAndFooterView!=nil) {
        [heardview removeFromSuperview];
        [self.refreshHeaderAndFooterView removeFromSuperview];
    }
    heardview = [[RefreshHeaderAndFooterView alloc] initWithFrame:CGRectMake(0, 0, self.aTableView.frame.size.width, self.aTableView.contentSize.height)];
    heardview.delegate = self;
    heardview.p=[nameAry count];
    [self.aTableView addSubview:heardview];
    self.refreshHeaderAndFooterView = heardview;
    [self.refreshHeaderAndFooterView.refreshHeaderView updateRefreshDate:[NSDate date]];
    self.reloading = NO;
    [self.refreshHeaderAndFooterView RefreshScrollViewDataSourceDidFinishedLoading:self.aTableView];
    [self.aTableView reloadData];
    
}
#pragma mark -
#pragma mark RefreshHeaderAndFooterViewDelegate Methods

- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView*)view{
	self.reloading = YES;
    if (view.refreshHeaderView.state == PullRefreshLoading)
    {//下拉刷新动作的内容
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
        [self performSelector:@selector(restaurantListRequest)];
        
    }
    else if(view.refreshFooterView.state == PullRefreshLoading){//上拉加载更多动作的内容
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
       // [self performSelector:@selector(sendRequest)];
    }
    
}

- (BOOL)RefreshHeaderAndFooterDataSourceIsLoading:(RefreshHeaderAndFooterView*)view{
	
	return self.reloading; // should return if data source model is reloading
	
}
- (NSDate*)RefreshHeaderAndFooterDataSourceLastUpdated:(RefreshHeaderAndFooterView*)view{
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
-(void)sendRequest
{
    //[self._aTableView reloadData];
    //请求数据
    NSString *str=[NSString stringWithFormat:@"http://www.iarchiscape.com/web/newarchilist?before=2013040118000&page=1"];
    NSString *str2=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str2]];
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void)restaurantListRequest
{
    [MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:@"http://interface.hcgjzs.com/OM_Interface/Restaurant.asmx"];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <GetRestaurantList xmlns=\"http://tempuri.org/\">\
                       <filedOrder>%d</filedOrder>\
                       <typeid>%d</typeid>\
                       <departid>%d</departid>\
                       </GetRestaurantList>\
                       </soap:Body>\
                       </soap:Envelope>",1,0,1];
    request.tag=0000;
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetRestaurantList"];
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
    [MyActivceView stopAnimatedInView:self.view];
    if (request.tag==0000)
    {
        
 //       NSLog(@"----->>%@",request.responseString);
        ary=[NSString ConverfromData:request.responseData name:@"GetRestaurantList"];
        [self.aTableView reloadData];
    }

}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
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
-(void)leftVCClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLeftVC" object:nil];
}
-(void)searchClick
{
    SearchViewController *searchVC2=[[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC2 animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_NO" object:nil];
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
    cell.lab.font = [UIFont fontWithName:@"Arial" size:17.0f];
    cell.lab.textColor=[UIColor colorWithRed:255.0/255.0 green:137.0/255.0 blue:3.0/255.0 alpha:1.0];
   cell.lab2.textColor=[UIColor grayColor];
    cell.renjunLab.textColor=[UIColor grayColor];
    cell.timeLab.textColor=[UIColor grayColor];
    numberStr=cell.timeLab.text;
    cell.lab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"restname"];
//    cell.imag.image=[UIImage imageNamed:[NSString stringWithFormat:@"http://interface.hcgjzs.com%@",[[ary objectAtIndex:indexPath.row] valueForKey:@"restimg"]]];
    [cell.imag setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://interface.hcgjzs.com%@",[[ary objectAtIndex:indexPath.row] valueForKey:@"restimg"]]] placeholderImage:[UIImage imageNamed:@"加载中"]];
    cell.lab2.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"restaddress"];
    cell.timeLab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"restphone"];
    cell.renjunLab.text=[NSString stringWithFormat:@"人均￥%@",[[ary objectAtIndex:indexPath.row] valueForKey:@"restaverage"]];
 //   [cell.abtn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
  //  [cell.bbtn addTarget:self action:@selector(callNum:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 66;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     p=indexPath.row;
    DetailViewController *detailVC=[[DetailViewController alloc] init];
    detailVC.pID=[[ary objectAtIndex:p]valueForKey:@"id"];;
    [self.navigationController pushViewController:detailVC animated:YES];
    //点击 蓝色慢慢消失
   [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_NO" object:nil];
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
