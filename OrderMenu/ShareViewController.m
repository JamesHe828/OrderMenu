//
//  ShareViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-8.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "ShareViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Additions.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "WeiBoLoginViewController.h"
#import "AppDelegate.h"
#define SinaRequest_string @"https://api.weibo.com/oauth2/authorize?client_id=3564417983&redirect_uri=http://www.tiankong360.com&display=mobile"

#define TencentRequest_string @""
@interface ShareViewController ()
{
  WeiBoLoginViewController * login;
}
@end

@implementation ShareViewController
@synthesize aTextView;
@synthesize shareImage;
@synthesize delegate = _delegate;
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
    aBtn.showsTouchWhenHighlighted=YES;
    aBtn.frame=CGRectMake(0, 0, 44, 44);
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
    UIView *nView=[[UIView alloc] initWithFrame:CGRectMake(20, 60, 280, 165)];
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
    
    aTextView=[[UITextView alloc] initWithFrame:CGRectMake(5, 5, 270, 155)];
    aTextView.text=@"去那个好呢，东城，西城，城南，城北？哥们，要吃饭啊？@DMD #点美点# ，随意选就餐环境、菜品、预定座位、在线点餐，点美点，美一点，我的美餐！http://www.tiankong360.com";
    aTextView.font=[UIFont fontWithName:@"Arial" size:16.0f];
    aTextView.delegate=self;
    aTextView.returnKeyType=UIReturnKeyDone;
    [nView addSubview:aTextView];
    
    shareImage=[[UIImageView alloc] initWithFrame:CGRectMake(180, 240, 70, 100)];
    shareImage.image=[UIImage imageNamed:@"Default@2x.png"];
    [self.view addSubview:shareImage];

    UIButton *commitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame=CGRectMake(320-44, 0, 44, 44);
    commitBtn.showsTouchWhenHighlighted=YES;
    [commitBtn addTarget:self action:@selector(commitContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    //手势
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissShareVC) name:@"dismissShareVC" object:nil];
    
    
    
   
    
    
    
}
//手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        //NSLog(@"swipe left");
        //执行程序
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchGesture" object:nil];
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        //        NSLog(@"swipe right");
        //执行程序
    }
    
}
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
    UIButton *weixinBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame=CGRectMake(140, 10, 40, 40);
    [weixinBtn setImage:[UIImage imageNamed:@"weixin.png"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinClick) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:weixinBtn];
    
    UIButton *friendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame=CGRectMake(200, 10, 40, 40);
    [friendBtn setImage:[UIImage imageNamed:@"friend.png"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(friendClick) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:friendBtn];
    // 创建一个手势识别器
    UITapGestureRecognizer *oneFingerOneTaps =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerOneTaps)];
    [oneFingerOneTaps setNumberOfTapsRequired:1];
    [oneFingerOneTaps setNumberOfTouchesRequired:1];
    [background addGestureRecognizer:oneFingerOneTaps];
//    [backGroundView addGestureRecognizer:oneFingerOneTaps];
    

    
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
-(void)tencentClick
{
    if (login)
    {
        login = Nil;
    }
    NSString * strPath =  [NSString stringWithFormat:@"https://open.t.qq.com/cgi-bin/oauth2/authorize?client_id=%@&response_type=code&redirect_uri=%@",APP_KEY,APP_REQUEST_URL];
    if (IPhone5)
    {
        login = [[WeiBoLoginViewController alloc] initWithNibName:@"WeiBoLoginViewController" bundle:nil];
    }
    else
    {
        login = [[WeiBoLoginViewController alloc] initWithNibName:@"WeiBoLoginViewController4" bundle:nil];
    }
    login.urlStr = strPath;
    login.view.frame = CGRectMake(0, login.view.frame.size.height+100, 320, login.view.frame.size.height);
    [self.view addSubview:login.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        login.view.frame = CGRectMake(0, -20, 320, login.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}

-(void)weixinClick
{
    _scene = WXSceneSession;
    [self sendAppExtendContent];
    [_delegate changeScene:WXSceneSession];
}
- (void)sendAppExtendContent
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"点美点";
        message.description = @"去那个好呢，东城，西城，城南，城北？哥们，要吃饭啊？@DMD #点美点# ，随意选就餐环境、菜品、预定座位、在线点餐，点美点，美一点，我的美餐！http://www.tiankong360.com";
        [message setThumbImage:[UIImage imageNamed:@"Default@2x.png"]];
        
        WXAppExtendObject *ext =[WXAppExtendObject object];
        ext.url=@"https://itunes.apple.com/us/app/dian-mei-dian/id678946071?ls=1&mt=8";
        message.mediaObject=ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = _scene;
        
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alView show];
        
    }
}
-(void)friendClick
{
    _scene=WXSceneTimeline;
    [self sendAppExtendContent_friend];
    [_delegate changeScene:WXSceneTimeline];
}
- (void)sendAppExtendContent_friend
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"点美点";
        message.description = @"去那个好呢，东城，西城，城南，城北？哥们，要吃饭啊？@DMD #点美点# ，随意选就餐环境、菜品、预定座位、在线点餐，点美点，美一点，我的美餐！http://www.tiankong360.com";
        [message setThumbImage:[UIImage imageNamed:@"Default@2x.png"]];
        
        WXAppExtendObject *ext =[WXAppExtendObject object];
        ext.url=@"https://itunes.apple.com/us/app/dian-mei-dian/id678946071?ls=1&mt=8";
        message.mediaObject=ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = _scene;
        
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alView show];
        
    }
}
-(void) changeScene:(NSInteger)scene
{
    _scene = scene;
}
-(void)dimissClick
{
    [UIView animateWithDuration:.3 animations:^{
        authorizationView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [authorizationView removeFromSuperview];
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
{}
- (void)requestFinished:(ASIHTTPRequest *)request
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
- (void)requestFailed:(ASIHTTPRequest *)request
{}
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
    shareVC=[[ShareContentViewController alloc] init];
    shareVC.str=@"去那个好呢，东城，西城，城南，城北？哥们，要吃饭啊？@DMD #点美点# ，随意选就餐环境、菜品、预定座位、在线点餐，点美点，美一点，我的美餐！http://www.tiankong360.com";
    shareVC.picStr=[NSString stringWithFormat:@"http://%@/images/index.png",Domain_Name];
//    [self presentModalViewController:shareVC animated:YES];
    shareVC.view.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:shareVC.view];
    [UIView animateWithDuration:.3 animations:^{
        shareVC.view.frame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        
    }];
    [self oneFingerOneTaps];
}
-(void)dismissShareVC
{
    [UIView animateWithDuration:.3 animations:^{
        shareVC.view.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [shareVC.view removeFromSuperview];
    }];
}
-(void)backClick
{
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"showBotomBar" object:nil];
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
