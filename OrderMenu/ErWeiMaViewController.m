//
//  ErWeiMaViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-8-16.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "ErWeiMaViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ErWeiMaViewController ()

@end

@implementation ErWeiMaViewController
@synthesize alab;
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
    aImageView.image=[UIImage imageNamed:@"扫码识物2"];
    [self.view addSubview:aImageView];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.showsTouchWhenHighlighted=YES;
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(100, 100, 100, 50);
    [btn addTarget:self action:@selector(ScanCode) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开始扫描" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    //手势
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    alab=[[UILabel alloc] initWithFrame:CGRectMake(50, 200, 300, 50)];
    [self.view addSubview:alab];
    alab.backgroundColor=[UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StopAnimation) name:@"tapGesture" object:nil];
    
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
-(void)ScanCode
{
//    zbarReaderView = [ZBarReaderView new];
//    zbarReaderView.backgroundColor = [UIColor blackColor];
//    zbarReaderView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);
//    zbarReaderView.backgroundColor =  [UIColor colorWithRed:239/255.0f green:223/255.0f blue:210/255.0f alpha:1.0f];
//    [self.view addSubview:zbarReaderView];
//    [UIView animateWithDuration:.3 animations:^{
//       zbarReaderView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height); 
//    }];
//    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    aImageView.image=[UIImage imageNamed:@"正在扫描"];
//    [zbarReaderView addSubview:aImageView];
//    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    aBtn.frame=CGRectMake(0, 0, 44, 44);
//    aBtn.showsTouchWhenHighlighted=YES;
//    [zbarReaderView addSubview:aBtn];
//    [aBtn addTarget:self action:@selector(StopAnimation) forControlEvents:UIControlEventTouchUpInside];
//    //    UIImageView  *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 50, 50)];
//    //    image.image=[UIImage imageNamed:@"zbar-helpicons.png"];
//    //    [zbarReaderView addSubview:image];
//    /*扫描框线*/
//    scannerLine = [[UIImageView alloc] initWithFrame:CGRectMake(33, 97, 254, 238)];
//    scannerLine.image = [UIImage imageNamed:@"chacha_auto_reader_scannerline.png"];
//    zbarReaderView.tracksSymbols=NO;
//    [zbarReaderView addSubview:scannerLine];
//    zbarReaderView.readerDelegate = self;
//    [zbarReaderView start];
//    [self circurationAnimation];
    
}
-(void)circurationAnimation
{
//    imageLine=[[UIImageView alloc] initWithFrame:CGRectMake(33, 97, 254, 2)];
//    [zbarReaderView addSubview:imageLine];
//    imageLine.backgroundColor=[UIColor greenColor];
//    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat animations:^{
//        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//        imageLine.frame=CGRectMake(33, 238+97-2, 254, 2);
//    } completion:^(BOOL finished) {
//        imageLine.frame=CGRectMake(33, 97, 254, 2);
//    }];
}
/**
 *扫描界面代理
 */
//- (void) readerView: (ZBarReaderView*) view
//     didReadSymbols: (ZBarSymbolSet*) syms
//          fromImage: (UIImage*) img
//{
//    for(ZBarSymbol *sym in syms)
//    {
//        //刷新扫描缓冲区
//        [zbarReaderView flushCache];
//        
//        //根据条形码的类别或者当前所在分区，进行业务分发
//        NSLog(@"===sym.type===>%d",sym.type);
//        NSLog(@"===sym.data===>%@",sym.data);
//        alab.text=sym.data;
//        [zbarReaderView stop];
//        [self StopAnimation];
//    }
//    
//    //    sym.type   是区分条形码和二维码的
//    //    sym.data  是码值
//}
-(void)StopAnimation
{
//    [UIView animateWithDuration:.3 animations:^{
//        zbarReaderView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);
//    } completion:^(BOOL finished) {
//        [zbarReaderView removeFromSuperview];
//    }];
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
