//
//  OrderListViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-19.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListCell.h"
#import "DishesSelectedButton.h"
#import "OrderDetailViewController.h"
#import "DataBase.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface OrderListViewController ()
{
    int i;
}
@property (nonatomic,strong)NSMutableArray * datasourseArr;
@property (nonatomic,strong)NSMutableArray * resultArr;
@property (nonatomic,strong)NSArray * tellArr;
@property (nonatomic,strong)IBOutlet UIButton * noSumBtn;
@property (nonatomic,strong)IBOutlet UIButton * yesSumBtn;
@property (nonatomic,strong)IBOutlet UIImageView * bgImageView;
@property (nonatomic)int selectedSegmentIndex;

-(IBAction)backClick:(id)sender;
-(void)deleteClick:(DishesSelectedButton *)aButton;
-(void)getData:(int)aIndex;
-(void)getDatafromDatabase;

-(IBAction)noSumbitBtnClick:(id)sender;
-(IBAction)yesSumBtnClick:(id)sender;
@end

@implementation OrderListViewController
@synthesize orderTableView;
@synthesize datasourseArr;
@synthesize tellArr;
@synthesize resultArr;
@synthesize noSumBtn;
@synthesize yesSumBtn;
@synthesize selectedSegmentIndex;
@synthesize bgImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.selectedSegmentIndex == 0)
    {
        [self viewDidLoad];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aView.backgroundColor=[UIColor colorWithRed:252.0/255.0 green:33.0/255.0 blue:47.0/255.0 alpha:1.0];
    [self.view addSubview:aView];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
    titleLab.backgroundColor=[UIColor clearColor];
    titleLab.textColor=[UIColor whiteColor];
    titleLab.text=@"我的订单";
    titleLab.textAlignment=NSTextAlignmentCenter;
    [aView addSubview:titleLab];
    self.tellArr = [DataBase selectTellNumber];
    self.datasourseArr = [NSMutableArray arrayWithCapacity:0];
    self.resultArr = [NSMutableArray arrayWithCapacity:0];
    self.orderTableView.bounces = NO;
    
    [self getDatafromDatabase];
}
#pragma mark - 未提交订单  获取数据
-(void)getDatafromDatabase
{
    if (self.resultArr.count>0)
    {
        [self.resultArr removeAllObjects];
    }

    self.resultArr = [DataBase selectAllNoSaveResult];
    [self.orderTableView reloadData];
}
#pragma mark - get data
-(void)getData:(int)aIndex
{
    [self.resultArr removeAllObjects];
    NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
    ASIHTTPRequest * request = [WebService GetOrderList:[self.tellArr objectAtIndex:i]];
    [request startAsynchronous];
    [request setStartedBlock:^{
        if (i == 0)
        {
            [MyActivceView startAnimatedInView:self.view];
        }
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    __block NSArray * arr;
    [request setCompletionBlock:^{
        arr = [NSString ConverfromData:reciveData name:ORDER_GETORDERLIST];
        [self.datasourseArr addObject:arr];
        i++;
        if (i<self.tellArr.count)
        {
            [self getData:i];
        }
        if (i == self.tellArr.count)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MyActivceView stopAnimatedInView:self.view];
                [self.datasourseArr enumerateObjectsUsingBlock:^(NSArray * arr, NSUInteger idx, BOOL *stop) {
                    [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                        if (obj.count>0)
                        {
                            [self.resultArr addObject:obj];
                        }
                    }];
                }];
                [self.datasourseArr removeAllObjects];
                [self.orderTableView reloadData];
            });
        }
    }];
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
    }];
}

