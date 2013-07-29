//
//  OrderDetailViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-19.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PriceView.h"
#import "DishesDetailListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "DetailViewController.h"
@interface OrderDetailViewController ()
@property (nonatomic,strong)IBOutlet UITableView * proTableView;
@property (nonatomic,strong)IBOutlet UIImageView * restImgView;
@property (nonatomic,strong)IBOutlet UILabel * restNameLab;
@property (nonatomic,strong)IBOutlet UILabel * restAddressLab;
@property (nonatomic,strong)IBOutlet UILabel * restTellLab;
@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic,strong)IBOutlet UILabel * bottomLab;
-(IBAction)backClick:(id)sender;
-(IBAction)nextRestDetail:(id)sender;
-(void)getData;
@end

@implementation OrderDetailViewController
@synthesize proTableView;
@synthesize restDic;
@synthesize dataArr;
@synthesize bottomLab;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.restImgView.layer.borderColor = [UIColor grayColor].CGColor;
    self.restImgView.layer.borderWidth = 1;
    self.restImgView.layer.cornerRadius = 7;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.proTableView.bounces = NO;
    self.proTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     NSString * url = [ALL_URL stringByAppendingFormat:@"%@",[self.restDic valueForKey:@"restimg"]];
    [self.restImgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"no.png"]];
    self.restNameLab.text = [self.restDic valueForKey:@"restName"];
    self.restAddressLab.text = [self.restDic valueForKey:@"restAdress"];
    self.restTellLab.text = [self.restDic valueForKey:@"restphone"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
    
}
-(void)getData
{
    int orderId = [[self.restDic valueForKey:@"id"] intValue];
    ASIHTTPRequest * request = [WebService GetProductList:orderId];
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
        self.dataArr = [NSString ConverfromData:reciveData name:ORDER_GETPRODUCT];
        __block double sum = 0.0;
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.proTableView reloadData];
            
            [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                sum += [[obj valueForKey:@"prices"] doubleValue];
            }];
            self.bottomLab.text = [NSString stringWithFormat:@"￥%g（合计%d个菜)",sum,self.dataArr.count];
        });
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strMark1 = @"markcell"; 
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
    cell1.titleLab.text = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"title"];
    NSString * str = @"￥";
    NSString * priceStr = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"prices"];
    cell1.priceLab.text = [str stringByAppendingFormat:@"%@",priceStr];
    cell1.dishesButton.alpha = 0.0;
    cell1.dishesButton.price = [priceStr doubleValue];
    cell1.dishesButton.rowNum = indexPath.row;
    NSString * url = [ALL_URL stringByAppendingFormat:@"%@",[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"productimg"]];
    [cell1.leftImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"no.png"]];
    return cell1;
}

#pragma mark - 餐馆详情
-(IBAction)nextRestDetail:(id)sender
{
    DetailViewController *detail=[[DetailViewController alloc] init];
    detail.isFromOrder = YES;
    detail.pID=[restDic valueForKey:@"restid"];
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.ddmenuControler showRootController:YES];
    [delegate.AllNav pushViewController:detail animated:YES];
}
-(void)detailView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchGesture" object:nil];
}
-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
