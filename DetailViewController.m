//
//  DetailViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-4.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DetailViewController.h"
#import "DishesCustomCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DishesListViewController.h"
#import "NSString+Additions.h"
#import "ShareContentViewController.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "TKHttpRequest.h"
#import "WeiBoLoginViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "DishClickView.h"
#import "DataBase.h"

#define SinaRequest_string @"https://api.weibo.com/oauth2/authorize?client_id=3564417983&redirect_uri=http://www.tiankong360.com&display=mobile"
#define TencentRequest_string @""
@interface DetailViewController ()
{
    BOOL isClick;
}
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) ASIHTTPRequest * request1;
-(void)leftButtonClickEvent:(UIButton *)aButton;
-(void)rightButtonClickEvent:(UIButton *)aButton;
-(void)bigButtonClickEvent:(UIButton *)aButton;

@end

@implementation DetailViewController
@synthesize aTableView;
@synthesize numLab;
@synthesize detailAry,recommendAry;
@synthesize pID;
@synthesize IDAry,collectAry;
@synthesize imageview,aLab,aText,addressLab;
@synthesize isFromOrder;
@synthesize resInfoArr;
@synthesize dataArr;
@synthesize request1;
@synthesize Lab11,Lab22,Lab33;
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
     //jjy
    if (!isClick)
    {
        self.dataArr = [DataBase selectAllProduct];
        [self viewDidLoad];
    }
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.title=@"菜单";
    //下个版本
//    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, [UIScreen mainScreen].bounds.size.height-44-20) style:UITableViewStylePlain];
//    aTableView.delegate=self;
//    aTableView.dataSource=self;
//    //[aTableView setSeparatorColor:[UIColor whiteColor]];
//    [self.view addSubview:aTableView];
//    self.aTableView.backgroundColor=[UIColor clearColor];
   // detailAry=[[NSArray alloc] init];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"详情导航"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    aBtn.showsTouchWhenHighlighted=YES;
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    aView=[[UIView alloc] initWithFrame:CGRectMake(8, 52, 320-16, 103)];
    [self.view addSubview:aView];
    aView.alpha=0;
//    [aView.layer setBorderWidth:0.5];
//    [aView.layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"DotedImage.png"]] CGColor]];
//    aView.layer.borderColor=[UIColor grayColor].CGColor;
//    aView.layer.borderWidth=0.5;
//    aView.layer.cornerRadius =5.0;
    
    imageview=[[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 54, 54)];
    //imageview.image=[UIImage imageNamed:@"a.jpg"];
    [aView addSubview:imageview];
    aLab=[[UILabel alloc] initWithFrame:CGRectMake(73, 18, 180, 20)];
    [aView addSubview:aLab];
    aLab.backgroundColor=[UIColor clearColor];
//    startimageview=[[UIImageView alloc] initWithFrame:CGRectMake(7, 70, 299, 30)];
//    startimageview.image=[UIImage imageNamed:@"开始点菜按钮"];
//    [aView addSubview:startimageview];
//    startimageview.alpha=0;
    startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame=CGRectMake(7, 70, 299, 30);
    [startBtn setImage:[UIImage imageNamed:@"开始点菜按钮"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:startBtn];
    
    aScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 161, 320, [UIScreen mainScreen].bounds.size.height-161)];
    aScrollView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    aScrollView.alpha=0;
    [self.view addSubview:aScrollView];
    //餐馆介绍
//    aText=[[UITextView alloc] initWithFrame:CGRectMake(8, 150, 320-16, 110)];
//    //aText.text=@"河南仲记企业创始于1999年，立足于服务行业，以餐饮为核心产业，传承儒家文化之精髓，倡导仁、义、礼、智、信得儒家理念，是一家集中餐酒楼，公益慈善、绿色食品、文化教育为一体的多元化集团企业，仲记酒楼正光路店2012年盛大开幕，现需诚聘大量英才加入我们的团队。";
//    aText.backgroundColor=[UIColor clearColor];
//    aText.editable=NO;
//    [self.view addSubview:aText];
  
    //地址，电话，信息
    UIView *addressView=[[UIView alloc] initWithFrame:CGRectMake(20,9, 280, 70)];
    addressView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    //圆角
    addressView.layer.borderColor=[UIColor grayColor].CGColor;
    addressView.layer.borderWidth=0.5;
    addressView.layer.cornerRadius =5.0;
