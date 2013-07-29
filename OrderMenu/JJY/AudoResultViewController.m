//
//  AudoResultViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-11.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "AudoResultViewController.h"
#import "DishesDetailListCell.h"
#import "AudoPriceView.h"
#import "AudoDishesCell.h"
#import "AudoDishesListViewController.h"
#import "SumbitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataBase.h"

@interface AudoResultViewController ()<AudoPriceViewDelegate>
@property (nonatomic,strong)UIButton * backButton;
@property (nonatomic,strong)UIButton * changeButton;
@property (nonatomic,strong)NSMutableArray * datasourseArr;
@property (nonatomic,strong)AudoPriceView * audoPrice;
-(IBAction)backClick:(id)sender;
-(IBAction)changeBtnClick:(id)sender;
-(void)tapClick:(UITapGestureRecognizer *)aTap;
-(void)deleteBtnClick:(DishesSelectedButton *)aButton;
-(void)getData;
-(void)refePriceView;
@end

@implementation AudoResultViewController
@synthesize eatNumLab;
@synthesize resAdressLab;
@synthesize resNameLab;
@synthesize dishTableView;
@synthesize backButton;
@synthesize changeButton;
@synthesize datasourseArr;
@synthesize peopleNum;
@synthesize resultID;
@synthesize audoPrice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton = button;
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"12.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 37);
    [self.navigationController.navigationBar addSubview:button];
    
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeButton = changeBtn;
    [changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.frame = CGRectMake(320-60, 0, 60, 37);
    [changeBtn setImage:[UIImage imageNamed:@"13.png"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:changeBtn];
}
#pragma  mark - 刷新表
-(void)refeTable
{
    [self.audoPrice ChangeLabTextSumPrice:0 sumDishes:0];
    if (self.datasourseArr.count>0)
    {
        [self.datasourseArr removeAllObjects];
    }
    self.datasourseArr = [NSMutableArray arrayWithArray:[DataBase selectAllProduct]];
    [self refePriceView];
    [self.dishTableView reloadData];
}
#pragma mark - change　price
-(void)refePriceView
{
    __block double sumPrice = 0;
    [self.datasourseArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        sumPrice += [[obj valueForKey:@"prices"] doubleValue];
    }];
    [self.audoPrice ChangeLabTextSumPrice:sumPrice sumDishes:self.datasourseArr.count];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.backButton removeFromSuperview];
    [self.changeButton removeFromSuperview];
}
-(IBAction)backClick:(id)sender
{
    [DataBase clearOrderMenu];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 换一份按钮触发事件
-(IBAction)changeBtnClick:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:217 green:217 blue:217 alpha:0.9];
    self.dishTableView.bounces = NO;
    self.eatNumLab.text = self.peopleNum;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
    
    //加载底部价格view
    AudoPriceView * price = [AudoPriceView ShareView];
    self.audoPrice = price;
    price.delegate = self;
    [AudoPriceView AnimateCome];
    [price ChangeLabTextSumPrice:0 sumDishes:0];
    [self.view addSubview:price];
}

#pragma mark - get data
-(void)getData
{
    [DataBase clearOrderMenu];
    NSString * str = [self.peopleNum substringToIndex:self.peopleNum.length-1];
    ASIHTTPRequest * request = [WebService AudoProductListConfigResultId:self.resultID peopleNumber:[str intValue]];
    [request startAsynchronous];
    NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
    [request setStartedBlock:^{
        [MyActivceView startAnimatedInView:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    [request setCompletionBlock:^{
        NSArray * arr = [NSString ConverfromData:reciveData name:AUDO_PRODUCT_NAME];
        if (arr.count > 0)
        {
            self.datasourseArr = [NSMutableArray arrayWithArray:[NSString ConverfromData:reciveData name:AUDO_PRODUCT_NAME]];
            NSLog(@"self.data = %@",self.datasourseArr);
            if (self.datasourseArr.count>0)
            {
                [self.datasourseArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                    [DataBase insertProID:[[obj valueForKey:@"ProID"] intValue] menuid:[[obj valueForKey:@"Menuid"] intValue] proName:[obj valueForKey:@"ProName"] price:[[obj valueForKey:@"prices"] doubleValue] image:[obj valueForKey:@"ProductImg"]];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MyActivceView stopAnimatedInView:self.view];
                    [self refePriceView];
                    [self.dishTableView reloadData];
                });
            }
            else
            {
                [MyActivceView stopAnimatedInView:self.view];
            }
        }
        else
        {
            [MyActivceView stopAnimatedInView:self.view];
            [MyAlert ShowAlertMessage:@"由于系统出错，无法进行智能点菜！" title:@"抱歉"];
        }
    }];}

#pragma mark - audo price view delegate
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasourseArr count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * mark_str = @"markStr";
    static NSString * mark_str1 = @"cellmark1";
    AudoDishesCell * cell;
    if (indexPath.row == self.datasourseArr.count)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:mark_str1];
    }
    else
    {
       cell = [tableView dequeueReusableCellWithIdentifier:mark_str];
    }
    if (cell == nil)
    {
        if (indexPath.row == self.datasourseArr.count)
        {
        cell = [[AudoDishesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark_str1];
        }
        else
        {
         cell = [[AudoDishesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark_str];
        }
        
    }
    if (indexPath.row<self.datasourseArr.count)
    {
        NSString * str1 = ALL_URL;
        NSURL * url = [NSURL URLWithString:[str1 stringByAppendingFormat:@"%@",[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProductImg"]]];
        [cell.leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:ALL_NO_IMAGE]];
        NSString * str2 = @"￥";
        NSString * priceStr = [[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"prices"];
        cell.priceLab.text = [str2 stringByAppendingFormat:@"%@",priceStr];
        cell.titleLab.text = [[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProName"];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.dishesButton.rowNum = [[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
        [cell.dishesButton addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.dishesButton setBackgroundImage:[UIImage imageNamed:@"25.png"] forState:UIControlStateNormal];
    }
    else
    {
        cell.leftImageView.image = [UIImage imageNamed:@"16.png"];
        cell.leftImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [cell.leftImageView addGestureRecognizer:tap];
        cell.titleLab.text = @"加个菜";
        [cell.dishesButton removeFromSuperview];
    }
    return cell;
}
#pragma mark - 删除操作
-(void)deleteBtnClick:(DishesSelectedButton *)aButton
{
    if (self.datasourseArr.count>0)
    {
        [DataBase deleteProID:aButton.rowNum];
        [self.datasourseArr removeAllObjects];
        self.datasourseArr = [DataBase selectAllProduct];
        [self refePriceView];
    }
    [self.dishTableView reloadData];
}

#pragma mark - 加个菜--触发事件
-(void)tapClick:(UITapGestureRecognizer *)aTap
{
    AudoDishesListViewController * dishList;
    if (IPhone5)
    {
        dishList = [[AudoDishesListViewController alloc] initWithNibName:@"AudoDishesListViewController" bundle:nil];
    }
    else
    {
        dishList = [[AudoDishesListViewController alloc] initWithNibName:@"AudoDishesListViewController4" bundle:nil];
    }
    dishList.resultID = self.resultID;
    dishList.myViewController = self;
    [self presentViewController:dishList animated:YES completion:^{
        ;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
