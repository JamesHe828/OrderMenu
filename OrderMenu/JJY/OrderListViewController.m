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
@interface OrderListViewController ()
{
    int i;
}
@property (nonatomic,strong)NSMutableArray * datasourseArr;
@property (nonatomic,strong)NSMutableArray * resultArr;
@property (nonatomic,strong)NSArray * tellArr;
-(IBAction)backClick:(id)sender;
-(void)deleteClick:(DishesSelectedButton *)aButton;
-(void)getData:(int)aIndex;
@end

@implementation OrderListViewController
@synthesize orderTableView;
@synthesize datasourseArr;
@synthesize tellArr;
@synthesize resultArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tellArr = [DataBase selectTellNumber];
    self.datasourseArr = [NSMutableArray arrayWithCapacity:0];
    self.resultArr = [NSMutableArray arrayWithCapacity:0];
    self.orderTableView.bounces = NO;
    i = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.tellArr.count>0)
        {
            [self getData:i];
        }
    });
}
#pragma mark - get data
-(void)getData:(int)aIndex
{
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
    if (self.resultArr.count==0)
    {
        UILabel *alab=[[UILabel alloc] initWithFrame:CGRectMake(80, 2, 200, 50)];
        alab.text=@"您还没有订单信息";
        alab.backgroundColor=[UIColor clearColor];
        [tableView addSubview:alab];
    }
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strMark = @"orderMark";
    OrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:strMark];
    if (cell == nil)
    {
        cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMark];
    }
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
    [cell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - 删除操作
-(void)deleteClick:(DishesSelectedButton *)aButton
{
    int orderId = [[[self.resultArr objectAtIndex:aButton.rowNum] valueForKey:@"id"] intValue];
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (self.tellArr.count>0)
            {
                [self.resultArr removeAllObjects];
                i = 0;
                [self getData:i];
            }
        });
        NSString * result = [NSString ConverStringfromData:reciveData name:ORDER_DELETE];
        if ([result isEqualToString:@"1"])
        {
            [MyAlert ShowAlertMessage:@"删除成功！" title:@""];
        }
        else
        {
            [MyAlert ShowAlertMessage:@"删除失败！" title:@""];
        }
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController * orderDetail;
    if (IPhone5)
    {
        orderDetail = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    }
    else
    {
        orderDetail = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController4" bundle:nil];
    }
    orderDetail.restDic = [self.resultArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:orderDetail animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