//    //边框颜色
//    addressView.layer.borderColor=[[UIColor clearColor] CGColor];
//    //阴影
//    addressView.layer.shadowColor = [UIColor grayColor].CGColor;
//    addressView.layer.shadowOpacity = 1.0;
//    addressView.layer.shadowRadius = 1.0;
//    addressView.layer.shadowOffset = CGSizeMake(0, 3);
//    addressView.clipsToBounds = NO;
    [aScrollView addSubview:addressView];
    
    UIView *whiteBackView=[[UIView alloc] initWithFrame:CGRectMake(20,89, 280, 70)];
    whiteBackView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    //圆角
    whiteBackView.layer.borderColor=[UIColor grayColor].CGColor;
    whiteBackView.layer.borderWidth=0.5;
    whiteBackView.layer.cornerRadius =5.0;
    [aScrollView addSubview:whiteBackView];
    
    UIImageView *addressImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 16, 20)];
    addressImage.image=[UIImage imageNamed:@"位置图标"];
    [addressView addSubview:addressImage];
    UIImageView *numImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, 45, 16, 20)];
    numImage.image=[UIImage imageNamed:@"电话图标"];
    [addressView addSubview:numImage];
    addressLab=[[UILabel alloc] initWithFrame:CGRectMake(35, -5, 230, 60)];
    [addressLab setNumberOfLines:0];
    addressLab.backgroundColor=[UIColor clearColor];
    addressLab.font=[UIFont fontWithName:@"Arial" size:15.0f];
    //addressLab.text=@"花园路国基路交叉口往北100米路西";
    [addressView addSubview:addressLab];
    numLab=[[UILabel alloc] initWithFrame:CGRectMake(35, 40, 200, 30)];
    numLab.backgroundColor=[UIColor clearColor];
    numLab.font=[UIFont fontWithName:@"Arial" size:15.0f];
    //numLab.text=@"0371-88888815";
    [addressView addSubview:numLab];
    //餐馆营业时间，氛围，特色
    UILabel  *Lab1=[[UILabel alloc] initWithFrame:CGRectMake(10, 8, 100, 15)];
    Lab1.backgroundColor=[UIColor clearColor];
    Lab1.font=[UIFont fontWithName:@"Arial" size:15.0f];
    Lab1.text=@"营业时间：";
    [whiteBackView addSubview:Lab1];
    UILabel  *Lab2=[[UILabel alloc] initWithFrame:CGRectMake(10, 28, 100, 15)];
    Lab2.backgroundColor=[UIColor clearColor];
    Lab2.font=[UIFont fontWithName:@"Arial" size:15.0f];
    Lab2.text=@"餐厅氛围：";
    [whiteBackView addSubview:Lab2];
    UILabel  *Lab3=[[UILabel alloc] initWithFrame:CGRectMake(10, 48, 100, 15)];
    Lab3.backgroundColor=[UIColor clearColor];
    Lab3.font=[UIFont fontWithName:@"Arial" size:15.0f];
    Lab3.text=@"餐厅特色：";
    [whiteBackView addSubview:Lab3];
    Lab11=[[UILabel alloc] initWithFrame:CGRectMake(82, 8, 200, 15)];
    Lab11.backgroundColor=[UIColor clearColor];
    Lab11.font=[UIFont fontWithName:@"Arial" size:15.0f];
    [whiteBackView addSubview:Lab11];
    Lab22=[[UILabel alloc] initWithFrame:CGRectMake(82, 28, 200, 15)];
    Lab22.backgroundColor=[UIColor clearColor];
    Lab22.font=[UIFont fontWithName:@"Arial" size:15.0f];
    [whiteBackView addSubview:Lab22];
    Lab33=[[UILabel alloc] initWithFrame:CGRectMake(82, 48, 200, 15)];
    Lab33.backgroundColor=[UIColor clearColor];
    Lab33.font=[UIFont fontWithName:@"Arial" size:15.0f];
    [whiteBackView addSubview:Lab33];
    
    UIView *recommendView=[[UIView alloc] initWithFrame:CGRectMake(20,169, 280, 35)];
    recommendView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    //圆角
    recommendView.layer.borderColor=[UIColor grayColor].CGColor;
    recommendView.layer.borderWidth=0.5;
    recommendView.layer.cornerRadius =5.0;
    [aScrollView addSubview:recommendView];
    UILabel *recomendLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 2, 200, 31)];
    [recommendView addSubview:recomendLab];
    recomendLab.backgroundColor=[UIColor clearColor];
    recomendLab.text=@"推荐菜品";
    recomendLab.textColor=[UIColor colorWithRed:251.0/255.0 green:33.0/255.0 blue:47.0/255.0 alpha:1.0];
    
    //点击 位置 定位  点击电话打电话
    UIButton *addressBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame=CGRectMake(0, 0, 280, 35);