-(IBAction)backClick:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedSegmentIndex == 1)
    {
        static NSString * strMark = @"orderMark";
        OrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:strMark];
        if (cell == nil)
        {
            cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMark];
        }
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5.png"]];
       cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        NSString * url = [ALL_URL stringByAppendingFormat:@"%@",[[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"restimg"]];
        [cell.leftImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"no.png"]];
        cell.resultNameLab.text = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"restName"];
        NSString * orderNum = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"OrderNum"];
        cell.orderNumberLab.text = [NSString stringWithFormat:@"订单:%@",orderNum];
        cell.orderTimeLab.text = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"addtime"];
        
        cell.resultAdressLab.text = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"restAdress"];
        cell.deleteBtn.rowNum = indexPath.row;
       // [cell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        static NSString * str = @"cellMark";
        OrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil)
        {
            cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5.png"]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.timeImageView.frame = CGRectMake(71, 26, 8, 8);
        cell.orderTimeLab.frame = CGRectMake(80,23, 92, 15);
        cell.orderNumberLab.alpha = 0.0;
        cell.deleteBtn.rowNum = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.orderTimeLab.text = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"orderTime"];
        cell.resultNameLab.text = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"resultName"];
        NSString * url = [ALL_URL stringByAppendingFormat:@"%@",[[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"proImage"]];
        [cell.leftImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"no.png"]];
        cell.resultAdressLab.text = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"adress"];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//删除
//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if ([tableView isEqual:self.orderTableView])
    {
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.orderTableView setEditing:editing animated:animated];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        OrderListCell * cell = (OrderListCell *)[tableView cellForRowAtIndexPath:indexPath];
        DishesSelectedButton * button = (DishesSelectedButton *)cell.deleteBtn;
        [self deleteClick:button];
       [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } 
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 删除操作
-(void)deleteClick:(DishesSelectedButton *)aButton
{
    if (self.selectedSegmentIndex == 1)
    {
         
       __block int orderId = [[[self.resultArr objectAtIndex:aButton.rowNum] valueForKey:@"id"] intValue];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ASIHTTPRequest * request = [WebService DeleteOrderId:orderId];
            [request startAsynchronous];
            [request setStartedBlock:^{
                [MyActivceView startAnimatedInView:self.view];
            }];
            __block NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
            [request setDataReceivedBlock:^(NSData *data) {
                [reciveData appendData:data];
            }];
            [request setCompletionBlock:^{
                [MyActivceView stopAnimatedInView:self.view];
                NSString * result = [NSString ConverStringfromData:reciveData name:ORDER_DELETE];
                if (![result isEqualToString:@"1"])
                {
                    [MyAlert ShowAlertMessage:@"删除失败！" title:@""];
                }
            }];
        });
        [self.resultArr removeObjectAtIndex:aButton.rowNum];
    }
    else
    {
        NSString * orderId = [[self.resultArr objectAtIndex:aButton.rowNum] valueForKey:@"orderId"];
        BOOL isSuccess = [DataBase deleteResultSave:orderId];
        if (!isSuccess)
        {
            [MyAlert ShowAlertMessage:@"删除失败" title:@""];
        }
        else
        {
             [self.resultArr removeObjectAtIndex:aButton.rowNum];
            [DataBase deleteResultSave:orderId];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [DataBase clearOrderMenu];
    OrderDetailViewController * orderDetail;
    if (IPhone5)
    {
        orderDetail = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    }
    else
    {
        orderDetail = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController4" bundle:nil];
    }
    
    NSString * resultId;
    if (self.selectedSegmentIndex == 0)
    {
        resultId = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"resultId"];
    }
    else
    {
      resultId = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"restid"];
    }
    orderDetail.hidesBottomBarWhenPushed=YES;
    orderDetail.resultID = resultId;
    orderDetail.segmentIndex = self.selectedSegmentIndex;
    orderDetail.restDic = [self.resultArr objectAtIndex:indexPath.row];
    if (self.selectedSegmentIndex == 0)
    {
        orderDetail.saveOrderId = [[self.resultArr objectAtIndex:indexPath.row] valueForKey:@"orderId"];
    }
    [self.navigationController pushViewController:orderDetail animated:YES];
}

-(IBAction)noSumbitBtnClick:(id)sender
{
    self.bgImageView.image = [UIImage imageNamed:@"orderBg.png"];
    self.selectedSegmentIndex = 0;
    [self getDatafromDatabase];
}

-(IBAction)yesSumBtnClick:(id)sender
{
    [self.resultArr removeAllObjects];
    [self.orderTableView reloadData];
    self.bgImageView.image = [UIImage imageNamed:@"orderBg1.png"];
    self.selectedSegmentIndex = 1;
    
    i = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.tellArr.count>0)
        {
            [self getData:i];
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
