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
#import "MenuCheckViewController.h"

@interface AudoResultViewController ()<AudoPriceViewDelegate>
{
    int menuId;
     AudoDishesListViewController * dishList;
}
@property (nonatomic,strong)UIButton * backButton;
@property (nonatomic,strong)UIButton * changeButton;
@property (nonatomic,strong)NSMutableArray * datasourseArr;
@property (nonatomic,strong)AudoPriceView * audoPrice;

@property (nonatomic,strong) NSMutableDictionary * priceAndNumberDic;
@property (nonatomic,strong) NSMutableDictionary * indexDic;
@property (nonatomic,strong) NSMutableDictionary * dotNumberDic;


-(IBAction)backClick:(id)sender;
-(IBAction)changeBtnClick:(id)sender;
-(void)tapClick:(UITapGestureRecognizer *)aTap;
-(void)getData;
-(void)refePriceView;
-(void)rightButtonClickEvent:(UIButton *)aButton;
-(void)leftButtonClickEvent:(UIButton *)aButton;
-(void)changeOneGetData;
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
@synthesize resInfoArr;
@synthesize priceAndNumberDic,indexDic,dotNumberDic;

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
    
    [self refeTable];
}
#pragma  mark - 刷新表
-(void)refeTable
{
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
    [self.audoPrice ChangeLabTextSumPrice:sum sumDishes:num];
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
        [self changeOneGetData];
    });
}
-(void)changeOneGetData
{
    [DataBase clearOrderMenu];
    NSString * str = [self.peopleNum substringToIndex:self.peopleNum.length-1];
    //  NSLog(@"resultid = %d,number = %d,id = %d",self.resultID,[str intValue],menuId);
    ASIHTTPRequest * request = [WebService AudoProductListConfigResultId:self.resultID peopleNumber:[str intValue]andMenuId:menuId];
    [request startAsynchronous];
    NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
    [request setStartedBlock:^{
        [MyActivceView startAnimatedInView:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    [request setCompletionBlock:^{
        NSArray * arr = [NSString ConverfromData:reciveData name:CHANGE_ONE];
        if (arr.count > 0)
        {
            menuId = [[[arr objectAtIndex:0] valueForKey:@"Menuid"] intValue];
            if (self.datasourseArr.count>0)
            {
                [self.datasourseArr removeAllObjects];
            }
            self.datasourseArr = [NSMutableArray arrayWithArray:[NSString ConverfromData:reciveData name:CHANGE_ONE]];
            if (self.datasourseArr.count>0)
            {
                [self.datasourseArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                    [DataBase insertProID:[[obj valueForKey:@"ProID"] intValue] menuid:[[obj valueForKey:@"Menuid"] intValue] proName:[obj valueForKey:@"ProName"] price:[[obj valueForKey:@"prices"] doubleValue] image:[obj valueForKey:@"ProductImg"] andNumber:1];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MyActivceView stopAnimatedInView:self.view];
                    [self.dishTableView reloadData];
                    [self refePriceView];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.datasourseArr.count>0)
                    {
                        [self.datasourseArr removeAllObjects];
                    }
                    [self refeTable];
                    [self refePriceView];
                    [MyActivceView stopAnimatedInView:self.view];
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.datasourseArr.count>0)
                {
                    [self.datasourseArr removeAllObjects];
                }
                [self refeTable];
                [self refePriceView];
                [MyActivceView stopAnimatedInView:self.view];
            });
        }
    }];
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.priceAndNumberDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.indexDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.dotNumberDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //加载底部价格view
    AudoPriceView * price = [AudoPriceView ShareView];
    self.audoPrice = price;
    price.delegate = self;
    [AudoPriceView AnimateCome];
    [self.view addSubview:price];
    
    self.view.backgroundColor = [UIColor colorWithRed:217 green:217 blue:217 alpha:0.9];
    self.dishTableView.bounces = NO;
    self.eatNumLab.text = self.peopleNum;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
    
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
    dishList.view.frame = CGRectMake(0, dishList.view.frame.size.height+100, 320, dishList.view.frame.size.height);
    [self.view addSubview:dishList.view];
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
            menuId = [[[arr objectAtIndex:0] valueForKey:@"Menuid"] intValue];
            
            if (self.datasourseArr.count>0)
            {
                [self.datasourseArr removeAllObjects];
            }
            self.datasourseArr = [NSMutableArray arrayWithArray:[NSString ConverfromData:reciveData name:AUDO_PRODUCT_NAME]];
            if (self.datasourseArr.count>0)
            {
                [self.datasourseArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                    [DataBase insertProID:[[obj valueForKey:@"ProID"] intValue] menuid:[[obj valueForKey:@"Menuid"] intValue] proName:[obj valueForKey:@"ProName"] price:[[obj valueForKey:@"prices"] doubleValue] image:[obj valueForKey:@"ProductImg"] andNumber:1];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MyActivceView stopAnimatedInView:self.view];
                    [self.dishTableView reloadData];
                    [self refePriceView];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.datasourseArr.count>0)
                    {
                        [self.datasourseArr removeAllObjects];
                    }
                    [self refeTable];
                    [self refePriceView];
                    [MyActivceView stopAnimatedInView:self.view];
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.datasourseArr.count>0)
                {
                    [self.datasourseArr removeAllObjects];
                }
                [self refeTable];
                [self refePriceView];
                [MyActivceView stopAnimatedInView:self.view];
            });
        }
    }];
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
    }];
}