//    [addressBtn addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:addressBtn];
    UIButton *numBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    numBtn.frame=CGRectMake(0, 35, 280, 35);
    [numBtn addTarget:self action:@selector(callNum:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:numBtn];
    //分享按钮
    UIButton *commitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame=CGRectMake(320-93, 0, 44, 44);
    commitBtn.showsTouchWhenHighlighted=YES;
    [commitBtn addTarget:self action:@selector(commitContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    //收藏按钮
    UIButton *collectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame=CGRectMake(320-44, 0, 44, 44);
    collectBtn.showsTouchWhenHighlighted=YES;
    [collectBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectBtn];
    IDAry=[[NSMutableArray alloc] init];
//    collectAry=[[NSMutableArray alloc] init];
 //   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.collectAry = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"collectAry"]];
    [self detailRequest];
    [self recommendRequest];
}
//------分享
-(void)commitContent
{
    background=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    background.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.7];
    [self.view addSubview:background];
    backGroundView=[[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 80)];
    [self.view addSubview:backGroundView];
    backGroundView.backgroundColor=[UIColor whiteColor];
    [UIView animateWithDuration:.3 animations:^{
        backGroundView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-80, 320, 80);
    }];
    UIButton *sinaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sinaBtn.frame=CGRectMake(20, 10, 40, 40);
    [sinaBtn setImage:[UIImage imageNamed:@"新浪微博1@2x.png"] forState:UIControlStateNormal];
    [sinaBtn addTarget:self action:@selector(sinaClick) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:sinaBtn];
    UIButton *tencentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    tencentBtn.frame=CGRectMake(80, 10, 40, 40);
    [tencentBtn setImage:[UIImage imageNamed:@"腾讯微博1@2x.png"] forState:UIControlStateNormal];
    [tencentBtn addTarget:self action:@selector(tencentClick) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:tencentBtn];
    // 创建一个手势识别器
    UITapGestureRecognizer *oneFingerOneTaps =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerOneTaps)];
    [oneFingerOneTaps setNumberOfTapsRequired:1];
    [oneFingerOneTaps setNumberOfTouchesRequired:1];
    [background addGestureRecognizer:oneFingerOneTaps];
}
-(void)sinaClick
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"])
    {
        [self sharecontentVC];
    }
    else
    {
        authorizationView=[[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height)];
        [self.view addSubview:authorizationView];
        UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        aImageView.image=[UIImage imageNamed:@"登陆界面"];
        [authorizationView addSubview:aImageView];
        UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        aBtn.frame=CGRectMake(0, 0, 44, 44);
        aBtn.showsTouchWhenHighlighted=YES;
        [authorizationView addSubview:aBtn];
        [aBtn addTarget:self action:@selector(dimissClick) forControlEvents:UIControlEventTouchUpInside];
        UIWebView *requestWebview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-44)];
        [authorizationView addSubview:requestWebview];
        requestWebview.delegate=self;
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:SinaRequest_string]];
        [requestWebview loadRequest:request];
        [UIView animateWithDuration:.3 animations:^{
            authorizationView.frame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
        }];
    }
}
-(void)dimissClick
{
    [UIView animateWithDuration:.3 animations:^{
        authorizationView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [authorizationView removeFromSuperview];
    }];
}
#pragma mark - 腾讯微博分享
-(void)tencentClick
{
    isClick = YES;
    NSString * strPath =  [NSString stringWithFormat:@"https://open.t.qq.com/cgi-bin/oauth2/authorize?client_id=%@&response_type=code&redirect_uri=%@&web=2",APP_KEY,APP_REQUEST_URL];
    WeiBoLoginViewController * login;
    if (IPhone5)
    {
        login = [[WeiBoLoginViewController alloc] initWithNibName:@"WeiBoLoginViewController" bundle:nil];
    }
    else
    {
        login = [[WeiBoLoginViewController alloc] initWithNibName:@"WeiBoLoginViewController4" bundle:nil];
    }
    login.urlStr = strPath;
    login.resustName = aLab.text;
    [self presentViewController:login animated:YES completion:^{
        ;
    }];
}
//手势
//消息方法oneFingerOneTaps
- (void)oneFingerOneTaps
{
    //    NSLog(@"Action: One finger, one taps");
    
    [UIView animateWithDuration:.3 animations:^{
        backGroundView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 80);
        background.alpha=0;
    } completion:^(BOOL finished) {
        [backGroundView removeFromSuperview];
        [background removeFromSuperview];
    }];
    
}

