//
//  DishesListViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-10.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DishesListViewController.h"
#import "DishesDetailListCell.h"
#import "DishesClassCell.h"
#import "DishesSelectedButton.h"
#import "AudoViewController.h"
#import "SumbitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"
#import "DataBase.h"

@interface DishesListViewController ()
{
    int selectRow;
    
}
@property (nonatomic,strong) NSMutableArray * myClassArr;
@property (nonatomic,strong) UIButton * audoButton;
@property (nonatomic,strong) NSMutableArray * myProArr;
@property (nonatomic,strong) UIButton * backButton;
-(IBAction)backClick:(id)sender;
-(void)dishesClickEvent:(DishesSelectedButton *)aButton;
-(IBAction)audoClickEvent:(id)sender;
-(void)getClassData;
-(void)getProductData:(NSString *)aClassid;
@end

@implementation DishesListViewController
@synthesize classTableView;
@synthesize productTableView;
@synthesize myClassArr;
@synthesize myProArr;
@synthesize audoButton;
@synthesize backButton;
@synthesize resultID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //添加底部
    PriceView * pcView = [PriceView ShareView];
    pcView.delegate = self;
    [self.view addSubview:pcView];
}
-(IBAction)backClick:(id)sender
{
    [DataBase clearOrderMenu];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //清楚数据库中得数据
    [DataBase clearOrderMenu];
    selectRow = 0;
    self.classTableView.bounces = NO;
    self.productTableView.bounces = NO;
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.classTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getClassData];
    });
}
#pragma mark - get data
-(void)getClassData
{
    ASIHTTPRequest * request = [WebService classInterfaceConfig:self.resultID];
    [request startAsynchronous];
    NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
    [request setStartedBlock:^{
        [MyActivceView startAnimatedInView:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    [request setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.myClassArr = (NSMutableArray *)[NSString ConverfromData:reciveData name:CLASS_NAME];
            if (self.myClassArr.count>0)
            {
                [self.classTableView reloadData];
                [self getProductData:[[self.myClassArr objectAtIndex:0] valueForKey:@"classID"]];
            }
            else
            {
                [MyActivceView stopAnimatedInView:self.view];
                [MyAlert ShowAlertMessage:@"此餐单还未上传！" title:@"提示"];
            }
        });
    }];
}
-(void)getProductData:(NSString *)aClassid
{
    ASIHTTPRequest * request = [WebService ProductListConfig:aClassid];
    [request startAsynchronous];
    NSMutableData * reciveData1 = [NSMutableData dataWithCapacity:0];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData1 appendData:data];
    }];
    [request setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        self.myProArr = [NSMutableArray arrayWithArray:[NSString ConverfromData:reciveData1 name:PRODUCT_NAME]];
       [self.productTableView reloadData];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101)
    {
        return 80;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100)
    {
        return self.myClassArr.count;
    }
    return self.myProArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100)
    {
        static NSString * strMark = @"cellMark";
        DishesClassCell * cell = [tableView dequeueReusableCellWithIdentifier:strMark];
        if (cell == nil)
        {
            cell = [[DishesClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMark];
        }
        if (indexPath.row == 0)
        {
            cell.backgroundImageView.image = [UIImage imageNamed:@"3.png"];
        }
        if (indexPath.row<self.myClassArr.count)
        {
            cell.textContentLab.text = [[self.myClassArr objectAtIndex:indexPath.row] valueForKey:@"ClassName"];
        }
        else
        {
            cell.backgroundImageView.image = [UIImage imageNamed:@""];
        }
        
        return cell;
    }
    
    NSString *str1 = [NSString stringWithFormat:@"cellmark%d",selectRow];
    NSString * strMark1 = str1; //不停类别用不同的重用标示符，目的是为了不同分类同一位置的重用现象。
    DishesDetailListCell * cell1 = [tableView dequeueReusableCellWithIdentifier:strMark1];
    if (cell1 == nil)
    {
        cell1 = [[DishesDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMark1];
    }
    if (indexPath.row%2 == 0)
    {
        cell1.backgroundImageView.image = [UIImage imageNamed:@"5.png"];
    }
    else
    {
        cell1.backgroundImageView.image = [UIImage imageNamed:@"6.png"];
    }
    cell1.selectionStyle=UITableViewCellSelectionStyleNone;
    cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
    cell1.titleLab.text = [[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProName"];
    NSString * str = @"￥";
    NSString * priceStr = [[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"prices"];
    cell1.priceLab.text = [str stringByAppendingFormat:@"%@",priceStr];
    cell1.dishesButton.price = [priceStr doubleValue];
    [cell1.dishesButton addTarget:self action:@selector(dishesClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell1.dishesButton.rowNum = indexPath.row;
    NSString * pathURL = ALL_URL;
    NSURL * url = [NSURL URLWithString:[pathURL stringByAppendingFormat:@"%@",[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProductImg"]]];
    [cell1.leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:ALL_NO_IMAGE]];
    return cell1;
}
#pragma mark - 点菜触发事件
-(void)dishesClickEvent:(DishesSelectedButton *)aButton
{
    if (aButton.isSelect == YES)
    {
        DishesDetailListCell * cell = (DishesDetailListCell *)[aButton superview];
        //加入购物车动画效果
        CALayer *transitionLayer = [[CALayer alloc] init];
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        transitionLayer.opacity = 0.4;
        transitionLayer.contents = (id)cell.layer.contents;
        transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:cell.bounds fromView:cell];
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
        [CATransaction commit];
        
        //路径曲线
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:transitionLayer.position];
        CGPoint toPoint = CGPointMake([PriceView ShareView].center.x, [PriceView ShareView].center.y+100);
        [movePath addQuadCurveToPoint:toPoint
                         controlPoint:CGPointMake([PriceView ShareView].center.x,transitionLayer.position.y-50)];
        //关键帧
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.path = movePath.CGPath;
        positionAnimation.removedOnCompletion = YES;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.beginTime = CACurrentMediaTime();
        group.duration = 0.7;
        group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
        group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        group.autoreverses= NO;
        [transitionLayer addAnimation:group forKey:@"opacity"];
    }
    
    if ([PriceView ShareView].sumnumber == 0)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        self.classTableView.frame = CGRectMake(self.classTableView.frame.origin.x,self.classTableView.frame.origin.y,self.classTableView.frame.size.width,self.classTableView.frame.size.height-40);
        self.productTableView.frame = CGRectMake(self.productTableView.frame.origin.x,self.productTableView.frame.origin.y,self.productTableView.frame.size.width,self.productTableView.frame.size.height-40);
        [UIView commitAnimations];
        
        [PriceView AnimateCome];
        [[PriceView ShareView] ChangeLabTextSumPrice:aButton.price sumDishes:1];
    }
    else
    {
        double priceSum = [PriceView ShareView].sumprice;
        int numberSum = [PriceView ShareView].sumnumber;
        if (aButton.isSelect)
        {
            [[PriceView ShareView] ChangeLabTextSumPrice:priceSum+aButton.price sumDishes:numberSum+1];
        }
        else
        {
            [[PriceView ShareView] ChangeLabTextSumPrice:priceSum-aButton.price sumDishes:numberSum-1];
            if (numberSum-1 == 0)
            {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.7];
                self.classTableView.frame = CGRectMake(self.classTableView.frame.origin.x,self.classTableView.frame.origin.y,self.classTableView.frame.size.width,self.classTableView.frame.size.height+40);
                self.productTableView.frame = CGRectMake(self.productTableView.frame.origin.x,self.productTableView.frame.origin.y,self.productTableView.frame.size.width,self.productTableView.frame.size.height+40);
                [UIView commitAnimations];
                [PriceView AnimateCancle];
            }
        }
    }
    
    if (aButton.isSelect)
    {
        NSDictionary * obj = [self.myProArr objectAtIndex:aButton.rowNum];
        [DataBase insertProID:[[obj valueForKey:@"ProID"] intValue] menuid:[[obj valueForKey:@"Menuid"] intValue] proName:[obj valueForKey:@"ProName"] price:[[obj valueForKey:@"prices"] doubleValue] image:[obj valueForKey:@"ProductImg"]];
    }
    else
    {
        NSDictionary * obj = [self.myProArr objectAtIndex:aButton.rowNum];
        [DataBase deleteProID:[[obj valueForKey:@"ProID"] intValue]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectRow = indexPath.row;
    if (tableView.tag == 100)
    {
        NSArray * cells = [self.classTableView visibleCells];
        [cells enumerateObjectsUsingBlock:^(DishesClassCell * obj, NSUInteger idx, BOOL *stop) {
            if (idx == selectRow)
            {
                obj.backgroundImageView.image = [UIImage imageNamed:@"3.png"];
            }
            else
            {
                obj.backgroundImageView.image = [UIImage imageNamed:@"4.png"];
            }
        }];
        if (self.myProArr.count > 0)
        {
            [self.myProArr removeAllObjects];
        }
        NSString * classid = [[self.myClassArr objectAtIndex:indexPath.row] valueForKey:@"classID"];
        [self getProductData:classid];
    }
}
#pragma mark - 点击智能点菜按钮出发事件
-(IBAction)audoClickEvent:(id)sender
{
    AudoViewController * audo;
    if (IPhone5)
    {
        audo = [[AudoViewController alloc] initWithNibName:@"AudoViewController" bundle:nil];
    }
    else
    {
        audo = [[AudoViewController alloc] initWithNibName:@"AudoViewController4" bundle:nil];
    }
    audo.resultID = self.resultID;
    [self.navigationController pushViewController:audo animated:YES];
}

-(void)nextClick
{
    SumbitViewController * sumbit;
    if (IPhone5)
    {
        sumbit = [[SumbitViewController alloc] initWithNibName:@"SumbitViewController" bundle:nil];
    }
    else
    {
        sumbit = [[SumbitViewController alloc] initWithNibName:@"SumbitViewController4" bundle:nil];
    }
    sumbit.restId = [NSString stringWithFormat:@"%d",self.resultID];
    NSString * idStr = [DataBase selectAllProId];
    if (idStr.length>0)
    {
        sumbit.idStr = idStr;
        [self.navigationController pushViewController:sumbit animated:YES];
    }
    else
    {
        [MyAlert ShowAlertMessage:@"您还没有进行点菜！" title:@"提示"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
