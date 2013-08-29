//
//  AudoDishesListViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-15.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "AudoDishesListViewController.h"
#import "DishesDetailListCell.h"
#import "DishesClassCell.h"
#import "DishesSelectedButton.h"
#import "ASIHTTPRequest.h"
#import "DataBase.h"
#import "AudoResultViewController.h"
#import "OrderDetailViewController.h"

@interface AudoDishesListViewController ()
{
    int selectRow;
    BOOL isFirst;
}
@property (nonatomic,strong) NSArray * myClassArr;
@property (nonatomic,strong) NSMutableArray * myProArr;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray * id_arr;
@property (nonatomic,strong) NSMutableDictionary * tempClassDic;
@property (nonatomic,strong) NSMutableDictionary * tempDotNumberDic;



-(IBAction)backClick:(id)sender;
-(IBAction)yesClick:(id)sender;
-(void)getClassData;
-(void)getProductData:(NSString *)aClassid;
@end

@implementation AudoDishesListViewController
@synthesize classTableView;
@synthesize productTableView;
@synthesize myClassArr;
@synthesize myProArr;
@synthesize resultID;
@synthesize dataArr;
@synthesize id_arr;
@synthesize myViewController;
@synthesize orderDetail;
@synthesize tempClassDic;
@synthesize tempDotNumberDic;


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
    
    isFirst = YES;
    
    self.tempClassDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.tempDotNumberDic = [NSMutableDictionary dictionaryWithCapacity:0];
    //点菜的数目 初始化
    self.id_arr = [NSMutableArray arrayWithCapacity:0];
    selectRow = 0;
    self.classTableView.bounces = NO;
    self.productTableView.bounces = NO;
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.classTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getClassData];
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
            [self.myClassArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (idx == 0)
                {
                    [self.tempClassDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",idx]];
                }
                else
                {
                    [self.tempClassDic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",idx]];
                }
            }];
            self.dataArr = [DataBase selectAllProduct];
            [self.classTableView reloadData];
            [self getProductData:[[self.myClassArr objectAtIndex:0] valueForKey:@"classID"]];
        });
    }];
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
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
        if (isFirst)
        {
            isFirst = NO;
            [self.myProArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.tempDotNumberDic setValue:@"0" forKey:[[self.myProArr objectAtIndex:idx] valueForKey:@"ProID"]];
            }];
        }
        self.dataArr = [DataBase selectAllProduct];
        [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            [self.tempDotNumberDic setValue:[obj valueForKey:@"number"] forKey:[obj valueForKey:@"ProID"]];
        }];
        [self.productTableView reloadData];
    }];
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
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
        if (self.tempClassDic.count>0)
        {
            NSString * result = [self.tempClassDic valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            if ([result isEqualToString:@"1"])
            {
                cell.backgroundImageView.image = [UIImage imageNamed:@"菜单分类背景.png"];
            }
            else
            {
                cell.backgroundImageView.image = [UIImage imageNamed:@"菜单分类背景2.png"];
            }
        }
        cell.textContentLab.text = [[self.myClassArr objectAtIndex:indexPath.row] valueForKey:@"ClassName"];
        cell.textContentLab.textColor = [UIColor blackColor];
        return cell;
    }
    
    NSString *str1 = [NSString stringWithFormat:@"cellmark%d",selectRow];
    NSString * strMark1 = str1; //不停类别用不同的重用标示符，目的是为了不同分类同一位置的重用现象。
    DishesDetailListCell * cell1 = [tableView dequeueReusableCellWithIdentifier:strMark1];
   __block int dotNumber = 0;
    if (indexPath.row < self.myProArr.count)
    {
        __block NSString * proID;
        NSString * currID = [[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"];
        [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            proID = [obj valueForKey:@"ProID"];
            if ([currID isEqualToString:proID])
            {
                dotNumber = [[[[DataBase selectNumberFromProId:[currID intValue]] objectAtIndex:0] valueForKey:@"number"] intValue];
            }
        }];
    }
    if (cell1 == nil)
    {
        cell1 = [[DishesDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMark1 andDotNumber:dotNumber];
    }
    int resylt = [[self.tempDotNumberDic valueForKey:[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]] intValue];
    NSLog(@"number = %d,id = %@",resylt,[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]);
    if (resylt == 0)
    {
        [cell1.dishView zeroState];
    }
    else
    {
        [cell1.dishView initView:resylt];
    }
    
    NSLog(@"result = %d,proid = %@",resylt,[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]);
  //  cell1.dishView.myLab.text = [NSString stringWithFormat:@"点%d份",dotNumber];
    
    if (indexPath.row%2 == 0)
    {
        cell1.backgroundImageView.image = [UIImage imageNamed:@"5.png"];
    }
    else
    {
        cell1.backgroundImageView.image = [UIImage imageNamed:@"5.png"];
    }
    cell1.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //判断是否有已经推荐过的菜系
   
    cell1.titleLab.text = [[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProName"];
    NSString * str = @"￥";
    NSString * priceStr = [[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"prices"];
    cell1.priceLab.text = [str stringByAppendingFormat:@"%@",priceStr];
    
    cell1.dishView.price = [priceStr doubleValue];
    cell1.dishView.index = indexPath.row;
    
    [cell1.dishView.rightButton addTarget:self action:@selector(rightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell1.dishView.leftButton addTarget:self action:@selector(leftButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell1.dishView.bigButton addTarget:self action:@selector(bigButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString * pathURL = ALL_URL;
    NSURL * url = [NSURL URLWithString:[pathURL stringByAppendingFormat:@"%@",[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProductImg"]]];
    [cell1.leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:ALL_NO_IMAGE]];
    return cell1;
}

#pragma mark - 点菜触发事件
-(void)leftButtonClickEvent:(UIButton *)aButton
{
    DishesDetailListCell * cell = (DishesDetailListCell *)[[[aButton superview] superview] superview];
    NSDictionary * obj = [self.myProArr objectAtIndex:cell.dishView.index];
    if (cell.dishView.dotNumber == 0)
    {
        [DataBase deleteProID:[[obj valueForKey:@"ProID"] intValue]];
    }
    else
    {
        [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:cell.dishView.dotNumber];
    }
    
    [self.tempDotNumberDic setValue:[NSString stringWithFormat:@"%d",cell.dishView.dotNumber] forKey:[obj valueForKey:@"ProID"]];
}
-(void)rightButtonClickEvent:(UIButton *)aButton
{
    DishesDetailListCell * cell = (DishesDetailListCell *)[[[aButton superview] superview] superview];
    NSDictionary * obj = [self.myProArr objectAtIndex:cell.dishView.index];
    [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:cell.dishView.dotNumber];
    
    [self.tempDotNumberDic setValue:[NSString stringWithFormat:@"%d",cell.dishView.dotNumber] forKey:[obj valueForKey:@"ProID"]];
}
-(void)bigButtonClickEvent:(UIButton *)aButton
{
    DishesDetailListCell * cell = (DishesDetailListCell *)[[[aButton superview] superview] superview];
    NSDictionary * obj = [self.myProArr objectAtIndex:cell.dishView.index];
    [DataBase insertProID:[[obj valueForKey:@"ProID"] intValue] menuid:[[obj valueForKey:@"Menuid"] intValue] proName:[obj valueForKey:@"ProName"] price:[[obj valueForKey:@"prices"] doubleValue] image:[obj valueForKey:@"ProductImg"] andNumber:1];
    
    [self.tempDotNumberDic setValue:[NSString stringWithFormat:@"%d",cell.dishView.dotNumber] forKey:[obj valueForKey:@"ProID"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView.tag == 100)
    {
         selectRow = indexPath.row;
        [self.myClassArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx == indexPath.row)
            {
                [self.tempClassDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",idx]];
            }
            else
            {
                [self.tempClassDic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",idx]];
            }
            [self.classTableView reloadData];
        }];

        if (self.myProArr.count > 0)
        {
            [self.myProArr removeAllObjects];
        }
        NSString * classid = [[self.myClassArr objectAtIndex:indexPath.row] valueForKey:@"classID"];
        [self getProductData:classid];
    }
}
-(IBAction)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.id_arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
            [DataBase deleteProID:[obj intValue]];
        }];
    }];
}

-(IBAction)yesClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.orderDetail != nil)
            {
                [self.orderDetail performSelector:@selector(refreshAddDishesTableview)];
            }
            if (self.myViewController != nil)
            {
                [self.myViewController performSelector:@selector(refeTable)];
            }
        });
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
