//
//  ShareViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-8.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "ShareViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UMSocial.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize aTextView;
@synthesize shareImage;
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
    self.view.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:226.0/255.0 blue:228.0/255.0 alpha:1.0];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"好友推荐导航"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame=CGRectMake(0, 0, 60, 60);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    //白色底
//    UIView *nView=[[UIView alloc] initWithFrame:CGRectMake(-5, 50, 330, 50)];
//    nView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
//    //圆角
//    nView.layer.borderColor=[UIColor grayColor].CGColor;
//    nView.layer.borderWidth=0.5;
//    nView.layer.cornerRadius =5.0;
//    //边框颜色
//    nView.layer.borderColor=[[UIColor clearColor] CGColor];
//    //阴影
//    nView.layer.shadowColor = [UIColor grayColor].CGColor;
//    nView.layer.shadowOpacity = 1.0;
//    nView.layer.shadowRadius = 1.0;
//    nView.layer.shadowOffset = CGSizeMake(0, 3);
//    nView.clipsToBounds = NO;
//    [self.view addSubview:nView];
//    UIButton *sinaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    sinaBtn.frame=CGRectMake(14, 5, 40, 40);
//    [sinaBtn setBackgroundImage:[UIImage imageNamed:@"新浪微博0"] forState:UIControlStateNormal];
//    [sinaBtn addTarget:self action:@selector(sinaClick) forControlEvents:UIControlEventTouchUpInside];
//    [nView addSubview:sinaBtn];
//    UIButton *tencnetBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    tencnetBtn.frame=CGRectMake(60, 5, 40, 40);
//    [tencnetBtn setBackgroundImage:[UIImage imageNamed:@"腾讯微博0"] forState:UIControlStateNormal];
//    [tencnetBtn addTarget:self action:@selector(tencentClick) forControlEvents:UIControlEventTouchUpInside];
//    [nView addSubview:tencnetBtn];
    //白色底
    UIView *nView=[[UIView alloc] initWithFrame:CGRectMake(10, 60, 280, 160)];
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
    [self.view addSubview:nView];
    
    aTextView=[[UITextView alloc] initWithFrame:CGRectMake(5, 5, 270, 150)];
    aTextView.text=@"去那个好呢，东城，西城，城南，城北？哥们，要吃饭啊？@DMD #点美点# ，随意选就餐环境、菜品、预定座位、在线点餐，点美点，美一点，我的美餐！http://www.tiankong360.com";
    aTextView.font=[UIFont fontWithName:@"Arial" size:16.0f];
    aTextView.delegate=self;
    aTextView.returnKeyType=UIReturnKeyDone;
    [nView addSubview:aTextView];
    
    shareImage=[[UIImageView alloc] initWithFrame:CGRectMake(170, 240, 100, 80)];
    shareImage.image=[UIImage imageNamed:@"c.jpg"];
    [self.view addSubview:shareImage];

    UIButton *commitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame=CGRectMake(230, 0, 60, 50);
    [commitBtn addTarget:self action:@selector(commitContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [WXApi registerApp:@"wxbbaa72933f4cc9b7"];
//    [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeApp;   //可以指定音乐类型或者视频类型
//    [UMSocialData defaultData].extConfig.appUrl = @"http://www.tiankong360.com";

    
}
-(void)commitContent
{
    
//    [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeApp;   //可以指定音乐类型或者视频类型
//    [UMSocialData defaultData].extConfig.appUrl = @"http://www.tiankong360.com";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"51dccb0456240b7f87001d5e"
                                      shareText:aTextView.text
                                     shareImage:shareImage.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechat,UMShareToDouban,UMShareToQzone,nil]
                                       delegate:nil];
}
#pragma MARK -textview delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"])
        
    {
        
        [textView resignFirstResponder];
        return NO;
        
    }
    
    return YES;
    
}
-(void)sinaClick
{
   
}
-(void)tencentClick
{
   
}
-(void)backClick
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
