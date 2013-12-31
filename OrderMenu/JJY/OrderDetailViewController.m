//
//  OrderDetailViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-19.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PriceView.h"
#import "CheckCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "DataBase.h"
#import "SumbitViewController.h"
#import "AudoDishesListViewController.h"


@interface OrderDetailViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong)IBOutlet UITableView * proTableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)IBOutlet UILabel * bottomLab;
@property (nonatomic,strong)IBOutlet UIButton * sumbitBtn;
@property (nonatomic,strong) NSMutableArray * tempArray;
@property (nonatomic,strong) IBOutlet UIButton * Btn_sumbit;
-(IBAction)backClick:(id)sender;
-(void)getData;
-(void)getSaveData;
-(void)leftButtonClickEvent:(UIButton *)aButton;
-(void)rightButtonClickEvent:(UIButton *)aButton;
-(void)refePriceView;
-(IBAction)sumbitClick:(id)sender;
-(void)tapClick:(UITapGestureRecognizer *)aTap;
-(NSMutableArray *)getAddDishesData;
-(void)refreshAddDishesTableview;
-(void)sumbitEvent;
@end

@implementation OrderDetailViewController
@synthesize proTableView;
@synthesize restDic;
@synthesize dataArr;
@synthesize bottomLab;
@synthesize segmentIndex;
@synthesize saveOrderId;
@synthesize sumbitBtn;
@synthesize resultID;
@synthesize numberStrs;
@synthesize tempArray;
@synthesize Btn_sumbit;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - change　price
-(void)refePriceView
{
    NSMutableArray * mutableArr = [DataBase SelectAllSaveProId:[self.saveOrderId intValue]];
    __block NSDictionary * dic;
    __block double sum = 0;
    __block double addNum = 0;
    __block int num = 0;
    [mutableArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        dic = [DataBase SelectNumberAndPriceByProID:[[obj valueForKey:@"proID"] intValue]];
        num += [[dic valueForKey:@"number"] intValue];
        addNum = [[dic valueForKey:@"number"] doubleValue]*[[dic valueForKey:@"price"] doubleValue];
        sum += addNum;
    }];
    self.bottomLab.text = [NSString stringWithFormat:@"%g元（共%d个菜）",sum,num];
}
#pragma mark - 添加菜后进行刷新
-(void)refreshAddDishesTableview
{
    NSMutableArray * arr = [self getAddDishesData];
    NSMutableArray * tempArr;
    if (tempArr.count>0)
    {
        [tempArr removeAllObjects];
    }
    if (self.tempArray.count>0)
    {
        [self.tempArray removeAllObjects];
    }
    tempArr = [NSMutableArray arrayWithArray:0];
    if (arr.count>0)
    {
        __block NSMutableArray * dict;
        [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            dict = [NSMutableDictionary dictionaryWithCapacity:0];
            [dict setValue:[obj valueForKey:@"ProID"] forKey:@"id"];
            [dict setValue:[obj valueForKey:@"ProName"] forKey:@"title"];
            [dict setValue:[obj valueForKey:@"prices"] forKey:@"prices"];
            [dict setValue:[obj valueForKey:@"number"] forKey:@"copies"];
            [tempArr addObject:dict];
        }];
        self.tempArray = tempArr;
        __block double sum = 0;
        __block double addNum = 0;
        __block int num = 0;
        [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            num += [[obj valueForKey:@"copies"] intValue];
            addNum = [[obj valueForKey:@"copies"] intValue]*[[obj valueForKey:@"prices"] doubleValue];
            sum += addNum;
        }];
        [self.tempArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            num += [[obj valueForKey:@"copies"] intValue];
            addNum = [[obj valueForKey:@"copies"] doubleValue]*[[obj valueForKey:@"prices"] doubleValue];
            sum += addNum;
        }];
       
        [self.proTableView reloadData];
        self.bottomLab.text = [NSString stringWithFormat:@"%g元（共%d个菜）",sum,num];
    }
}

