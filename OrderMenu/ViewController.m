//
//  ViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "ViewController.h"
#import "EateryViewController.h"
#import "SearchViewController.h"
#import "SettingViewController.h"
#import "CollectViewController.h"
#import "OrderListViewController.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:backImageView];
    if ( [UIScreen mainScreen].bounds.size.height==568)
    {
        backImageView.image=[UIImage imageNamed:@"首页背景568.png"];
    }
    else
    {
        backImageView.image=[UIImage imageNamed:@"首页背景"];
    }
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"主界面导航"];
    //aImageView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:aImageView];
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(320-49, 0, 44, 44);
    searchBtn.showsTouchWhenHighlighted=YES;
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *pointBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    pointBtn.frame=CGRectMake(100, 150, 88, 88);
    pointBtn.center=CGPointMake(160, [UIScreen mainScreen].bounds.size.height-157-44-10);
    [pointBtn addTarget:self action:@selector(pointBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pointBtn];
    UIButton *indentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    indentBtn.frame=CGRectMake(46, [UIScreen mainScreen].bounds.size.height-74-106-10, 74, 74);
    [indentBtn addTarget:self action:@selector(indentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:indentBtn];
    UIButton *collectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame=CGRectMake(202, [UIScreen mainScreen].bounds.size.height-74-106-10, 74, 74);
    [collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectBtn];
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame=CGRectMake(110, 370, 74, 74);
    settingBtn.center=CGPointMake(160, [UIScreen mainScreen].bounds.size.height-61-37-10);
    [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    [pointBtn setImage:[UIImage imageNamed:@"点餐"] forState:UIControlStateNormal];
    [indentBtn setImage:[UIImage imageNamed:@"订单"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
//    //养生图片
//	ascrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 132)];
//    [self.view addSubview:ascrollview];
//    ascrollview.pagingEnabled=YES;
//    ascrollview.showsHorizontalScrollIndicator=NO;
//    ascrollview.delegate=self;
//    ascrollview.contentSize=CGSizeMake(320*5, 132);
//    for (int i = 0 ; i<5; i++) {
//        UIImageView *aImage = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 132)];
//        aImage.userInteractionEnabled = YES;
//        aImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"最佳推荐%d",i+1]];
//        [ascrollview addSubview:aImage];
//        
//    }
////    for (int j=0; j<5; j++)
////    {
////        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
////        btn.frame=CGRectMake(320*j, 0, 320, 132);
////        [btn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
////        [ascrollview addSubview:btn];
////    }
//    pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(120,126+44-14+10, 100, 10)];
//    pageC.numberOfPages = 5;
//    pageC.currentPage=0;
//    [self.view addSubview:pageC];

    
    //定时滚动
//    CGPoint bottomOffset = CGPointMake(self.ascrollview.contentOffset.x, self.ascrollview.contentSize.height - self.ascrollview.bounds.size.height);
//    CGPoint bottomOffset = CGPointMake(self.ascrollview.contentSize.width-self.ascrollview.bounds.size.width,self.ascrollview.contentOffset.y);
    //设置延迟时间
//    float scrollDurationInSeconds = 5.0;
//    
//    //计算timer间隔
//    [NSTimer scheduledTimerWithTimeInterval:scrollDurationInSeconds target:self selector:@selector(scrollScrollView:) userInfo:nil repeats:YES];

}
-(void)pointBtnClick
{
    EateryViewController *eatVC=[[EateryViewController alloc] init];
    [self.navigationController pushViewController:eatVC animated:YES];
}
-(void)indentBtnClick
{
    OrderListViewController * orderList;
    if (IPhone5)
    {
        orderList = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:nil];
    }
    else
    {
        orderList = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController4" bundle:nil];
    }
    [self.navigationController pushViewController:orderList animated:YES];
}
-(void)collectBtnClick
{
    CollectViewController *collectVC=[[CollectViewController alloc] init];
    [self.navigationController pushViewController:collectVC animated:YES];
}
-(void)settingBtnClick
{
    SettingViewController *setVC=[[SettingViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}
-(void)searchClick
{
    SearchViewController *searchVC2=[[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC2 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
