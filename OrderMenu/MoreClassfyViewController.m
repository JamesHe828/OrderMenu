//
//  MoreClassfyViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-12-27.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "MoreClassfyViewController.h"
#import "TKHttpRequest.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "EateryListViewController.h"
@interface MoreClassfyViewController ()

@end

@implementation MoreClassfyViewController

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
    titleLab.text=@"更多分类";
    titleLab.textColor=[UIColor whiteColor];
    titleLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    self.view.backgroundColor=[UIColor redColor];
//    UIImageView *aImge=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-44)];
//    aImge.backgroundColor=[UIColor blueColor];
//    [self.view addSubview:aImge];
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, [UIScreen mainScreen].bounds.size.height-44-20) style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    [self.view addSubview:aTableView];
    
    
    [self getListRequest];
}
#pragma mark --request delegate
-(void)getListRequest
{
    [MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/channel.asmx?op=GetList",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <GetList xmlns=\"http://tempuri.org/\">\
                       <parentid>%d</parentid>\
                       <kindid>%d</kindid>\
                       </GetList>\
                       </soap:Body>\
                       </soap:Envelope>",1,1];
    request.tag=001;
    [request addRequestHeader:@"Host" value:Domain_Name];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetList"];
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
        NSArray  *resultAry=[NSString ConverfromData:request.responseData name:@"GetList"];
        NSLog(@"-=-=-=- >>> %@",resultAry);
        resAry=[NSArray arrayWithArray:resultAry];
        listAry=[[NSMutableArray alloc] initWithObjects:@"外卖", nil];
        for (int i =0; i<[resultAry count]; i++)
        {
            NSString *str=[[resultAry objectAtIndex:i] valueForKey:@"title"];
            [listAry addObject:str];
        }
        
        [aTableView reloadData];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
    [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //右边小箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text=[listAry objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EateryListViewController *eateryVC=[[EateryListViewController alloc]init];
    if (indexPath.row==0)
    {
        eateryVC.classID=0;
       // eateryVC.titleLabStr=@"外卖";
    }
    else
    {
        eateryVC.classID=[[[resAry objectAtIndex:indexPath.row] valueForKey:@"id"] intValue];
       
    }
    eateryVC.titleLabStr=[listAry objectAtIndex:indexPath.row];
    eateryVC.hideStr=@"hide";
    //eateryVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:eateryVC animated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}
-(void)backClick
{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app showBotomBar];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
