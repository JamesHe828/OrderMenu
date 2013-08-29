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
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"
#import "DataBase.h"
#import "MenuCheckViewController.h"

@interface DishesListViewController ()<UIAlertViewDelegate>
{
    BOOL isFirst;
    int selectRow;
    __block double sum;
}
@property (nonatomic,strong) NSMutableArray * myClassArr;
@property (nonatomic,strong) UIButton * audoButton;
@property (nonatomic,strong) NSMutableArray * myProArr;
@property (nonatomic,strong) UIButton * backButton;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableDictionary * tempClassDic;
@property (nonatomic,strong) NSMutableDictionary * tempDotNumberDic;
-(IBAction)backClick:(id)sender;
-(IBAction)audoClickEvent:(id)sender;
-(void)getClassData;
-(void)getProductData:(NSString *)aClassid;
-(void)leftButtonClickEvent:(UIButton *)aButton;
-(void)rightButtonClickEvent:(UIButton *)aButton;
-(void)bigButtonClickEvent:(UIButton *)aButton;
@end

@implementation DishesListViewController
@synthesize classTableView;
@synthesize productTableView;
@synthesize myClassArr;
@synthesize myProArr;
@synthesize audoButton;
@synthesize backButton;
@synthesize resultID;
@synthesize resInfoArr;
@synthesize dataArr;
@synthesize tempClassDic;
@synthesize tempDotNumberDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //添加底部
    self.dataArr = [DataBase selectAllProduct];
    PriceView * pcView;
    if (pcView == nil)
    {
        pcView = [PriceView ShareView];
        pcView.delegate = self;
        [self.view addSubview:pcView];
    }
    
    NSArray * tempArr = [self.tempDotNumberDic allKeys];
    [tempArr enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL *stop) {
        [self.tempDotNumberDic setValue:@"0" forKey:key];
    }];
    __block NSMutableArray * arrKeys = [NSMutableArray arrayWithCapacity:0];
    [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        [arrKeys addObject:[obj valueForKey:@"ProID"]];
    }];
    [arrKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        [self.tempDotNumberDic setValue:[[self.dataArr objectAtIndex:idx] valueForKey:@"number"] forKey:obj];
    }];
    
    NSMutableArray * mutableArr = [DataBase selectAllArrayProId];
    __block NSMutableArray * arr;
    sum = 0;
    __block double addNum = 0;
    __block int sumNumber = 0;
    [mutableArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        arr = [DataBase selectNumberFromProId:[obj intValue]];
        sumNumber += [[[arr objectAtIndex:0] valueForKey:@"number"] intValue];
        addNum = [[[arr objectAtIndex:0] valueForKey:@"number"] doubleValue]*[[[arr objectAtIndex:0] valueForKey:@"price"] doubleValue];
        sum += addNum;
    }];
    [[PriceView ShareView] ChangeLabTextSumPrice:sum sumDishes:sumNumber];
    float heigh;
    if (IPhone5)
    {
        heigh = 506;
    }
    else
    {
        heigh = 417;
    }

    if ([PriceView ShareView].sumnumber > 0)
    {
        [PriceView AnimateCome];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.classTableView.frame = CGRectMake(self.classTableView.frame.origin.x,self.classTableView.frame.origin.y,self.classTableView.frame.size.width,heigh-40);
        self.productTableView.frame = CGRectMake(self.productTableView.frame.origin.x,self.productTableView.frame.origin.y,self.productTableView.frame.size.width,heigh-40);
        [UIView commitAnimations]; 
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.classTableView.frame = CGRectMake(self.classTableView.frame.origin.x,self.classTableView.frame.origin.y,self.classTableView.frame.size.width,heigh);
        self.productTableView.frame = CGRectMake(self.productTableView.frame.origin.x,self.productTableView.frame.origin.y,self.productTableView.frame.size.width,heigh);
        [UIView commitAnimations];
        [PriceView AnimateCancle];
    }
    [self.productTableView reloadData];
}

