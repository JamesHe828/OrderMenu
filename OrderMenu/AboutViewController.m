//
//  AboutViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-8.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface AboutViewController ()

@end

@implementation AboutViewController

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
    aImageView.image=[UIImage imageNamed:@"关于我们"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.showsTouchWhenHighlighted=YES;
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImageView *handImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 155, 320, 249)];
//    handImage.image=[UIImage imageNamed:@"手"];
//    [self.view addSubview:handImage];
    UIImageView *xiaorenImage=[[UIImageView alloc] initWithFrame:CGRectMake(105, 70, 108, 137)];
    xiaorenImage.image=[UIImage imageNamed:@"关于我们背景"];
    [self.view addSubview:xiaorenImage];

//    UIImageView *piontImage=[[UIImageView alloc] initWithFrame:CGRectMake(99, 179, 97, 34)];
//    piontImage.image=[UIImage imageNamed:@"点美点"];
//    [self.view addSubview:piontImage];
    UIImageView *logoImage=[[UIImageView alloc] initWithFrame:CGRectMake(99, 400, 97, 34)];
    logoImage.image=[UIImage imageNamed:@"天空logo"];
    [self.view addSubview:logoImage];
//    [UIScreen mainScreen].bounds.size.height
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(37, 236, 70, 70)];
    lab.text=@"版本:";
    lab.backgroundColor=[UIColor clearColor];
    lab.textColor=[UIColor grayColor];
    [self.view addSubview:lab];
    UILabel *lab1=[[UILabel alloc] initWithFrame:CGRectMake(90, 236, 70, 70)];
    lab1.text=@"V1.0";
    lab1.backgroundColor=[UIColor clearColor];
    lab1.textColor=[UIColor grayColor];
    [self.view addSubview:lab1];
    UILabel *lab2=[[UILabel alloc] initWithFrame:CGRectMake(37, 260, 70, 70)];
    lab2.text=@"官网:";
    lab2.backgroundColor=[UIColor clearColor];
    lab2.textColor=[UIColor grayColor];
    [self.view addSubview:lab2];
    UILabel *lab22=[[UILabel alloc] initWithFrame:CGRectMake(90, 260, 200, 70)];
    lab22.text=@"www.tiankong360.com";
    lab22.backgroundColor=[UIColor clearColor];
    lab22.textColor=[UIColor grayColor];
    [self.view addSubview:lab22];
    UILabel *lab3=[[UILabel alloc] initWithFrame:CGRectMake(37, 285, 100, 70)];
    lab3.text=@"客服邮箱:";
    lab3.backgroundColor=[UIColor clearColor];
    lab3.textColor=[UIColor grayColor];
    [self.view addSubview:lab3];
    UILabel *lab33=[[UILabel alloc] initWithFrame:CGRectMake(110, 285, 200, 70)];
    lab33.text=@"tiankong360@163.com";
    lab33.backgroundColor=[UIColor clearColor];
    lab33.textColor=[UIColor grayColor];
    [self.view addSubview:lab33];
    UILabel *lab4=[[UILabel alloc] initWithFrame:CGRectMake(37, 310, 100, 70)];
    lab4.text=@"联系电话:";
    lab4.backgroundColor=[UIColor clearColor];
    lab4.textColor=[UIColor grayColor];
    [self.view addSubview:lab4];
    UILabel *lab44=[[UILabel alloc] initWithFrame:CGRectMake(110, 310, 200, 70)];
    lab44.text=@"0371-88888818/5";
    lab44.backgroundColor=[UIColor clearColor];
    lab44.textColor=[UIColor grayColor];
    [self.view addSubview:lab44];
    UILabel *lab5=[[UILabel alloc] initWithFrame:CGRectMake(66, 430, 200, 30)];
    lab5.text=@"www.tiankong360.com";
    lab5.textColor=[UIColor colorWithRed:251.0/255.0 green:33.0/255.0 blue:47.0/255.0 alpha:1.0];
    [self.view addSubview:lab5];

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
-(void)backClick
{
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
