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
#import <QuartzCore/QuartzCore.h>

@interface AudoDishesListViewController ()
{
    int selectRow;
    BOOL isFirst;
    BOOL isTest;
}
@property (nonatomic,strong) NSArray * myClassArr;
@property (nonatomic,strong) NSMutableArray * myProArr;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray * id_arr;
@property (nonatomic,strong) NSMutableDictionary * tempClassDic;
@property (nonatomic,strong) NSMutableDictionary * tempDotNumberDic;

@property (nonatomic,strong) NSMutableDictionary * priceAndNumberDic;
@property (nonatomic,strong) NSMutableDictionary * indexDic;
@property (nonatomic,strong) NSMutableDictionary * dotNumberDic;
@property (nonatomic,strong) IBOutlet UIImageView * nav_imageview;;

@property (nonatomic,strong) IBOutlet UIButton * btn_back;
@property (nonatomic,strong) IBOutlet UIButton * btn_yes;


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

@synthesize priceAndNumberDic;
@synthesize indexDic;
@synthesize dotNumberDic;
@synthesize nav_imageview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
//    if ([NSString IOS_7])
//    {
//        UIWindow * window1 = [UIApplication sharedApplication].delegate.window;
//        window1.frame = [[UIScreen mainScreen] applicationFrame];
//        window1.clipsToBounds =YES;
//        
//        if (IPhone5)
//        {
//            window1.frame =  CGRectMake(0,20,320,568);
//            window1.bounds = CGRectMake(0, 0, 320, 568);
//            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ios7"] isEqualToString:@"1"])
//            {
//                window1.bounds = CGRectMake(0, -20, 320, 568);
//            }
//        }
//        else
//        {
//            window1.frame =  CGRectMake(0,30,320,460);
//            window1.bounds = CGRectMake(0, 0, 320, 480);
//            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ios7"] isEqualToString:@"1"])
//            {
//                window1.bounds = CGRectMake(0, -20, 320, 480);
//            }
//        }
    
        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        self.nav_imageview.frame = CGRectMake(0, 20, 320, 44);
