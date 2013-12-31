//
//  EateryListViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-12-30.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "EateryListViewController.h"
#import "CustomCell.h"
#import "DataBase.h"
#import "Chain_EateryViewController.h"
#import "DetailViewController.h"
#import "TKHttpRequest.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "RefreshHeaderAndFooterView.h"
@interface EateryListViewController ()<RefreshHeaderAndFooterViewDelegate,UIScrollViewDelegate>
{
    RefreshHeaderAndFooterView *heardview ;
}
@property(nonatomic,strong)RefreshHeaderAndFooterView * refreshHeaderAndFooterView;
@property(nonatomic,assign)BOOL reloading;
@end

@implementation EateryListViewController
@synthesize refreshHeaderAndFooterView = _refreshHeaderAndFooterView;
@synthesize reloading = _reloading;
@synthesize classID;
@synthesize hideStr;
@synthesize titleLabStr;
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
    aImageView.image=[UIImage imageNamed:@"11.png"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    aBtn.showsTouchWhenHighlighted=YES;
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
    titleLab.backgroundColor=[UIColor clearColor];
    titleLab.text=titleLabStr;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
	ary=[[NSMutableArray alloc] init];
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-44-20) style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    [self.view addSubview:aTableView];
    pageID=1;
    if (classID==0)
    {
       [self getWMListRequest];
    }
    else
    {
        [self getOtherListRequest];
    }
    
}
#pragma mark --request delegate
-(void)getWMListRequest
{
    [MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/Restaurant.asmx?op=getFirstRest3ForTakeaway",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <getFirstRest3ForTakeaway xmlns=\"http://tempuri.org/\">\
                       <pageIndex>%d</pageIndex>\
                       </getFirstRest3ForTakeaway>\
                       </soap:Body>\
                       </soap:Envelope>",pageID];
    request.tag=001;
    [request addRequestHeader:@"Host" value:Domain_Name];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/getFirstRest3ForTakeaway"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    request.delegate=self;
    [request startAsynchronous];
}
-(void)getOtherListRequest
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
                       </soap:Envelope>",pageID,classID,0];
    request.tag=002;
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
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag==001)
    {
        [MyActivceView stopAnimatedInView:self.view];
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"getFirstRest3ForTakeaway"];
        NSString *page=[resultAry valueForKey:@"islastPage"];
        isPageID=page;
        [ary addObjectsFromArray:[resultAry valueForKey:@"Restaurant"]];
    }
    if (request.tag==002)
    {
        [MyActivceView stopAnimatedInView:self.view];
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"getFirstRest2"];
        NSString *page=[resultAry valueForKey:@"islastPage"];
        isPageID=page;
        [ary addObjectsFromArray:[resultAry valueForKey:@"Restaurant"]];
        
    }
    [self reloadData2];
    heardview.p=[ary count];
    [aTableView addSubview:heardview];
    [aTableView reloadData];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
    [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
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
//    
//    //    NSLog(@"++++++++resInfoArr = %@",[ary objectAtIndex:indexPath.row]);
//    //    NSLog(@"%@",[[ary objectAtIndex:indexPath.row]valueForKey:@"LinkID"]);
    NSString *linkID=[[ary objectAtIndex:indexPath.row]valueForKey:@"LinkID"];
    if ([linkID intValue]==0)
    {
        Chain_EateryViewController *chainVC=[[Chain_EateryViewController alloc] init];
        chainVC.pID=[[ary objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:chainVC animated:YES];
    }
    else if ([linkID intValue]==-1)
    {
        DetailViewController *detailVC=[[DetailViewController alloc] init];
        detailVC.hideStr=@"hide";
        detailVC.resInfoArr = [ary objectAtIndex:indexPath.row];
        detailVC.pID=[[ary objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
//    DetailViewController *detailVC=[[DetailViewController alloc] init];
//    //detailVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
    //点击 蓝色慢慢消失
    [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
    
}
-(void)backClick
{
    if ([self.hideStr isEqualToString:@"hide"])
    {
        NSLog(@"hidehidehide");
//        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [app showBotomBar];
    }
    else
    {
        NSLog(@"执行");
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app showBotomBar];
    }

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark RefreshHeaderAndFooterViewDelegate Methods

- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView*)view
{
	self.reloading = YES;
    if (view.refreshHeaderView.state == PullRefreshLoading)
    {//下拉刷新动作的内容
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
        
    }
    else if(view.refreshFooterView.state == PullRefreshLoading)
    {//上拉加载更多动作的内容
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
        if ([isPageID intValue]==0)
        {
            pageID++;
            if (classID==0)
            {
                [heardview removeFromSuperview];
                [self.refreshHeaderAndFooterView removeFromSuperview];
                [self getWMListRequest];
            }
            else
            {
                [heardview removeFromSuperview];
                [self.refreshHeaderAndFooterView removeFromSuperview];
                [self getOtherListRequest];
            }
        }else {}

       
        
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        [self.refreshHeaderAndFooterView RefreshScrollViewDidScroll:aTableView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshHeaderAndFooterView RefreshScrollViewDidEndDragging:aTableView];
}
-(void)doneLoadingTableViewData
{
    self.reloading = NO;
    [self.refreshHeaderAndFooterView RefreshScrollViewDataSourceDidFinishedLoading:aTableView];
    [aTableView reloadData];
}
-(void)reloadData2
{
    //    if (heardview!=nil ||self.refreshHeaderAndFooterView!=nil) {
    //        [heardview removeFromSuperview];
    //        [self.refreshHeaderAndFooterView removeFromSuperview];
    //    }
    heardview = [[RefreshHeaderAndFooterView alloc] initWithFrame:CGRectMake(0, 0, aTableView.frame.size.width, 0.000000)];
    heardview.delegate = self;
    self.refreshHeaderAndFooterView = heardview;
    [self.refreshHeaderAndFooterView.refreshHeaderView updateRefreshDate:[NSDate date]];
    self.reloading = NO;
    [self.refreshHeaderAndFooterView RefreshScrollViewDataSourceDidFinishedLoading:aTableView];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
