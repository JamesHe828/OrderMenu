//
//  SumbitViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-12.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "SumbitViewController.h"
#import "DataBase.h"
#import "OrderListViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface SumbitViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong) UIDatePicker * datePicker;
@property (nonatomic,strong) IBOutlet UITextView * myTextView;
-(IBAction)backClick:(id)sender;
-(IBAction)sumbitClick:(id)sender;
-(void)pickValueChanged:(UIDatePicker *)aPick;
@end

@implementation SumbitViewController
@synthesize text_contact;
@synthesize text_mark;
@synthesize text_time;
@synthesize bgView;
@synthesize datePicker;
@synthesize idStr;
@synthesize restId;
@synthesize numberStrs;
@synthesize isFromOrder;
@synthesize saveOrderId;
@synthesize textfieldArr;


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
    
    self.myTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.myTextView.layer.borderWidth = 0.2;
    self.myTextView.layer.cornerRadius = 5;
    self.myTextView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.myTextView.layer.shadowOpacity = 1.0;
    self.myTextView.layer.shadowRadius = 1.0;
    self.myTextView.layer.shadowOffset = CGSizeMake(0, 3);
    self.myTextView.clipsToBounds = NO;
    
    self.text_contact.layer.borderColor = [UIColor grayColor].CGColor;
    self.text_contact.layer.borderWidth = 0.2;
    self.text_contact.layer.cornerRadius = 5;
    self.text_contact.layer.shadowColor = [UIColor grayColor].CGColor;
    self.text_contact.layer.shadowOpacity = 1.0;
    self.text_contact.layer.shadowRadius = 0.5;
    self.text_contact.layer.shadowOffset = CGSizeMake(0, 3);
    self.text_contact.clipsToBounds = NO;
    
    self.text_mark.layer.borderColor = [UIColor grayColor].CGColor;
    self.text_mark.layer.borderWidth = 0.2;
    self.text_mark.layer.cornerRadius = 5;
    self.text_mark.layer.shadowColor = [UIColor grayColor].CGColor;
    self.text_mark.layer.shadowOpacity = 1.0;
    self.text_mark.layer.shadowRadius = 0.5;
    self.text_mark.layer.shadowOffset = CGSizeMake(0, 3);
    self.text_mark.clipsToBounds = NO;
    
    self.text_time.layer.borderColor = [UIColor grayColor].CGColor;
    self.text_time.layer.borderWidth = 0.2;
    self.text_time.layer.cornerRadius = 5;
    self.text_time.layer.shadowColor = [UIColor grayColor].CGColor;
    self.text_time.layer.shadowOpacity = 1.0;
    self.text_time.layer.shadowRadius = 0.5;
    self.text_time.layer.shadowOffset = CGSizeMake(0, 3);
    self.text_time.clipsToBounds = NO;
    
    self.text_time.inputView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)sumbitClick:(id)sender
{
    if (self.text_time.text.length>0 && self.text_contact.text.length>0)
    {
        NSString * matchEmail = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
        NSString * matchPhone = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
        NSPredicate *predEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchEmail];
        BOOL isMatchEmail = [predEmail evaluateWithObject:self.text_contact.text];
        NSPredicate *predPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchPhone];
        BOOL isMatchPhone = [predPhone evaluateWithObject:self.text_contact.text];
        if (isMatchEmail || isMatchPhone)
        {
            ASIHTTPRequest * request =  [WebService sumbitOrderAllId:self.idStr restId:self.restId contactNumber:self.text_contact.text eatTime:self.text_time.text mark:self.text_mark.text andNumberS:self.numberStrs];
            [request startAsynchronous];
            NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
            [request setStartedBlock:^{
                [MyActivceView startAnimatedInView:self.view];
            }];
            [request setDataReceivedBlock:^(NSData *data) {
                [reciveData appendData:data];
            }];
            [request setCompletionBlock:^{
                [MyActivceView stopAnimatedInView:self.view];
                NSString * result = [NSString ConverStringfromData:reciveData name:ORDER_NAME];
                if ([result isEqualToString:@"1"])
                {
                    [DataBase insertTellMenuTellNumber:self.text_contact.text];
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    self.text_contact.text = @"";
                    self.text_mark.text = @"";
                    self.text_time.text = @"";
                }
                else
                {
                    [MyAlert ShowAlertMessage:@"提交失败" title:@""];
                }
            }];
            [request setFailedBlock:^{
                [MyActivceView stopAnimatedInView:self.view];
                [MyAlert ShowAlertMessage:@"网速不给力！" title:@"请求超时"];
            }];
        }
        else
        {
            [MyAlert ShowAlertMessage:@"请输入正确的联系方式" title:@""];
        }
    }
    else
    {
        [MyAlert ShowAlertMessage:@"联系方式或就餐时间不能为空！" title:@""];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.isFromOrder)
    {
        if ([DataBase deleteSaveOederFromOrderId:[self.saveOrderId intValue]])
        {
            if ([DataBase deleteResultSave:self.saveOrderId])
            {
                
                NSArray * arr = [self.navigationController viewControllers];
                [arr enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[OrderListViewController class]])
                    {
                        [self.navigationController popToViewController:obj animated:YES];
                    }
                }];
            }
        }
    }
    else
    {
        //  [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100)
    {
        if (!IPhone5)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.7];
            self.bgView.frame = CGRectMake(0, -60, 320, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
    if (textField.tag == 101)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        UIDatePicker * pick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-215, 320, 215)];
        pick.minimumDate = [NSDate date];
        
        NSDate * tempDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
        NSString * str = [NSString stringWithFormat:@"%@",tempDate];
        NSString * result = [[str substringWithRange:NSMakeRange(0, 10)] stringByAppendingFormat:@" 11:30"];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate * resultDate = [formatter dateFromString:result];
        [pick setDate:resultDate];
        
        
        [pick addTarget:self action:@selector(pickValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.datePicker = pick;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
        pick.locale = locale;
        [self.view addSubview:pick];
        if (IPhone5)
        {
            self.bgView.frame = CGRectMake(0, -10, 320, self.view.frame.size.height);
        }
        else
        {
            self.bgView.frame = CGRectMake(0, -60, 320, self.view.frame.size.height);
        }
        [UIView commitAnimations];
    }
    if (textField.tag == 102)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        if (self.datePicker != nil)
        {
            [self.datePicker removeFromSuperview];
        }
        if (IPhone5)
        {
            self.bgView.frame = CGRectMake(0, -10, 320, self.view.frame.size.height);
        }
        else
        {
            self.bgView.frame = CGRectMake(0, -60, 320, self.view.frame.size.height);
        }
        
        [UIView commitAnimations];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.text_contact resignFirstResponder];
    [self.text_mark resignFirstResponder];
    [self.text_time resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    self.bgView.frame = CGRectMake(0, 43, 320, self.bgView.frame.size.height);
    if (self.datePicker != nil)
    {
        NSArray * arr = [self.view subviews];
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIDatePicker class]])
            {
                [obj removeFromSuperview];
            }
        }];
    }
    [UIView commitAnimations];
}

#pragma mark - pick事件
-(void)pickValueChanged:(UIDatePicker *)aPick
{
    if ([aPick.date timeIntervalSinceDate:[NSDate date]]<0)
    {
        NSDate * tempDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
        NSString * str = [NSString stringWithFormat:@"%@",tempDate];
        NSString * result = [[str substringWithRange:NSMakeRange(0, 10)] stringByAppendingFormat:@" 11:30"];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate * resultDate = [formatter dateFromString:result];
        [aPick setDate:resultDate];
        self.text_time.text = result;
    }
    else
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString* dateStr = [dateFormatter stringFromDate:aPick.date];
        NSString * tempStr = [dateStr substringToIndex:16];
        self.text_time.text = tempStr;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
