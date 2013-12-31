//
//  MenuCheckViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-31.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "MenuCheckViewController.h"
#import "CheckCell.h"
#import "DataBase.h"
#import "SumbitViewController.h"
#import "WebService.h"
#import "PriceView.h"
#import "AppDelegate.h"
@interface MenuCheckViewController ()
@property (nonatomic,strong) IBOutlet UITableView * myTableView;
@property (nonatomic,strong) IBOutlet UILabel * priceLab;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) IBOutlet UIButton * Btn_sumbit;
@property (nonatomic,strong) IBOutlet UIImageView * nav_imageView;


@property (nonatomic,strong) NSMutableDictionary * priceAndNumberDic;
@property (nonatomic,strong) NSMutableDictionary * indexDic;
@property (nonatomic,strong) NSMutableDictionary * dotNumberDic;

-(void)getData;
-(IBAction)sumbitClick:(id)sender;
-(IBAction)saveClick:(id)sender;
-(IBAction)backClick:(id)sender;
-(IBAction)backIndex:(id)sender;
@end

@implementation MenuCheckViewController
@synthesize dataArr;
@synthesize myTableView;
@synthesize resInfoArr;
@synthesize priceLab;
@synthesize Btn_sumbit;
@synthesize priceAndNumberDic,indexDic,dotNumberDic;
@synthesize nav_imageView;

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
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:REST_STATUS] isEqualToString:@"0"])
    {
        self.Btn_sumbit.alpha = 0.0;
    }
    else
    {
        self.Btn_sumbit.alpha = 1.0;
    }
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    if (![NSString IOS_7])
    {
        self.nav_imageView.frame = CGRectMake(0, 0, 320, 44);
    }
    
    self.priceAndNumberDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.indexDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.dotNumberDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self getData];
}
#pragma mark - 回到首页
-(IBAction)backIndex:(id)sender
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app showBotomBar];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - change　price
-(void)refePriceView
{
    NSMutableArray * mutableArr = [DataBase selectAllArrayProId];
    __block NSMutableArray * arr;
    __block double sum = 0;
    __block double addNum = 0;
    __block int num = 0;
    [mutableArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        arr = [DataBase selectNumberFromProId:[obj intValue]];
        num += [[[arr objectAtIndex:0] valueForKey:@"number"] intValue];
        addNum = [[[arr objectAtIndex:0] valueForKey:@"number"] doubleValue]*[[[arr objectAtIndex:0] valueForKey:@"price"] doubleValue];
        sum += addNum;
    }];
    self.priceLab.text = [NSString stringWithFormat:@"%g元（共%d个菜）",sum,num];
}

