//
//  SearchResultViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-12.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultCustomCell.h"
#import "UIImageView+WebCache.h"
#import "MyActivceView.h"
#import "ASIHTTPRequest.h"
#import "NSString+JsonString.h"
@interface SearchResultViewController ()

@end

@implementation SearchResultViewController
@synthesize ary;
@synthesize searchStr;
@synthesize aTableView;
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
    
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, [UIScreen mainScreen].bounds.size.height -44-20) style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    //[aTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:aTableView];
    detailVC=[[DetailViewController alloc] init];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [aTableView reloadData];
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
    
    SearchResultCustomCell *cell = (SearchResultCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //记载xib相当于创建了xib当中的内容，返回的数组里面包含了xib当中的对象
        // NSLog(@"新创建的cell  %d",indexPath.row);
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SearchResultCustomCell" owner:nil options:nil];
		
        for (NSObject *object in array)
        {
            //判断数组中的对象是不是CustomCell 类型的
            if([object isKindOfClass:[SearchResultCustomCell class]])
            {
                //如果是，赋给cell指针
                cell = (SearchResultCustomCell *)object;
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
    //numberStr=cell.timeLab.text;
    cell.lab.text=[[ary objectAtIndex:indexPath.row] valueForKey:@"restname"];
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
    [self detailRequest];
    [self.navigationController pushViewController:detailVC animated:YES];
    p=indexPath.row;
    NSLog(@"=======  %d",indexPath.row);
    //点击 蓝色慢慢消失
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}
-(void)detailRequest
{
    [MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://interface.hcgjzs.com/OM_Interface/Restaurant.asmx"]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <GetInfo xmlns=\"http://tempuri.org/\">\
                       <id>%d</id>\
                       </GetInfo>\
                       </soap:Body>\
                       </soap:Envelope>", [[[ary objectAtIndex:p]valueForKey:@"id"] intValue]];
    NSLog(@"(%d)",p);
//    request.tag=1111;[[[ary objectAtIndex:p]valueForKey:@"id"] intValue]
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetInfo"];
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
    //       NSLog(@"----->>%@",request.responseString);
    NSArray *infoAry=[NSString ConverfromData:request.responseData name:@"GetInfo"];
    //        detailVC.detailAry=infoAry;
    NSLog(@"______------%@",infoAry);
    detailVC.addressLab.text=[infoAry  valueForKey:@"restaddress"];
    detailVC.aLab.text=[infoAry  valueForKey:@"restname"];
    [detailVC.imageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://interface.hcgjzs.com%@",[infoAry valueForKey:@"restimg"]]] placeholderImage:[UIImage imageNamed:@"加载中"]];
    detailVC.numLab.text=[infoAry valueForKey:@"restphone"];
    detailVC.aText.text=[infoAry valueForKey:@"restbrief"];
    [MyActivceView stopAnimatedInView:self.view];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
