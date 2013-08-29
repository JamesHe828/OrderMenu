//
//  WeiBoLoginViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-25.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "WeiBoLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@interface WeiBoLoginViewController ()
{
    NSURLRequest * request;
    UIView * allView;
    UITextView * allTextView;
}
@property (nonatomic,strong) IBOutlet UIWebView * myWebView;
@property (nonatomic,strong) NSURLRequest * request;
@property (nonatomic,strong) IBOutlet UIButton * sendBtn;
@property (nonatomic,strong) IBOutlet UIImageView * lineImageView;
@property (nonatomic,strong) IBOutlet UILabel * lab_title;
@property (nonatomic,strong) NSMutableArray * dataArr;
-(IBAction)backClick:(id)sender;
-(IBAction)sendClick:(id)sender;
-(void)changeUI;
-(NSString *)parseIndex:(int)aIndex parStr:(NSString *)aStr;
@end

@implementation WeiBoLoginViewController
@synthesize urlStr;
@synthesize myWebView;
@synthesize request;
@synthesize sendBtn;
@synthesize dataArr;
@synthesize resustName;
@synthesize lineImageView;
@synthesize lab_title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    NSString * token = [[NSUserDefaults standardUserDefaults] valueForKey:@"T_access_token"];
    if (token.length>0)
    {
        [self changeUI];
    }
    else
    {
        self.sendBtn.alpha = 0.0;
        self.lab_title.alpha = 1.0;
        self.lineImageView.alpha = 0.0;
        self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [self.myWebView loadRequest:request];
    }
}
-(IBAction)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str=[[self.myWebView.request URL] absoluteString];
    NSRange range = [str rangeOfString:@"code="];
    if (range.length>0)
    {
        self.myWebView.alpha = 0.0;
        NSString *queryString = [[self.myWebView.request URL] query];
        NSString *code = [[queryString componentsSeparatedByString:@"="] objectAtIndex:1];
        NSArray * arr = [code componentsSeparatedByString:@"&"];
        NSString * strPath = [NSString stringWithFormat:@"https://open.t.qq.com/cgi-bin/oauth2/access_token?client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code&code=%@",APP_KEY,APP_SECRET,APP_REQUEST_URL,[arr objectAtIndex:0]];
        ASIHTTPRequest * request1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strPath]];
        [request1 startAsynchronous];
        NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
        [request1 setStartedBlock:^{
            [MyActivceView startAnimatedInView:self.myWebView];
        }];
        [request1 setDataReceivedBlock:^(NSData *data) {
            [reciveData appendData:data];
        }];
        [request1 setCompletionBlock:^{
            [MyActivceView stopAnimatedInView:self.myWebView];
            NSArray * resultArr = [[[NSString alloc] initWithData:reciveData encoding:4] componentsSeparatedByString:@"&"];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:[self parseIndex:3 parStr:@"openid"] forKey:@"T_opeid"];
            [defaults setValue:[self parseIndex:0 parStr:@"access_token"] forKey:@"T_access_token"];
            
            self.dataArr = [NSMutableArray arrayWithArray:resultArr];
            [self changeUI];
        }];
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MyActivceView startAnimatedInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MyActivceView stopAnimatedInView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
 
}
-(void)changeUI
{
    allView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+20, 320, self.view.frame.size.height)];
    allView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:226.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    UIView *nView;
    if (self.resustName.length>0)
    {
        nView=[[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 165)];
    }
    else
    {
      nView=[[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 165)];
    }
    
    nView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    //圆角
    nView.layer.borderColor=[UIColor grayColor].CGColor;
    nView.layer.borderWidth=0.5;
    nView.layer.cornerRadius =5.0;
    //边框颜色
    nView.layer.borderColor=[[UIColor clearColor] CGColor];
    //阴影
    nView.layer.shadowColor = [UIColor grayColor].CGColor;
    nView.layer.shadowOpacity = 1.0;
    nView.layer.shadowRadius = 1.0;
    nView.layer.shadowOffset = CGSizeMake(0, 3);
    nView.clipsToBounds = NO;
    [allView addSubview:nView];
    
    allTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 270, 155)];
    allTextView.layer.borderColor = [UIColor grayColor].CGColor;
    allTextView.font=[UIFont systemFontOfSize:16.0f];
    if (self.resustName.length>0)
    {
         allTextView.text = [NSString stringWithFormat:@"我现在在%@吃饭，在用点美点进行点餐，用起来不错，推荐给大家。@DMD #点美点# ，随意选就餐环境、菜品、预定座位、在线点餐，尽在指尖，点即动美食定！http://www.tiankong360.com",self.resustName];
    }
    else
    {
       allTextView.text = @"去那个好呢，东城，西城，城南，城北？哥们，要吃饭啊？@DMD #点美点# ，随意选就餐环境、菜品、预定座位、在线点餐，点美点，美一点，我的美餐！http://www.tiankong360.com";
    }
    [nView addSubview:allTextView];
    [self.view addSubview:allView];
    [self.myWebView removeFromSuperview];
    [allTextView becomeFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        allView.frame = CGRectMake(0, 43, 320, self.view.frame.size.height);
        self.sendBtn.alpha = 1.0;
        self.lineImageView.alpha =  1.0;
         self.lab_title.text=@"好友推荐";
    } completion:^(BOOL finished) {
    }];
}
-(IBAction)sendClick:(id)sender
{
    NSString * path = @"https://open.t.qq.com/api/t/add_pic";
    ASIFormDataRequest * request1 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:path]];
    [request1 setPostValue:@"json" forKey:@"format"];
    [request1 setPostValue:APP_KEY forKey:@"appid"];
    [request1 setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"T_opeid"] forKey:@"openid"];
    [request1 setPostValue:allTextView.text forKey:@"content"];
    [request1 setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"T_access_token"] forKey:@"access_token"];
    NSBundle * bundle = [NSBundle mainBundle];
    NSString * path1 = [bundle pathForResource:@"Default" ofType:@"png"];
    NSData * data = [NSData dataWithContentsOfFile:path1];
    [request1 addData:data forKey:@"pic"];
    [request1 startSynchronous];
    NSData * data1 = [request1 responseData];
    NSDictionary * dic = [data1 objectFromJSONData];
    NSString * errcode = [NSString stringWithFormat:@"%@",[dic valueForKey:@"errcode"]];
    NSString * ret = [NSString stringWithFormat:@"%@",[dic valueForKey:@"ret"]];
    if ([errcode isEqualToString:@"0"] && [ret isEqualToString:@"0"])
    {
        [allTextView resignFirstResponder];
        [MyAlert ShowAlertMessage:@"分享成功" title:@""];
    }
    else
   {
       [MyAlert ShowAlertMessage:@"分享失败" title:@""];
   }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [allTextView resignFirstResponder];
}

-(NSString *)parseIndex:(int)aIndex parStr:(NSString *)aStr
{
    if (self.dataArr.count>0)
    {
        NSString * str1 = [self.dataArr objectAtIndex:aIndex];
        NSArray * arr = [str1 componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\"="]];
        NSString * result = [arr objectAtIndex:1];
        return result;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