-(void)getData
{
    if (self.dataArr.count>0)
    {
        [self.dataArr removeAllObjects];
        self.dataArr = (NSMutableArray *)[DataBase selectAllProduct];
    }
    else
    {
        self.dataArr = (NSMutableArray *)[DataBase selectAllProduct];
    }
    [self.myTableView reloadData];
    [self refePriceView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strMark = @"cellMark";
    CheckCell * cell1 = [tableView dequeueReusableCellWithIdentifier:strMark];
    NSMutableArray * arr1 = [DataBase selectNumberFromProId:[[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue]];
    int number = [[[arr1 objectAtIndex:0] valueForKey:@"number"] intValue];
    if (cell1 == nil)
    {
        cell1 = [[CheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMark andDotNumber:number];
    }
    if (number > 0)
    {
        [cell1.ClickView initView:number];
    }
    else
    {
        [cell1.ClickView zeroState];
    }
    cell1.selectionStyle=UITableViewCellSelectionStyleNone;
    cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
    cell1.labName.text = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"ProName"];
    NSString * str = @"￥";
    NSString * priceStr = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"prices"];
    cell1.labPrice.text = [str stringByAppendingFormat:@"%@",priceStr];
    cell1.ClickView.index = indexPath.row;
    cell1.ClickView.frame = CGRectMake(210, 3, 90, 30);
    [cell1.ClickView.rightButton addTarget:self action:@selector(rightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell1.ClickView.leftButton addTarget:self action:@selector(leftButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.priceAndNumberDic setValue:priceStr forKey:[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
    [self.indexDic setValue:[NSNumber numberWithInt:indexPath.row] forKey:[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
    [self.dotNumberDic setValue:[NSNumber numberWithInt:number] forKey:[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
    cell1.ClickView.rightButton.tag = [[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
    cell1.ClickView.leftButton.tag = [[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
    cell1.ClickView.bigButton.tag = [[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
    
    return cell1;
}

#pragma mark - 点菜触发事件
-(void)leftButtonClickEvent:(UIButton *)aButton
{
    // CheckCell * cell = (CheckCell *)[[[aButton superview] superview] superview];
    int dot1 = [[self.dotNumberDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue];
    dot1 --;
    [self.dotNumberDic setValue:[NSNumber numberWithInt:dot1] forKey:[NSString stringWithFormat:@"%d",aButton.tag]];
    double priceSum = [PriceView ShareView].sumprice;
    int numberSum = [PriceView ShareView].sumnumber;
    [[PriceView ShareView] ChangeLabTextSumPrice:priceSum-[[[self.dataArr objectAtIndex:[[self.indexDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue]] valueForKey:@"prices"] doubleValue] sumDishes:numberSum-1];
    NSDictionary * obj = [self.dataArr objectAtIndex:[[self.indexDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue]];
    if (dot1 == 0)
    {
        [DataBase deleteProID:[[obj valueForKey:@"ProID"] intValue]];
        [self getData];
    }
    else
    {
        [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:dot1];
        [self refePriceView];
    }
}
-(void)rightButtonClickEvent:(UIButton *)aButton
{
    // CheckCell * cell = (CheckCell *)[[[aButton superview] superview] superview];
    int dot1 = [[self.dotNumberDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue];
    dot1++;
    [self.dotNumberDic setValue:[NSNumber numberWithInt:dot1] forKey:[NSString stringWithFormat:@"%d",aButton.tag]];
    double priceSum = [PriceView ShareView].sumprice;
    int numberSum = [PriceView ShareView].sumnumber;
    [[PriceView ShareView] ChangeLabTextSumPrice:priceSum+[[[self.dataArr objectAtIndex:[[self.indexDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue]] valueForKey:@"prices"] doubleValue] sumDishes:numberSum+1];
    NSDictionary * obj = [self.dataArr objectAtIndex:[[self.indexDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue]];
    [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:dot1];
    [self refePriceView];
}

-(IBAction)sumbitClick:(id)sender
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
    sumbit.restId = self.resultID;
    sumbit.idStr = [DataBase selectAllProId];
    //number
    NSArray * arrID = [ sumbit.idStr componentsSeparatedByString:@","];
    __block NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    [arrID enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        [array addObject:[DataBase selectNumberFromProId:[obj intValue]]];
    }];
    __block NSMutableString * strMutable = [NSMutableString stringWithCapacity:0];
    [array enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL *stop) {
        [strMutable appendFormat:@"%@,",[[obj objectAtIndex:0] valueForKey:@"number"]];
    }];
    NSString * str = [strMutable substringToIndex:strMutable.length-1];
    sumbit.numberStrs = str;
    [self.navigationController pushViewController:sumbit animated:YES];
}

-(IBAction)saveClick:(id)sender
{
    //保存次餐馆信息
    NSDictionary * dic = (NSDictionary *)self.resInfoArr;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * currDate=[dateFormat stringFromDate:[NSDate date]];
    NSString * orderId = [DataBase insertResultResultId:[self.resultID intValue] resultName:[dic valueForKey:@"restname"] proImage:[dic valueForKey:@"restimg"] orderTime:currDate adress:[dic valueForKey:@"restaddress"] tellNumber:[dic valueForKey:@"restphone"]];
    
    if (![orderId isEqualToString:@"null"])
    {
        //选出所点菜
        NSMutableArray * allArrPro = [DataBase selectAllProduct];
        NSMutableString * mutableStr = [NSMutableString stringWithCapacity:0];
        for (int i = 0;i<allArrPro.count; i++)
        {
            NSDictionary * dic = [allArrPro objectAtIndex:i];
            NSString * proid = [dic valueForKey:@"ProID"];
            NSString * ProName = [dic valueForKey:@"ProName"];
            NSString * price = [dic valueForKey:@"prices"];
            NSString * imageName = [dic valueForKey:@"ProductImg"];
            NSString * number = [dic valueForKey:@"number"];
            BOOL isSuccess =[DataBase insertSaveProID:[proid intValue] orderId:[orderId intValue] proName:ProName price:[price doubleValue] image:imageName andNumber:[number intValue]];
            [mutableStr appendFormat:@"%d",isSuccess];
        }
        NSRange range = [mutableStr rangeOfString:@"0"];
        if (range.length == 0)
        {
            [MyAlert ShowAlertMessage:@"保存成功" title:@""];
        }
    }
    else
    {
        [MyAlert ShowAlertMessage:@"保存失败" title:@""];
    }
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