#pragma mark - webView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // NSLog(@"-=-=-=-=-=>>>  %@",request.URL.absoluteString);
    NSString *abslutStr=request.URL.absoluteString;
    if ([abslutStr containString:@"code=" ])
    {
        NSString *queryString = request.URL.query;
        NSString *code = [[queryString componentsSeparatedByString:@"="] objectAtIndex:1];
        NSLog(@"code= %@",code);
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/access_token"]];
        [request setPostValue:@"3564417983" forKey:@"client_id"];
        [request setPostValue:@"636bf0a9d5ad75f116fd9426cd9ecf45" forKey:@"client_secret"];
        [request setPostValue:@"authorization_code" forKey:@"grant_type"];
        [request setPostValue:code forKey:@"code"];
        [request setPostValue:@"http://www.tiankong360.com" forKey:@"redirect_uri"];
        request.delegate = self;
        request.tag=360;
        [request startSynchronous];
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //NSLog(@"已经开始加载网页");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //NSLog(@"加载完毕网页");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"加载网页错误");
}
#pragma mark -- asihttpdelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    self.request1 = request;
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //分享
    if (request.tag==360)
    {
        // NSLog(@"-=-=>>>  %@",request.responseString);
        SBJSON *json = [[SBJSON alloc] init];
        NSDictionary *dic = [json objectWithString:request.responseString error:nil];
        //    NSLog(@"dic %@",dic);
        NSString *accessToken = [dic objectForKey:@"access_token"];
        NSNumber *expiresNum = [dic objectForKey:@"expires_in"];
        NSString *userID = [dic objectForKey:@"uid"];
        //放进UserDefaults里面的对象必须实现NSCoding 协议
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:expiresNum forKey:@"expires_in"];
        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"uid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self sharecontentVC];
        [self dimissVC];
    }
    else if (request.tag==361)
    {
        [MyActivceView stopAnimatedInView:self.view];
        NSArray *infoAry=[NSString ConverfromData:request.responseData name:@"GetInfo"];
        NSLog(@"info %@",infoAry);
        self.addressLab.text=[infoAry  valueForKey:@"restaddress"];
        self.aLab.text=[infoAry  valueForKey:@"restname"];
        [self.imageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://interface.hcgjzs.com%@",[infoAry valueForKey:@"restimg"]]] placeholderImage:[UIImage imageNamed:@"加载中"]];
        self.numLab.text=[infoAry valueForKey:@"restphone"];
       // self.aText.text=[infoAry valueForKey:@"restbrief"];
        self.Lab11.text=[infoAry valueForKey:@"worktime"];
        self.Lab22.text=[infoAry valueForKey:@"atmosphere"];
        self.Lab33.text=[infoAry valueForKey:@"characteristic"];
        self.detailAry=infoAry;
        aView.alpha = 1.0;
        aScrollView.alpha = 1.0;
    }
    //推荐菜
    else if (request.tag==362)
    {
       NSArray *infoAry=[NSString ConverfromData:request.responseData name:@"ProductRedList"];
        self.recommendAry=infoAry;
        aScrollView.contentSize=CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-161-44-20+70*[self.recommendAry count]);
        UITableView *recommendTable=[[UITableView alloc] initWithFrame:CGRectMake(12, 193, 296, 70*[self.recommendAry count]+15)style:UITableViewStyleGrouped];
        [aScrollView addSubview:recommendTable];
        recommendTable.scrollEnabled=NO;
        recommendTable.delegate=self;
        recommendTable.dataSource=self;
        recommendTable.backgroundView=nil;
        recommendTable.backgroundColor=[UIColor clearColor];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
    [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
}
-(void)dimissVC
{
    
    [UIView animateWithDuration:.3 animations:^{
        authorizationView.alpha=0;
    } completion:^(BOOL finished) {
        [authorizationView removeFromSuperview];
    }];
    [self oneFingerOneTaps];
}
-(void)sharecontentVC
{
    ShareContentViewController *shareVC=[[ShareContentViewController alloc] init];
    shareVC.str=[NSString stringWithFormat:@"我现在在%@吃饭，在用点美点进行点餐，用起来不错，推荐给大家。@DMD #点美点# ，随意选就餐环境、菜品、预定座位、在线点餐，尽在指尖，点即动美食定！http://www.tiankong360.com",self.aLab.text];
    shareVC.picStr=[NSString stringWithFormat:@"http://interface.hcgjzs.com%@",[self.detailAry valueForKey:@"restimg"]];
    [self presentModalViewController:shareVC animated:YES];  
    [self oneFingerOneTaps];
}
//---------收藏
-(void)collectClick
{
    UIAlertView *collectAlert=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"餐馆收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [collectAlert show];

    [collectAry addObject:detailAry];
    [[NSUserDefaults standardUserDefaults] setObject:collectAry forKey:@"collectAry"];
    [[NSUserDefaults standardUserDefaults] setObject:self.IDAry forKey:@"IDAry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//打电话
-(void)callNum:(id)sender
{
    //返回本程序
        UIWebView *callPhoneWebVw = [[UIWebView alloc] init];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numLab.text]]];
        [callPhoneWebVw loadRequest:request];
        [self.view addSubview:callPhoneWebVw];
    //跳出本程序
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numberStr]]];
}
-(void)startClick
{
    DishesListViewController * dishList;
    if (IPhone5)
    {
        dishList = [[DishesListViewController alloc] initWithNibName:@"DishesListViewController" bundle:nil];
    }
    else
    {
        dishList = [[DishesListViewController alloc] initWithNibName:@"DishesListViewController4" bundle:nil];
    }
    isClick = NO;
    dishList.resInfoArr = self.resInfoArr;
    dishList.resultID = [self.pID intValue];
    [self.navigationController pushViewController:dishList animated:YES];
}
#pragma mark - back
-(void)backClick
{
    [DataBase clearOrderMenu];
    [self.request1 cancel];
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark --request delegate
-(void)detailRequest
{
    [MyActivceView startAnimatedInView:self.view];
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:@"http://interface.hcgjzs.com/OM_Interface/Restaurant.asmx"];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <GetInfo xmlns=\"http://tempuri.org/\">\
                       <id>%d</id>\
                       </GetInfo>\
                       </soap:Body>\
                       </soap:Envelope>",[self.pID intValue]];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetInfo"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    request.delegate=self;
    request.tag=361;
    [request startAsynchronous];
}
-(void)recommendRequest
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:@"http://interface.hcgjzs.com/OM_Interface/Product.asmx?op=ProductRedList"];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <ProductRedList xmlns=\"http://tempuri.org/\">\
                       <restid>%d</restid>\
                       </ProductRedList>\
                       </soap:Body>\
                       </soap:Envelope>",[self.pID intValue]];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/ProductRedList"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    request.delegate=self;
    request.tag=362;
    [request startAsynchronous];
}
#pragma mark --- tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recommendAry count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    DishesCustomCell *cell = (DishesCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //记载xib相当于创建了xib当中的内容，返回的数组里面包含了xib当中的对象
        // NSLog(@"新创建的cell  %d",indexPath.row);
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DishesCustomCell" owner:nil options:nil];
		
        for (NSObject *object in array)
        {
            //判断数组中的对象是不是CustomCell 类型的
            if([object isKindOfClass:[DishesCustomCell class]])
            {
                //如果是，赋给cell指针
                cell = (DishesCustomCell *)object;
                //找到之后不再寻找
                break;
            }
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //ProID
    cell.nameLab.text=[[self.recommendAry objectAtIndex:indexPath.row] valueForKey:@"ProName"];
    cell.priceLab.textColor=[UIColor colorWithRed:251.0/255.0 green:33.0/255.0 blue:47.0/255.0 alpha:1.0];
    cell.priceLab.text=[NSString stringWithFormat:@"￥%@",[[self.recommendAry objectAtIndex:indexPath.row] valueForKey:@"prices"]];
    [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://interface.hcgjzs.com%@",[[self.recommendAry objectAtIndex:indexPath.row] valueForKey:@"ProductImg"]]] placeholderImage:[UIImage imageNamed:@"加载中"]];
    
    DishClickView *dishView=[[DishClickView alloc] initWithFrame:CGRectMake(180, 28, 90, 40) andNumber:0];
    [cell addSubview:dishView];
    
    //jjy
    
    __block int dotNumber = 0;
    if (indexPath.row < self.recommendAry.count)
    {
        __block NSString * proID;
        NSString * currID = [[self.recommendAry objectAtIndex:indexPath.row] valueForKey:@"ProID"];
        [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            proID = [obj valueForKey:@"ProID"];
            if ([currID isEqualToString:proID])
            {
                dotNumber = [[[[DataBase selectNumberFromProId:[currID intValue]] objectAtIndex:0] valueForKey:@"number"] intValue];
            }
        }];
        if (dotNumber>0)
        {
             [dishView initView:dotNumber];
        }
        else
        {
            [dishView zeroState];
        }
    }

    
    NSString * str = @"￥";
    NSString * priceStr = [[self.recommendAry objectAtIndex:indexPath.row] valueForKey:@"prices"];
    cell.priceLab.text = [str stringByAppendingFormat:@"%@",priceStr];
    dishView.price = [priceStr doubleValue];
    dishView.index = indexPath.row;
    [dishView.rightButton addTarget:self action:@selector(rightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [dishView.leftButton addTarget:self action:@selector(leftButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [dishView.bigButton addTarget:self action:@selector(bigButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - 点菜触发事件
-(void)leftButtonClickEvent:(UIButton *)aButton
{
    isClick = NO;
    DishClickView * dishView = (DishClickView *)[aButton superview];
    NSDictionary * obj = [self.recommendAry objectAtIndex:dishView.index];
    double priceSum = [PriceView ShareView].sumprice;
    int numberSum = [PriceView ShareView].sumnumber;
    [[PriceView ShareView] ChangeLabTextSumPrice:priceSum-[[[self.recommendAry objectAtIndex:dishView.index] valueForKey:@"prices"] doubleValue] sumDishes:numberSum-1];
    if (dishView.dotNumber == 0)
    {
        [DataBase deleteProID:[[obj valueForKey:@"ProID"] intValue]];
    }
    else
    {
        [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:dishView.dotNumber];
    }
}
-(void)rightButtonClickEvent:(UIButton *)aButton
{
    double priceSum = [PriceView ShareView].sumprice;
    int numberSum = [PriceView ShareView].sumnumber;
    isClick = NO;
    DishClickView * dishView = (DishClickView *)[aButton superview];
    NSDictionary * obj = [self.recommendAry objectAtIndex:dishView.index];
     [[PriceView ShareView] ChangeLabTextSumPrice:priceSum+[[[self.recommendAry objectAtIndex:dishView.index] valueForKey:@"prices"] doubleValue] sumDishes:numberSum+1];
    [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:dishView.dotNumber];
}
-(void)bigButtonClickEvent:(UIButton *)aButton
{
    isClick = NO;
    DishClickView * dishView = (DishClickView *)[aButton superview];
    NSDictionary * obj = [self.recommendAry objectAtIndex:dishView.index];
    
    if ([PriceView ShareView].sumnumber == 0)
    {
        [PriceView AnimateCome];
        [[PriceView ShareView] ChangeLabTextSumPrice:dishView.price sumDishes:1];
    }
    else
    {
        double priceSum = [PriceView ShareView].sumprice;
        int numberSum = [PriceView ShareView].sumnumber;
        [[PriceView ShareView] ChangeLabTextSumPrice:priceSum+dishView.price sumDishes:numberSum+1];
    }

    
    [DataBase insertProID:[[obj valueForKey:@"ProID"] intValue] menuid:[[obj valueForKey:@"Menuid"] intValue] proName:[obj valueForKey:@"ProName"] price:[[obj valueForKey:@"prices"] doubleValue] image:[obj valueForKey:@"ProductImg"] andNumber:1];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;//此处返回cell的高度
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