#pragma mark - audo price view delegate
-(void)nextClick
{
    MenuCheckViewController * menu;
    if (IPhone5)
    {
        menu = [[MenuCheckViewController alloc] initWithNibName:@"MenuCheckViewController" bundle:nil];
    }
    else
    {
        menu = [[MenuCheckViewController alloc] initWithNibName:@"MenuCheckViewController4" bundle:nil];
    }
    menu.resultID = [NSString stringWithFormat:@"%d",self.resultID];
    menu.resInfoArr = self.resInfoArr;
    NSString * idStr = [DataBase selectAllProId];
    if (idStr.length>0)
    {
        [self.navigationController pushViewController:menu animated:YES];
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
    int dotNumber = 1;
    if (indexPath.row<self.datasourseArr.count)
    {
        NSMutableArray * arr1 =[DataBase selectNumberFromProId:[[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue]];
        if (arr1.count>0)
        {
            dotNumber = [[[arr1 objectAtIndex:0] valueForKey:@"number"] intValue];
            cell.dishView.dotNumber = dotNumber;
        }
    }
    if (cell == nil)
    {
        if (indexPath.row == self.datasourseArr.count)
        {
            cell = [[AudoDishesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark_str1];
        }
        else
        {
            cell = [[AudoDishesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark_str andDotNumber:dotNumber];
        }
    }
    if (indexPath.row<self.datasourseArr.count)
    {
        [cell.dishView initView:dotNumber];
        cell.dishView.myLab.text = [NSString stringWithFormat:@"点%d份",dotNumber];
        NSString * str1 = ALL_URL;
        NSURL * url = [NSURL URLWithString:[str1 stringByAppendingFormat:@"%@",[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProductImg"]]];
        [cell.leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:ALL_NO_IMAGE]];
        NSString * str2 = @"￥";
        NSString * priceStr = [[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"prices"];
        cell.priceLab.text = [str2 stringByAppendingFormat:@"%@",priceStr];
        cell.titleLab.text = [[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProName"];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.dishesButton.rowNum = [[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.dishView.price = [priceStr doubleValue];
        cell.dishView.index = indexPath.row;
        
        
        [cell.dishView.rightButton addTarget:self action:@selector(rightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cell.dishView.leftButton addTarget:self action:@selector(leftButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.priceAndNumberDic setValue:priceStr forKey:[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
        [self.indexDic setValue:[NSNumber numberWithInt:indexPath.row] forKey:[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
        [self.dotNumberDic setValue:[NSNumber numberWithInt:dotNumber] forKey:[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
        cell.dishView.rightButton.tag = [[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
        cell.dishView.leftButton.tag = [[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
        cell.dishView.bigButton.tag = [[[self.datasourseArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
    }
    else
    {
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.leftImageView.image = [UIImage imageNamed:@"16.png"];
        cell.leftImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [cell.leftImageView addGestureRecognizer:tap];
        cell.dishView.alpha = 0.0;
        cell.titleLab.text = @"加个菜";
        [cell.dishesButton removeFromSuperview];
    }
    return cell;
}
#pragma mark - 点菜触发事件
-(void)leftButtonClickEvent:(UIButton *)aButton
{
    // AudoDishesCell * cell = (AudoDishesCell *)[[[aButton superview] superview] superview];
    int dot1 = [[self.dotNumberDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue];
    dot1 --;
    [self.dotNumberDic setValue:[NSNumber numberWithInt:dot1] forKey:[NSString stringWithFormat:@"%d",aButton.tag]];
    NSDictionary * obj = [self.datasourseArr objectAtIndex:[[self.indexDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue]];
    if (dot1 == 0)
    {
        [DataBase deleteProID:[[obj valueForKey:@"ProID"] intValue]];
        [self refeTable];
    }
    else
    {
        [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:dot1];
    }
    
    if ([PriceView ShareView].sumnumber == 0)
    {
        [PriceView AnimateCome];
        [[PriceView ShareView] ChangeLabTextSumPrice:[[self.priceAndNumberDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] doubleValue] sumDishes:1];
    }
    else
    {
        [self refePriceView];
        int numberSum = [PriceView ShareView].sumnumber;
        if (numberSum-1 == 0)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.7];
            [UIView commitAnimations];
            [PriceView AnimateCancle];
        }
    }
}
-(void)rightButtonClickEvent:(UIButton *)aButton
{
    // DishesDetailListCell * cell = (DishesDetailListCell *)[[[aButton superview] superview] superview];
    int dot1 = [[self.dotNumberDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue];
    dot1 ++;
    [self.dotNumberDic setValue:[NSNumber numberWithInt:dot1] forKey:[NSString stringWithFormat:@"%d",aButton.tag]];
    NSDictionary * obj = [self.datasourseArr objectAtIndex:[[self.indexDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue]];
    [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:dot1];
    
    if ([PriceView ShareView].sumnumber == 0)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        [UIView commitAnimations];
        [PriceView AnimateCome];
        [self refePriceView];
    }
    else
    {
        [self refePriceView];
    }
}

#pragma mark - 加个菜--触发事件
-(void)tapClick:(UITapGestureRecognizer *)aTap
{
   
//    if (IPhone5)
//    {
////        if ([NSString IOS_7])
////        {
//            dishList = [[AudoDishesListViewController alloc] initWithNibName:@"AudoDishesListViewController" bundle:nil];
////        }
////        else
////        {
////           dishList = [[AudoDishesListViewController alloc] initWithNibName:@"AudoDishesListViewController7" bundle:nil];
////        }
//       
//    }
//    else
//    {
////        if ([NSString IOS_7])
////        {
//           dishList = [[AudoDishesListViewController alloc] initWithNibName:@"AudoDishesListViewController4" bundle:nil];
////        }
////        else
////        {
////          dishList = [[AudoDishesListViewController alloc] initWithNibName:@"AudoDishesListViewController47" bundle:nil];
////        }
//    }
   
//    [self presentViewController:dishList animated:YES completion:^{
//        ;
//    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        dishList.view.frame = CGRectMake(0, -20, 320, dishList.view.frame.size.height);
    } completion:^(BOOL finished) {
        
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