-(IBAction)backClick:(id)sender
{
    PriceView * pcView = [PriceView ShareView];
    [pcView ChangeLabTextSumPrice:0 sumDishes:0];
    [PriceView AnimateCancle];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isFirst = YES;
    self.tempClassDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.tempDotNumberDic = [NSMutableDictionary dictionaryWithCapacity:0];
    //清楚数据库中得数据
    selectRow = 0;
    self.classTableView.bounces = NO;
    self.productTableView.bounces = NO;
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.classTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    DishesClassCell * cell = (DishesClassCell *)[self.classTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.isClick = YES;
    
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
            
            if (self.myClassArr.count>0)
            {
                [self.classTableView reloadData];
                [self getProductData:[[self.myClassArr objectAtIndex:0] valueForKey:@"classID"]];
            }
            else
            {
                [MyActivceView stopAnimatedInView:self.view];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此餐馆还未上传！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    }];
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
        if (indexPath.row<self.myClassArr.count)
        {
            cell.textContentLab.textColor = [UIColor blackColor];
            cell.textContentLab.text = [[self.myClassArr objectAtIndex:indexPath.row] valueForKey:@"ClassName"];
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
        return cell;
    }
    
    NSString *str1 = [NSString stringWithFormat:@"cellmark%d",selectRow];
    NSString * strMark1 = str1; //不同类别用不同的重用标示符，目的是为了不同分类同一位置的重用现象。
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
    if (resylt == 0)
    {
        [cell1.dishView zeroState];
    }
    else
    {
        [cell1.dishView initView:resylt];
    }
    if (indexPath.row%2 == 0)
    {
        cell1.backgroundImageView.image = [UIImage imageNamed:@"5.png"];
    }
    else
    {
        cell1.backgroundImageView.image = [UIImage imageNamed:@"5.png"];
    }
    cell1.selectionStyle=UITableViewCellSelectionStyleNone;
    cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
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
    if ([PriceView ShareView].sumnumber == 0)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.classTableView.frame = CGRectMake(self.classTableView.frame.origin.x,self.classTableView.frame.origin.y,self.classTableView.frame.size.width,self.classTableView.frame.size.height-40);
        self.productTableView.frame = CGRectMake(self.productTableView.frame.origin.x,self.productTableView.frame.origin.y,self.productTableView.frame.size.width,self.productTableView.frame.size.height-40);
        [UIView commitAnimations];
        
        [PriceView AnimateCome];
        [[PriceView ShareView] ChangeLabTextSumPrice:cell.dishView.price sumDishes:1];
    }
    else
    {
        double priceSum = [PriceView ShareView].sumprice;
        int numberSum = [PriceView ShareView].sumnumber;
        
        [[PriceView ShareView] ChangeLabTextSumPrice:priceSum-cell.dishView.price sumDishes:numberSum-1];
        if (numberSum-1 == 0)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            self.classTableView.frame = CGRectMake(self.classTableView.frame.origin.x,self.classTableView.frame.origin.y,self.classTableView.frame.size.width,self.classTableView.frame.size.height+40);
            self.productTableView.frame = CGRectMake(self.productTableView.frame.origin.x,self.productTableView.frame.origin.y,self.productTableView.frame.size.width,self.productTableView.frame.size.height+40);
            [UIView commitAnimations];
            [PriceView AnimateCancle];
        }
    }
    
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
    UIImageView * clickImgView = (UIImageView *)[[aButton superview] superview];
    //加入购物车动画效果
    CALayer *transitionLayer = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 0.4;
    transitionLayer.contents = (id)clickImgView.layer.contents;
    transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:clickImgView.bounds fromView:clickImgView];
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
    group.duration = 0.3;
    group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
    group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.autoreverses= NO;
    [transitionLayer addAnimation:group forKey:@"opacity"];
    
    
    if ([PriceView ShareView].sumnumber == 0)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.classTableView.frame = CGRectMake(self.classTableView.frame.origin.x,self.classTableView.frame.origin.y,self.classTableView.frame.size.width,self.classTableView.frame.size.height-40);
        self.productTableView.frame = CGRectMake(self.productTableView.frame.origin.x,self.productTableView.frame.origin.y,self.productTableView.frame.size.width,self.productTableView.frame.size.height-40);
        [UIView commitAnimations];
        [PriceView AnimateCome];
        [[PriceView ShareView] ChangeLabTextSumPrice:cell.dishView.price sumDishes:1];
    }
    else
    {
        double priceSum = [PriceView ShareView].sumprice;
        int numberSum = [PriceView ShareView].sumnumber;
        [[PriceView ShareView] ChangeLabTextSumPrice:priceSum+cell.dishView.price sumDishes:numberSum+1];
    }
    
    NSDictionary * obj = [self.myProArr objectAtIndex:cell.dishView.index];
    [DataBase UpdateDotNumber:[[obj valueForKey:@"ProID"] intValue] currDotNumber:cell.dishView.dotNumber];
    
    [self.tempDotNumberDic setValue:[NSString stringWithFormat:@"%d",cell.dishView.dotNumber] forKey:[obj valueForKey:@"ProID"]];
}
-(void)bigButtonClickEvent:(UIButton *)aButton
{
    
    DishesDetailListCell * cell = (DishesDetailListCell *)[[[aButton superview] superview] superview];
    
    UIImageView * clickImgView = (UIImageView *)[[aButton superview] superview];
    //加入购物车动画效果
    CALayer *transitionLayer = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 0.4;
    transitionLayer.contents = (id)clickImgView.layer.contents;
    transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:clickImgView.bounds fromView:clickImgView];
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
    
    if ([PriceView ShareView].sumnumber == 0)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        self.classTableView.frame = CGRectMake(self.classTableView.frame.origin.x,self.classTableView.frame.origin.y,self.classTableView.frame.size.width,self.classTableView.frame.size.height-40);
        self.productTableView.frame = CGRectMake(self.productTableView.frame.origin.x,self.productTableView.frame.origin.y,self.productTableView.frame.size.width,self.productTableView.frame.size.height-40);
        [UIView commitAnimations];
        
        [PriceView AnimateCome];
        [[PriceView ShareView] ChangeLabTextSumPrice:cell.dishView.price sumDishes:1];
    }
    else
    {
        double priceSum = [PriceView ShareView].sumprice;
        int numberSum = [PriceView ShareView].sumnumber;
        [[PriceView ShareView] ChangeLabTextSumPrice:priceSum+cell.dishView.price sumDishes:numberSum+1];
    }
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
#pragma mark - 点击智能点菜按钮出发事件
-(IBAction)audoClickEvent:(id)sender
{
    [DataBase clearOrderMenu];
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
    audo.resInfoArr = self.resInfoArr;
    [self.navigationController pushViewController:audo animated:YES];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