//        if (IPhone5)
//        {
//            self.classTableView.frame = CGRectMake(0, 64, 84, 505);
//            self.productTableView.frame = CGRectMake(84, 64, 237, 505);
//            self.btn_back.frame = CGRectMake(0, 20, 44, 44);
//            self.btn_yes.frame = CGRectMake(266, 20, 54, 41);
//        }
//        else
//        {
//            self.classTableView.frame = CGRectMake(0, 64, 84, 427);
//            self.productTableView.frame = CGRectMake(84, 64, 237, 417);
//            self.btn_back.frame = CGRectMake(0, 20, 44, 44);
//            self.btn_yes.frame = CGRectMake(266, 20, 54, 41);
//        }
//    }
}
-(void)viewWillDisappear:(BOOL)animated
{
//    if ([NSString IOS_7])
//    {
//        if (IPhone5)
//        {
//            UIWindow * window1 = [UIApplication sharedApplication].delegate.window;
//            window1.frame = [[UIScreen mainScreen] applicationFrame];
//            window1.bounds = CGRectMake(0,-20,320, window1.frame.size.height);
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        }
//        else
//        {
//            UIWindow * window1 = [UIApplication sharedApplication].delegate.window;
//            window1.frame = [[UIScreen mainScreen] applicationFrame];
//            window1.bounds = CGRectMake(0,-20,320, window1.frame.size.height);
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        }
//       
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tempClassDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.tempDotNumberDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.priceAndNumberDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.indexDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.dotNumberDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
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
    NSLog(@"self.resultid = %d",self.resultID);
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
        
        isTest = YES;
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
    //    NSString * str = @"折扣价:￥";
    //    NSString * priceStr = [[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"prices"];
    //    cell1.priceLab.text = [str stringByAppendingFormat:@"%@",priceStr];
    //
    //    cell1.historypriceLab.text = @"原价:￥12.3";
    //
    //    cell1.dishView.price = [priceStr doubleValue];
    
    
    
    NSString * disprice = [NSString stringWithFormat:@"%@",[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"DiscountPrice"]];
    NSLog(@"disprice = %@",disprice);
    if (disprice.length>0)
    {
        NSString * str = @"折扣价:￥";
        NSString * priceStr = [[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"DiscountPrice"];
        cell1.priceLab.text = [str stringByAppendingFormat:@"%@",priceStr];
        cell1.dishView.price = [priceStr doubleValue];
        NSString * str11 = [[self.dataArr objectAtIndex:indexPath.row] valueForKey:@"prices"];
        cell1.historypriceLab.text = [NSString stringWithFormat:@"原价:￥%@",str11];
        
        [self.priceAndNumberDic setValue:priceStr forKey:[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
        cell1.price = [priceStr doubleValue];
    }
    else
    {
        NSString * str = @" 原价:￥";
        NSString * priceStr = [[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"prices"];
        cell1.priceLab.text = [str stringByAppendingFormat:@"%@",priceStr];
        cell1.dishView.price = [priceStr doubleValue];
        
        [self.priceAndNumberDic setValue:priceStr forKey:[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
        cell1.price = [priceStr doubleValue];
    }
    
    cell1.dishView.index = indexPath.row;
    
    [cell1.dishView.rightButton addTarget:self action:@selector(rightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell1.dishView.leftButton addTarget:self action:@selector(leftButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell1.dishView.bigButton addTarget:self action:@selector(bigButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // [self.priceAndNumberDic setValue:priceStr forKey:[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
    [self.indexDic setValue:[NSNumber numberWithInt:indexPath.row] forKey:[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
    [self.dotNumberDic setValue:[NSNumber numberWithInt:dotNumber] forKey:[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"]];
    cell1.dishView.rightButton.tag = [[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
    cell1.dishView.leftButton.tag = [[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
    cell1.dishView.bigButton.tag = [[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProID"] intValue];
    
    
    
    NSString * pathURL = ALL_URL;
    NSURL * url = [NSURL URLWithString:[pathURL stringByAppendingFormat:@"%@",[[self.myProArr objectAtIndex:indexPath.row] valueForKey:@"ProductImg"]]];
    [cell1.leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:ALL_NO_IMAGE]];
    cell1.titleLab.font = [UIFont systemFontOfSize:12];
    cell1.titleLab.numberOfLines = 2;
    cell1.titleLab.frame = CGRectMake(70, 15, 140, 35);
    cell1.leftImageView.layer.borderColor = [UIColor grayColor].CGColor;
    cell1.leftImageView.layer.borderWidth = 1;
    cell1.leftImageView.layer.cornerRadius = 5;
    return cell1;
}

#pragma mark - 点菜触发事件
-(void)leftButtonClickEvent:(UIButton *)aButton
{
    // DishesDetailListCell * cell = (DishesDetailListCell *)[[[aButton superview] superview] superview];
    //    [[self.priceAndNumberDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] doubleValue]
    //    [[self.indexDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue]
    NSDictionary * obj = [self.myProArr objectAtIndex:[[self.indexDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue]];
    int dot1 = [[self.tempDotNumberDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue];
    dot1 --;
    if (dot1 == 0)
    {
        [DataBase deleteProID:[[obj valueForKey:@"ProID"] intValue]];
    }
    else
    {
        [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:dot1];
    }
    
    [self.tempDotNumberDic setValue:[NSString stringWithFormat:@"%d",dot1] forKey:[obj valueForKey:@"ProID"]];
}
-(void)rightButtonClickEvent:(UIButton *)aButton
{
    int dot1 = [[self.tempDotNumberDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue];
    dot1 --;
    // DishesDetailListCell * cell = (DishesDetailListCell *)[[[aButton superview] superview] superview];
    NSDictionary * obj = [self.myProArr objectAtIndex:[[self.indexDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue]];
    [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:dot1];
    [self.tempDotNumberDic setValue:[NSString stringWithFormat:@"%d",dot1] forKey:[obj valueForKey:@"ProID"]];
}
-(void)bigButtonClickEvent:(UIButton *)aButton
{
    //int dot1 = [[self.tempDotNumberDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue];
    
    // DishesDetailListCell * cell = (DishesDetailListCell *)[[[aButton superview] superview] superview];
    NSDictionary * obj = [self.myProArr objectAtIndex:[[self.indexDic valueForKey:[NSString stringWithFormat:@"%d",aButton.tag]] intValue]];
    double  price1 = 0.0;
    if ([[obj valueForKey:@"DiscountPrice"] doubleValue] == 0.0)
    {
        price1 = [[obj valueForKey:@"prices"] doubleValue];
    }
    else
    {
        price1 = [[obj valueForKey:@"DiscountPrice"] doubleValue];
    }
    
    [DataBase insertProID:[[obj valueForKey:@"ProID"] intValue] menuid:[[obj valueForKey:@"Menuid"] intValue] proName:[obj valueForKey:@"ProName"] price:price1 image:[obj valueForKey:@"ProductImg"] andNumber:1];
    [self.tempDotNumberDic setValue:[NSNumber numberWithInt:1] forKey:[obj valueForKey:@"ProID"]];
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
//    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"ios7"];
//    UIWindow * window1 = [UIApplication sharedApplication].delegate.window;
//    if (IPhone5)
//    {
//        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ios7"] isEqualToString:@"1"])
//        {
//            window1.bounds = CGRectMake(0, 0, 320, 568);
//        }
//    }
//    else
//    {
//        window1.bounds = CGRectMake(0, 0, 320, 480);
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.id_arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
//            [DataBase deleteProID:[obj intValue]];
//        }];
//    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height+100, 320, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.id_arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
            [DataBase deleteProID:[obj intValue]];
        }];
    }];
}

-(IBAction)yesClick:(id)sender
{
 //   [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"ios7"];
//    UIWindow * window1 = [UIApplication sharedApplication].delegate.window;
//    if (IPhone5)
//    {
//        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ios7"] isEqualToString:@"1"])
//        {
//            window1.bounds = CGRectMake(0, 0, 320, 568);
//        }
//    }
//    else
//    {
//        window1.bounds = CGRectMake(0, 0, 320, 480);
//    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height+100, 320, self.view.frame.size.height);
    } completion:^(BOOL finished) {
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
//    [self dismissViewControllerAnimated:YES completion:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self.orderDetail != nil)
//            {
//                [self.orderDetail performSelector:@selector(refreshAddDishesTableview)];
//            }
//            if (self.myViewController != nil)
//            {
//                [self.myViewController performSelector:@selector(refeTable)];
//            }
//        });
//    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
