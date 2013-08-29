//
//  FeedbackViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-8.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "FeedbackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIPlaceHolderTextView.h"
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "MyActivceView.h"
#import "Reachability.h"
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
@synthesize aTextView,atextField;
@synthesize backView;
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
    backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height )];
    [self.view addSubview:backView];
    backView.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"意见反馈导航.png"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.showsTouchWhenHighlighted=YES;
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //白色底
    UIView *numView=[[UIView alloc] initWithFrame:CGRectMake(22, 100, 277, 40)];
    numView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    //圆角
    numView.layer.borderColor=[UIColor grayColor].CGColor;
    numView.layer.borderWidth=0.5;
    numView.layer.cornerRadius =5.0;
    //边框颜色
    numView.layer.borderColor=[[UIColor clearColor] CGColor];
    //阴影
    numView.layer.shadowColor = [UIColor grayColor].CGColor;
    numView.layer.shadowOpacity = 1.0;
    numView.layer.shadowRadius = 1.0;
    numView.layer.shadowOffset = CGSizeMake(0, 3);
    numView.clipsToBounds = NO;
    [backView addSubview:numView];
    UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake(22, 185, 277, 195)];
    contentView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    //圆角
    contentView.layer.borderColor=[UIColor grayColor].CGColor;
    contentView.layer.borderWidth=0.5;
    contentView.layer.cornerRadius =5.0;
    //边框颜色
    contentView.layer.borderColor=[[UIColor clearColor] CGColor];
    //阴影
    contentView.layer.shadowColor = [UIColor grayColor].CGColor;
    contentView.layer.shadowOpacity = 1.0;
    contentView.layer.shadowRadius = 1.0;
    contentView.layer.shadowOffset = CGSizeMake(0, 3);
    contentView.clipsToBounds = NO;
    [backView addSubview:contentView];
    UILabel  *numLab=[[UILabel alloc] initWithFrame:CGRectMake(22, 57, 100, 50)];
    numLab.text=@"联系方式:";
    numLab.font=[UIFont fontWithName:@"Arial" size:20.0f];
    numLab.backgroundColor=[UIColor clearColor];
    [backView addSubview:numLab];
    atextField=[[UITextField alloc] initWithFrame:CGRectMake(8, 5, 270, 30)];
    atextField.font=[UIFont fontWithName:@"Arial" size:18.0f];
    atextField.borderStyle=UITextBorderStyleNone;
    atextField.placeholder=@"请输入您的邮箱或者手机号码";
    atextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [numView addSubview:atextField];
    UILabel  *contentLab=[[UILabel alloc] initWithFrame:CGRectMake(22, 140, 100, 50)];
    contentLab.text=@"反馈内容:";
    contentLab.font=[UIFont fontWithName:@"Arial" size:20.0f];
    contentLab.backgroundColor=[UIColor clearColor];
    [backView addSubview:contentLab];
    aTextView=[[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(3, 3, 280, 195)];
    aTextView.placeholder=@"请输入反馈内容(200字以内)";
    aTextView.backgroundColor=[UIColor clearColor];
    aTextView.delegate=self;
    aTextView.font=[UIFont fontWithName:@"Arial" size:18.0f];
    aTextView.returnKeyType=UIReturnKeyDone;
    [contentView addSubview:aTextView];
    
    UIButton *commitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame=CGRectMake(320-44, 0, 44, 44);
    commitBtn.showsTouchWhenHighlighted=YES;
    [commitBtn addTarget:self action:@selector(commitFeedContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];


    //手势
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    
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
-(void)commitFeedContent
{
    if (atextField.text)
    {

        if ([aTextView.text isEqualToString:@""])
        {

            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"请输入反馈内容(200字以内)" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        else
        {
            [aTextView resignFirstResponder];
            [self stopAnimation];
            [self isAllNum:atextField.text];
            
        }
    }
    else 
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"请输入您的邮箱或者手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    
    }

}
- (BOOL)isAllNum:(NSString *)string{
    //    NSString *string = @"1234abcd";
    unichar c;
    for (int i=0; i<string.length; i++)
    {
        c=[string characterAtIndex:i];
        if (!isdigit(c))
        {
            [self isValidateEmail:string];
            return NO;
        }
    }
    [self isMobileNumber:string];
    return YES;
}
//手机号码判断
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
                    * 手机号码
                    * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
                    * 联通：130,131,132,152,155,156,185,186
                    * 电信：133,1349,153,180,189
                    */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
                    10         * 中国移动：China Mobile
                    11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
                    12         */
   NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
   /**
                    15         * 中国联通：China Unicom
                    16         * 130,131,132,152,155,156,185,186
                    17         */
   NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
   /**
                    20         * 中国电信：China Telecom
                    21         * 133,1349,153,180,189
                    22         */
   NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
   /**
                    25         * 大陆地区固话及小灵通
                    26         * 区号：010,020,021,022,023,024,025,027,028,029
                    27         * 号码：七位或八位
                    28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
   NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
   NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
   NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
   NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
   if (([regextestmobile evaluateWithObject:mobileNum] == YES)
            || ([regextestcm evaluateWithObject:mobileNum] == YES)
            || ([regextestct evaluateWithObject:mobileNum] == YES)
            || ([regextestcu evaluateWithObject:mobileNum] == YES))
        {
            [self feedBackRequest];
           return YES;
        }
    else
        {
            UIAlertView *aLertView=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"您输入的手机号码不合法，请重新输入！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aLertView show];
            return NO;
        }
}
#pragma mark - 邮箱判断
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //NSLog(@"-------%@",[emailTest evaluateWithObject:email]?@"YES":@"NO");
    if ([emailTest evaluateWithObject:email]==NO)
    {
        UIAlertView *aLertView=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"您输入的邮箱不合法，请重新输入！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aLertView show];
    }
    else
    {
        [self feedBackRequest];
//            UIAlertView *commit = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Your feedback has been submitted , thank you!",nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Done",nil), nil];
//            [commit show];
//            
//            //反馈接口   http://223.4.132.1/MasterArchitect/web/app.php/feedback/new
//            NSURL *url = [NSURL URLWithString:@"http://5dup.5dscape.cn/web/feedback/new"];
//            NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
//            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//            [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"FEEDBACKTYPE"] forKey:@"type"];
//            [request setPostValue:email forKey:@"email"];
//            [request setPostValue:textView.text forKey:@"info"];
//            [request setPostValue:@"WA" forKey:@"app"];
//            [request setDelegate:self];
//            [request startAsynchronous];
//
//            UIAlertView *commit = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please fill in the necessary information",nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Done",nil), nil];
//            [commit show];
        
        
    }
    return [emailTest evaluateWithObject:email];
}
-(void)startAnimation
{
    [UIView animateWithDuration:.3 animations:^{
        backView.frame=CGRectMake(0, -140, 320, [UIScreen mainScreen].bounds.size.height+150);
    }];
}
-(void)stopAnimation
{
    [UIView animateWithDuration:.3 animations:^{
        backView.frame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height+100);
    }];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"])
        
    {
        
        [textView resignFirstResponder];
        [self stopAnimation];
        return NO;
        
    }
    
    return YES;
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self startAnimation];
    return YES;
}
#pragma mark - asihttprequest
//网络判断
-(Boolean)isconnectok{
    NSURL *url1 = [NSURL URLWithString:@"http://www.baidu.com"];
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
-(void)feedBackRequest
{
    if ([self isconnectok])
    {
        [MyActivceView startAnimatedInView:self.view];
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://interface.hcgjzs.com/OM_Interface/Feedback.asmx"]];
        NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                           <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                           <soap:Body>\
                           <Add xmlns=\"http://tempuri.org/\">\
                           <content>%@</content>\
                           <tel>%@</tel>\
                           </Add>\
                           </soap:Body>\
                           </soap:Envelope>",aTextView.text,atextField.text];
        [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
        [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
        [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
        [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/Add"];
        [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
        request.delegate=self;
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"无网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (void)requestStarted:(ASIHTTPRequest *)request
{
   // NSLog(@"请求开始");
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    [MyActivceView stopAnimatedInView:self.view];
  //  NSLog(@"----->>%@",request.responseString);
    //解析
    NSString *nameStr=[self ConverfromData:request.responseData name:@"Add"];
  //  NSLog(@"--%@",nameStr);
//    SBJSON  *sbJson=[[SBJSON alloc] init];
//    NSDictionary *dic=[sbJson objectWithString:request.responseString error:nil];
//    NSString *nameStr=[dic objectForKey:@"AddResult"];
//    NSLog(@"____%@",nameStr);
    NSString *contentStr;
    if ([nameStr intValue]==1)
    {
        contentStr=@"您的反馈已发送成功，谢谢您的使用！";
        p=00000;
    }
    else if ([nameStr intValue]==0)
    {
        contentStr=@"对不起，反馈发送失败，请重新发送。";
    }
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:contentStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.delegate=self;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        if (p==00000)
        {
            atextField.text=nil;
            aTextView.text=nil;
            [atextField resignFirstResponder];
            aTextView.placeholder=@"请输入反馈内容(200字以内)";
            [self backClick];
        }
    }

}
-(NSString *)ConverfromData:(NSData *)aData name:(NSString *)aName
{
    NSString * str1 = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    NSString *separerstr=[NSString stringWithFormat:@"%@Result",aName];
    if ([str1 rangeOfString:separerstr].length>0)
    {
        NSArray *arr=[str1 componentsSeparatedByString:separerstr];
        //根据以字符串分割字符串
        NSString *jsonStr=[arr objectAtIndex:1];
        //去除没用的部分 得到json格式的部分
        jsonStr=[jsonStr substringWithRange:NSMakeRange(1, jsonStr.length-3)];
        // NSArray * arrResult = [jsonStr objectFromJSONString];
       // SBJSON *json=[[SBJSON alloc] init];
      //  NSString * arrResult =  [json objectWithString:jsonStr error:nil];
        return jsonStr;
    }
    return nil;
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
//    <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><AddResponse xmlns="http://tempuri.org/"><AddResult>1</AddResult></AddResponse></soap:Body></soap:Envelope>
}
-(void)backClick
{
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [atextField resignFirstResponder];
    [aTextView resignFirstResponder];
    [self stopAnimation];
}
- (void)keyboardWillShow:(NSNotification *)notif
{
    [self startAnimation];
}
- (void)keyboardWillHide:(NSNotification *)notif
{
    [self stopAnimation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