-(IBAction)sumbitClick:(id)sender
{
    if (self.segmentIndex == 1)
    {
//        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"您确定要提交吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        [alertview show];
        [self sumbitEvent];
    }
    else
    {
        [self sumbitEvent];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self sumbitEvent];
    }
}
-(void)sumbitEvent
{
    if (self.segmentIndex == 1)
    {
        //id string
        NSString * idStr = [DataBase selectAllProId];
        //numbers string
        if (idStr.length>0)
        {
            NSArray * arrID = [idStr componentsSeparatedByString:@","];
            __block NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            [arrID enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
                [array addObject:[DataBase selectNumberFromProId:[obj intValue]]];
            }];
            __block NSMutableString * strMutable = [NSMutableString stringWithCapacity:0];
            [array enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL *stop) {
                [strMutable appendFormat:@"%@,",[[obj objectAtIndex:0] valueForKey:@"number"]];
            }];
            NSString * strNumbers = [strMutable substringToIndex:strMutable.length-1];
            ASIHTTPRequest * request = [WebService AddDisesToOrderId:[[self.restDic valueForKey:@"id"] intValue] idList:idStr copies:strNumbers];
            request.defaultResponseEncoding = NSUTF8StringEncoding;
            [request startAsynchronous];
            [MyActivceView startAnimatedInView:self.view];
            
            NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
            [request setDataReceivedBlock:^(NSData *data) {
                [reciveData appendData:data];
            }];
            __block NSString * result;
            [request setCompletionBlock:^{
                [MyActivceView stopAnimatedInView:self.view];
                result = [NSString ConverStringfromData:reciveData name:@"AddToOrderInfo"];
                if ([result isEqualToString:@"0"])
                {
                    [MyAlert ShowAlertMessage:@"提交失败！" title:@""];
                }
                if ([result isEqualToString:@"1"])
                {
                    [MyAlert ShowAlertMessage:@"提交成功！" title:@""];
                }
                if ([result isEqualToString:@"2"])
                {
                    [MyAlert ShowAlertMessage:@"该订单已付帐，不能进行添加！" title:@""];
                }
            }];
            [request setFailedBlock:^{
                [MyActivceView stopAnimatedInView:self.view];
                [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
            }];
        }
        else
        {
            //只提交订单，没有进行加菜
            [MyAlert ShowAlertMessage:@"您还没有进行添加菜！" title:@"提示"];
        }
    }
    else
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
        //id
        NSMutableArray * arr = [DataBase SelectAllSaveProId:[self.saveOrderId intValue]];
        __block NSMutableString * idMutableStr = [NSMutableString stringWithCapacity:0];
        [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            [idMutableStr appendFormat:@"%@,",[obj valueForKey:@"proID"]];
        }];
        NSString * str = [idMutableStr substringToIndex:idMutableStr.length-1];
        sumbit.idStr = str;
        //number
        NSArray * arrID = [str componentsSeparatedByString:@","];
        __block NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [arrID enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
            [array addObject:[DataBase SelectNumberAndPriceByProID:[obj intValue] andOrderId:[self.saveOrderId intValue]]];
        }];
        
        __block NSMutableString * strMutable = [NSMutableString stringWithCapacity:0];
        [array enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            [strMutable appendFormat:@"%@,",[obj valueForKey:@"number"]];
        }];
        NSString * str1 = [strMutable substringToIndex:strMutable.length-1];
        sumbit.numberStrs = str1;
        sumbit.isFromOrder = YES;
        sumbit.saveOrderId = self.saveOrderId;
        [self.navigationController pushViewController:sumbit animated:YES];
    }
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

    
    self.proTableView.layer.borderColor = [UIColor grayColor].CGColor;
    self.proTableView.layer.borderWidth = 1;
    self.tempArray = [NSMutableArray arrayWithArray:0];
    
    
    self.proTableView.bounces = NO;
    
    if (self.segmentIndex == 1)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getData];
        });
    }
    else
    {
        [self getSaveData];
    }
}
-(void)getSaveData
{
    if (self.dataArr.count > 0)
    {
        [self.dataArr removeAllObjects];
    }
    self.dataArr = [DataBase selecetAllNoSaveProduct:self.saveOrderId];
    [self refePriceView];
    [self.proTableView reloadData];
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
        self.dataArr = (NSMutableArray *)[NSString ConverfromData:reciveData name:ORDER_GETPRODUCT];
        __block double sum = 0.0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.proTableView reloadData];
            [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                sum += [[obj valueForKey:@"prices"] doubleValue]*[[obj valueForKey:@"copies"] intValue];
            }];
            self.bottomLab.text = [NSString stringWithFormat:@"￥%g（合计%d个菜)",sum,self.dataArr.count];
        });
    }];
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
    }];
}
#pragma mark - 获取已提交订单添加的菜
-(NSMutableArray *)getAddDishesData
{
    NSMutableArray * arr = (NSMutableArray *)[DataBase selectAllProduct];
    return arr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentIndex == 1 && indexPath.row == self.dataArr.count+self.tempArray.count)
    {
        return 80;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentIndex == 1)
    {
        return self.dataArr.count+0+self.tempArray.count;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strMark1 = @"markcell";
    static NSString * strMark2 = @"cellMark";
    CheckCell * cell1;
    if (self.segmentIndex == 1 && indexPath.row < self.dataArr.count+self.tempArray.count && self.dataArr.count != 0)
    {
        cell1 = [tableView dequeueReusableCellWithIdentifier:strMark1];
    }
    else
    {
        cell1 = [tableView dequeueReusableCellWithIdentifier:strMark2];
    }
    
    
    int dotNumber = 0;
    if (self.segmentIndex == 0)
    {
        dotNumber = [[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"number"] intValue];
    }
    else
    {
        if (indexPath.row<self.dataArr.count)
        {
            dotNumber = [[[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"copies"] intValue];
        }
        else if (indexPath.row>=self.dataArr.count && self.tempArray.count != 0 && indexPath.row<self.dataArr.count+self.tempArray.count)
        {
            dotNumber = [[[self.tempArray objectAtIndex:indexPath.row-self.dataArr.count] valueForKey:@"copies"] intValue];
            
        }
        else
        {
            dotNumber = 0;
        }
    }
    
    if (cell1 == nil)
    {
        if (self.segmentIndex == 1 && indexPath.row < self.dataArr.count+self.tempArray.count)
        {
            cell1 = [[CheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMark1 andDotNumber:dotNumber];
        }
        else
        {
            cell1 = [[CheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMark2 andDotNumber:dotNumber];
        }
        
    }
    if (self.dataArr.count > 0)
    {
        if (dotNumber > 0)
        {
            [cell1.ClickView initView:dotNumber];
        }
        else
        {
            [cell1.ClickView zeroState];
        }
    }
    else
    {
        [cell1.ClickView zeroState];
    }
    
    if (self.segmentIndex == 1)
    {
        if (self.dataArr.count != 0)
        {
            if (indexPath.row < self.dataArr.count)
            {
                cell1.selectionStyle=UITableViewCellSelectionStyleNone;
                cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
                cell1.labName.text = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"title"];
                NSString * str = @"￥";
                NSString * priceStr = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"prices"];
                cell1.labPrice.text = [str stringByAppendingFormat:@"%@",priceStr];
                cell1.ClickView.frame = CGRectMake(210, 3, 90, 30);
                cell1.ClickView.myLab.frame = CGRectMake(cell1.ClickView.myLab.frame.origin.x, cell1.ClickView.myLab.frame.origin.y-2, 50, cell1.ClickView.myLab.frame.size.height+5);
                cell1.ClickView.myLab.font = [UIFont systemFontOfSize:13];
                cell1.ClickView.leftButton.alpha = 0.0;
                cell1.ClickView.rightButton.alpha = 0.0;
            }
            
            if (indexPath.row == self.dataArr.count+self.tempArray.count)
            {
                cell1.bgImageView.alpha = 0.0;
                cell1.ClickView.bigButton.alpha = 0.0;
                UIImageView * leftView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 60)];
                leftView.image = [UIImage imageNamed:@"16.png"];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
                [leftView addGestureRecognizer:tap];
                leftView.userInteractionEnabled = YES;
                [cell1 addSubview:leftView];
                
                UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(130, 22.5, 100, 35)];
                title.numberOfLines = 2;
                title.text = @"加菜";
                title.backgroundColor = [UIColor clearColor];
                title.font = [UIFont systemFontOfSize:16];
                [cell1 addSubview:title];
            }
            BOOL isTure = (indexPath.row>=self.dataArr.count) && (indexPath.row != self.dataArr.count+self.tempArray.count);
            if (isTure)
            {
                cell1.bgImageView.alpha = 1.0;
                cell1.selectionStyle=UITableViewCellSelectionStyleNone;
                cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
                cell1.labName.text = [[self.tempArray objectAtIndex:indexPath.row-self.dataArr.count] valueForKey:@"title"];
                NSString * str = @"￥";
                NSString * priceStr = [[self.tempArray objectAtIndex:indexPath.row-self.dataArr.count] valueForKey:@"prices"];
                cell1.labPrice.text = [str stringByAppendingFormat:@"%@",priceStr];
                cell1.ClickView.frame = CGRectMake(210, 3, 90, 30);
                cell1.ClickView.myLab.frame = CGRectMake(cell1.ClickView.myLab.frame.origin.x, cell1.ClickView.myLab.frame.origin.y-2, 50, cell1.ClickView.myLab.frame.size.height+5);
                
                cell1.ClickView.myLab.font = [UIFont systemFontOfSize:13];
                cell1.ClickView.leftButton.alpha = 0.0;
                cell1.ClickView.rightButton.alpha = 0.0;
            }
        }
    }
    else
    {
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
        cell1.labName.text = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"proName"];
        NSString * str = @"￥";
        NSString * priceStr = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"price"];
        cell1.labPrice.text = [str stringByAppendingFormat:@"%@",priceStr];
        cell1.ClickView.frame = CGRectMake(210, 0, 90, 30);
        cell1.ClickView.price = [priceStr doubleValue];
        cell1.ClickView.index = indexPath.row;
        [cell1.ClickView.rightButton addTarget:self action:@selector(rightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.ClickView.leftButton addTarget:self action:@selector(leftButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell1;
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
    dishList.resultID = [self.resultID intValue];
    dishList.orderDetail = self;
    [self presentViewController:dishList animated:YES completion:^{
        ;
    }];
}

#pragma mark - 点菜触发事件
-(void)leftButtonClickEvent:(UIButton *)aButton
{
    CheckCell * cell = (CheckCell *)[[[aButton superview] superview] superview];
    NSDictionary * obj = [self.dataArr objectAtIndex:cell.ClickView.index];
    if (cell.ClickView.dotNumber == 0)
    {
        [DataBase deleteSaveProID:[[obj valueForKey:@"proID"] intValue] andOrderId:[self.saveOrderId intValue]];
        [self refePriceView];
        NSMutableArray * arr = [DataBase SelectAllSaveProId:[self.saveOrderId intValue]];
        if (arr.count == 0)
        {
            [DataBase deleteResultSave:self.saveOrderId];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [DataBase UpdateDotNumber:cell.ClickView.dotNumber andPriId:[[obj valueForKey:@"proID"] intValue] andOrderId:[self.saveOrderId intValue]];
        [self refePriceView];
    }
    if (self.segmentIndex == 0)
    {
        [self getSaveData];
    }
}
-(void)rightButtonClickEvent:(UIButton *)aButton
{
    CheckCell * cell = (CheckCell *)[[[aButton superview] superview] superview];
    NSDictionary * obj = [self.dataArr objectAtIndex:cell.ClickView.index];
    [DataBase UpdateDotNumber:cell.ClickView.dotNumber andPriId:[[obj valueForKey:@"proID"] intValue] andOrderId:[self.saveOrderId intValue]];
    [self refePriceView];
}

-(void)detailView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchGesture" object:nil];
}
-(IBAction)backClick:(id)sender
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app showBotomBar];
    [self.navigationController popViewControllerAnimated:YES];
    [DataBase clearOrderMenu];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
