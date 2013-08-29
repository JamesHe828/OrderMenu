//
//  ShareContentViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-24.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "ShareContentViewController.h"
#import "ASIFormDataRequest.h"
@interface ShareContentViewController ()

@end

@implementation ShareContentViewController
@synthesize numLab,aTextView,str,picStr;
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
   // self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"好友推荐2"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.showsTouchWhenHighlighted=YES;
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(320-44, 0, 44, 44);
    rightBtn.showsTouchWhenHighlighted=YES;
    [self.view addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(sendWeibo) forControlEvents:UIControlEventTouchUpInside];
    
    aTextView=[[UITextView alloc] initWithFrame:CGRectMake(5, 44, 310, 130)];
    [self.view addSubview:aTextView];
//    aTextView.text=@"我现在在%@吃饭，在用点美点进行点餐，用起来不错，推荐给大家。@DMD #点美点# ，随意选就餐环境、菜品、预定座位、在线点餐，尽在指尖，点即动美食定！http://www.tiankong360.com";
    aTextView.text=str;
    aTextView.font=[UIFont fontWithName:@"Arial" size:16.0f];
    [aTextView becomeFirstResponder];
    aTextView.delegate=self;
    UIImageView *aImage=[[UIImageView alloc] initWithFrame:CGRectMake(160, 170, 60, 30)];
    [self.view addSubview:aImage];
    aImage.image=[UIImage imageNamed:@"Default@2x"];
    numLab=[[UILabel alloc] initWithFrame:CGRectMake(260, 165, 60, 50)];
    [self.view addSubview:numLab];
    numLab.backgroundColor=[UIColor clearColor];
    numLab.textColor=[UIColor grayColor];
    numLab.text=[NSString stringWithFormat:@"%d",140-[aTextView.text length]];
}
-(void)sendWeibo
{
    [MyActivceView startAnimatedInView:self.view];
    NSString *cStr=self.aTextView.text;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    //NSLog(@"token *%@",token);
    ASIFormDataRequest *uploadRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"https://upload.api.weibo.com/2/statuses/upload.json"]];
    [uploadRequest setPostValue:token forKey:@"access_token"];
    [uploadRequest setPostValue:cStr forKey:@"status"];
//    NSString *picStr=@"http://interface.hcgjzs.com/images/restimg.jpg";
    NSURL *url=[NSURL URLWithString:picStr];
    NSData *data=[[NSData alloc] initWithContentsOfURL:url];
    [uploadRequest addData:data forKey:@"pic"];
    uploadRequest.uploadProgressDelegate = self;
    uploadRequest.delegate = self;
    [uploadRequest startAsynchronous];
  
}

#pragma mark -- asihttpdelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"成功");
       [MyActivceView stopAnimatedInView:self.view];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"微博分享成功，谢谢您的使用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"微博分享失败，请重新发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   [self backClick];
}
#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)btextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

        if (range.location>=140)
        {
            return NO;
        }
 
    return YES;
    
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    NSString  * nsTextContent=textView.text;
    int   existTextNum=[nsTextContent length];

    int i=140-existTextNum;
    
    if (i<0)
    {
        i=0;
    }
    NSString *str2=[NSString stringWithFormat:@"%d",i];
    self.numLab.text=str2;
    
}
-(void)backClick
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
