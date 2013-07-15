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
    aBtn.frame=CGRectMake(0, 0, 60, 60);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //白色底
    UIView *numView=[[UIView alloc] initWithFrame:CGRectMake(12, 100, 277, 40)];
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
    UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake(12, 185, 277, 195)];
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
    UILabel  *numLab=[[UILabel alloc] initWithFrame:CGRectMake(12, 57, 100, 50)];
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
    UILabel  *contentLab=[[UILabel alloc] initWithFrame:CGRectMake(12, 140, 100, 50)];
    contentLab.text=@"反馈内容:";
    contentLab.font=[UIFont fontWithName:@"Arial" size:20.0f];
    contentLab.backgroundColor=[UIColor clearColor];
    [backView addSubview:contentLab];
    aTextView=[[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(3, 3, 280, 195)];
    aTextView.placeholder=@"请输入反馈内容";
    aTextView.backgroundColor=[UIColor clearColor];
    aTextView.delegate=self;
    aTextView.font=[UIFont fontWithName:@"Arial" size:18.0f];
    aTextView.returnKeyType=UIReturnKeyDone;
    [contentView addSubview:aTextView];
    
    UIButton *commitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame=CGRectMake(230, 0, 60, 50);
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


}
-(void)commitFeedContent
{
    [aTextView resignFirstResponder];
    [self stopAnimation];
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
-(void)backClick
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
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
