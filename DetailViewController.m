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
#import "UMSocial.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize aTableView;
@synthesize numLab;
@synthesize detailAry;
@synthesize imageview,aLab,aText,addressLab;
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
    aBtn.frame=CGRectMake(0, 0, 60, 60);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(8, 52, 320-16, 83)];
   // aView.backgroundColor=[UIColor redColor];
    [self.view addSubview:aView];
    [aView.layer setBorderWidth:0.5];
    [aView.layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"DotedImage.png"]] CGColor]];
    aView.layer.borderColor=[UIColor grayColor].CGColor;
    aView.layer.borderWidth=0.5;
    aView.layer.cornerRadius =5.0;
    
    imageview=[[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 54, 54)];
    //imageview.image=[UIImage imageNamed:@"a.jpg"];
    [aView addSubview:imageview];
    aLab=[[UILabel alloc] initWithFrame:CGRectMake(73, 23, 180, 20)];
    //aLab.text=@"河南天空科技有限公司";
    //aLab.text=[detailAry valueForKey:@"restname"];
    //    aLab.text=[[detailAry objectAtIndex:0] valueForKey:@"restname"];
    [aView addSubview:aLab];
    UIImageView *startimageview=[[UIImageView alloc] initWithFrame:CGRectMake(210, 60, 85, 16)];
    startimageview.image=[UIImage imageNamed:@"开始点菜"];
    [aView addSubview:startimageview];
    UIButton *startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame=CGRectMake(200, 50, 105, 36);
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:startBtn];
    
    UIImageView  *yellowImage=[[UIImageView alloc] initWithFrame:CGRectMake(8, 141, 320-16, 138)];
    yellowImage.backgroundColor=[UIColor colorWithRed:253.0/255.0 green:240.0/255.0 blue:223.0/255.0 alpha:1.0];
    [self.view addSubview:yellowImage];
    UIImageView  *yellowImage2=[[UIImageView alloc] initWithFrame:CGRectMake(8, 254, 320-16, 25)];
    yellowImage2.backgroundColor=[UIColor colorWithRed:253.0/255.0 green:226.0/255.0 blue:196.0/255.0 alpha:1.0];
    [self.view addSubview:yellowImage2];
    //餐馆介绍
    aText=[[UITextView alloc] initWithFrame:CGRectMake(8, 150, 320-16, 110)];
    //aText.text=@"河南仲记企业创始于1999年，立足于服务行业，以餐饮为核心产业，传承儒家文化之精髓，倡导仁、义、礼、智、信得儒家理念，是一家集中餐酒楼，公益慈善、绿色食品、文化教育为一体的多元化集团企业，仲记酒楼正光路店2012年盛大开幕，现需诚聘大量英才加入我们的团队。";
    aText.backgroundColor=[UIColor clearColor];
    aText.editable=NO;
    [self.view addSubview:aText];
    UIImageView  *yellowImage3=[[UIImageView alloc] initWithFrame:CGRectMake(8, 288, 320-16, [UIScreen mainScreen].bounds.size.height-312-5)];
    yellowImage3.backgroundColor=[UIColor colorWithRed:253.0/255.0 green:240.0/255.0 blue:223.0/255.0 alpha:1.0];
    [self.view addSubview:yellowImage3];
    //地址，电话，信息
    UIView *addressView=[[UIView alloc] initWithFrame:CGRectMake(20,296, 280, 70)];
    addressView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    //圆角
    addressView.layer.borderColor=[UIColor grayColor].CGColor;
    addressView.layer.borderWidth=0.5;
    addressView.layer.cornerRadius =5.0;
    //边框颜色
    addressView.layer.borderColor=[[UIColor clearColor] CGColor];
    //阴影
    addressView.layer.shadowColor = [UIColor grayColor].CGColor;
    addressView.layer.shadowOpacity = 1.0;
    addressView.layer.shadowRadius = 1.0;
    addressView.layer.shadowOffset = CGSizeMake(0, 3);
    addressView.clipsToBounds = NO;
    [self.view addSubview:addressView];
    
    UIImageView *addressImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
    addressImage.image=[UIImage imageNamed:@"位置图标"];
    [addressView addSubview:addressImage];
    UIImageView *numImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 20, 20)];
    numImage.image=[UIImage imageNamed:@"电话图标"];
    [addressView addSubview:numImage];
    addressLab=[[UILabel alloc] initWithFrame:CGRectMake(35, 5, 230, 30)];
    addressLab.backgroundColor=[UIColor clearColor];
    addressLab.font=[UIFont fontWithName:@"Arial" size:15.0f];
    //addressLab.text=@"花园路国基路交叉口往北100米路西";
    [addressView addSubview:addressLab];
    numLab=[[UILabel alloc] initWithFrame:CGRectMake(35, 35, 200, 30)];
    numLab.backgroundColor=[UIColor clearColor];
    numLab.font=[UIFont fontWithName:@"Arial" size:15.0f];
    //numLab.text=@"0371-88888815";
    [addressView addSubview:numLab];
    //餐馆营业时间，氛围，特色
    UILabel  *Lab1=[[UILabel alloc] initWithFrame:CGRectMake(30, 385, 100, 15)];
    Lab1.backgroundColor=[UIColor clearColor];
    Lab1.font=[UIFont fontWithName:@"Arial" size:15.0f];
    Lab1.text=@"营业时间：";
    [self.view addSubview:Lab1];
    UILabel  *Lab2=[[UILabel alloc] initWithFrame:CGRectMake(30, 410, 100, 15)];
    Lab2.backgroundColor=[UIColor clearColor];
    Lab2.font=[UIFont fontWithName:@"Arial" size:15.0f];
    Lab2.text=@"餐厅氛围：";
    [self.view addSubview:Lab2];
    UILabel  *Lab3=[[UILabel alloc] initWithFrame:CGRectMake(30, 435, 100, 15)];
    Lab3.backgroundColor=[UIColor clearColor];
    Lab3.font=[UIFont fontWithName:@"Arial" size:15.0f];
    Lab3.text=@"餐厅特色：";
    [self.view addSubview:Lab3];
    UILabel  *Lab11=[[UILabel alloc] initWithFrame:CGRectMake(100, 385, 200, 15)];
    Lab11.backgroundColor=[UIColor clearColor];
    Lab11.font=[UIFont fontWithName:@"Arial" size:15.0f];
    Lab11.text=@"早10:00-14:00晚17:00-22:00";
    [self.view addSubview:Lab11];
    UILabel  *Lab22=[[UILabel alloc] initWithFrame:CGRectMake(100, 410, 200, 15)];
    Lab22.backgroundColor=[UIColor clearColor];
    Lab22.font=[UIFont fontWithName:@"Arial" size:15.0f];
    Lab22.text=@"朋友聚餐 家庭聚会 商务宴请";
    [self.view addSubview:Lab22];
    UILabel  *Lab33=[[UILabel alloc] initWithFrame:CGRectMake(100, 435, 200, 15)];
    Lab33.backgroundColor=[UIColor clearColor];
    Lab33.font=[UIFont fontWithName:@"Arial" size:15.0f];
    Lab33.text=@"免费停车";
    [self.view addSubview:Lab33];
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
    commitBtn.frame=CGRectMake(225, 0, 47, 50);
    [commitBtn addTarget:self action:@selector(commitContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    
}
-(void)commitContent
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"51dccb0456240b7f87001d5e"
                                      shareText:@"我现在在汉丽轩吃饭，在用点美点进行点餐，用起来不错，推荐给大家。@DMD #点美点# ，随意选就餐环境、菜品、预定座位、在线点餐，尽在指尖，点即动美食定！"
                                     shareImage:[UIImage imageNamed:@"c.jpg"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechat,UMShareToDouban,UMShareToQzone,nil]
                                       delegate:nil];
}
//打电话
-(void)callNum:(id)sender
{
    //返回本程序
        UIWebView *callPhoneWebVw = [[UIWebView alloc] init];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numLab.text]]];
//        NSLog(@"%@",numLab);
        [callPhoneWebVw loadRequest:request];
        [self.view addSubview:callPhoneWebVw];
    //跳出本程序
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numberStr]]];
}
-(void)startClick
{
   
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    //右边小箭头
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // cell.textLabel.text=[ary objectAtIndex:indexPath.row];
    //    XmlStriing *xmlStr=[self.array objectAtIndex:indexPath.row];
    //    cell.lab.text=xmlStr.titleCnString;
    //    cell.lab2.text=xmlStr.authorString;
    //    cell.timeLab.text=xmlStr.publishTimeString;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110;//此处返回cell的高度
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [self detailClick:nil];
    //  [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
