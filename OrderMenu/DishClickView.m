//
//  DishClickView.m
//  test
//
//  Created by tiankong360 on 13-8-1.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DishClickView.h"
#import <QuartzCore/QuartzCore.h>

@interface DishClickView()
{
    UIButton * testBtn;
}
-(void)buttonClick:(UIButton *)aButton;
-(void)leftButtonClick:(UIButton *)aButton;
-(void)rightButtonClick:(UIButton *)aButton;
-(void)initView:(int)aNumber;
@end

@implementation DishClickView
@synthesize index;
@synthesize leftButton;
@synthesize rightButton;
@synthesize bigButton;
@synthesize price;

//80, 100, 160, 40
- (DishClickView *)initWithFrame:(CGRect)frame andNumber:(int)aNumber
{
    self = [super initWithFrame:frame];
    if (self)
    {
        testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.bigButton = testBtn;
        testBtn.backgroundColor = [UIColor clearColor];
        [testBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [testBtn setBackgroundImage:[UIImage imageNamed:@"clickhere.png"] forState:UIControlStateNormal];
        testBtn.frame = CGRectMake(10, 5, 80, 30);
        [self addSubview:testBtn];
        
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton = leftBtn;
        [leftBtn addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.alpha = 0.0;
        leftBtn.frame = CGRectMake(0, 0, 40, 40);
        [leftBtn setImage:[UIImage imageNamed:@"DishClass04@2x.png"] forState:UIControlStateNormal];
        leftBtn.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:leftBtn];
        
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton = rightBtn;
        [rightBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.alpha = 0.0;
        rightBtn.frame = CGRectMake(50, 0, 40, 40); 
        [rightBtn setImage:[UIImage imageNamed:@"DishClass03@2x.png"] forState:UIControlStateNormal];
        rightBtn.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:rightBtn];
        
        UILabel * middleLab = [[UILabel alloc] initWithFrame:CGRectMake(32, 15, 35, 10)];
        self.myLab = middleLab;
        middleLab.font = [UIFont systemFontOfSize:10];
        middleLab.alpha = 0;
        middleLab.textAlignment = NSTextAlignmentCenter;
        middleLab.textColor = [UIColor redColor];
        middleLab.backgroundColor = [UIColor clearColor];
        [self addSubview:middleLab];
        
        if (aNumber >0)
        {
            [self initView:aNumber];
        }
    }
    return self;
}
-(void)leftButtonClick:(UIButton *)aButton
{
    self.dotNumber--;
    self.myLab.text = [NSString stringWithFormat:@"点%d份",self.dotNumber];
    if (self.dotNumber == 0)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        testBtn.alpha = 1.0;
        self.myLab.alpha = 0.0;
        self.leftButton.alpha = 0.0;
        self.rightButton.alpha = 0.0;
        self.leftButton.frame = CGRectMake(30, 0, 40, 40);
        self.rightButton.frame = CGRectMake(30, 0, 40, 40);
        [UIView commitAnimations];
    }
}

-(void)rightButtonClick:(UIButton *)aButton
{
    self.dotNumber++;
    self.myLab.text = [NSString stringWithFormat:@"点%d份",self.dotNumber];
}

-(void)buttonClick:(UIButton *)aButton
{
    self.dotNumber = 1;
    self.myLab.text = [NSString stringWithFormat:@"点%d份",self.dotNumber];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    testBtn.alpha = 0.0;
    self.myLab.alpha = 1.0;
    self.leftButton.alpha = 1.0;
    self.rightButton.alpha = 1.0;
    self.leftButton.frame = CGRectMake(0, 0, 40, 40);
    self.rightButton.frame = CGRectMake(60, 0, 40,40);
    [UIView commitAnimations];
}
-(void)initView:(int)aNumber
{
    self.dotNumber = aNumber;
    self.myLab.text = [NSString stringWithFormat:@"点%d份",self.dotNumber];
    testBtn.alpha = 0.0;
    self.myLab.alpha = 1.0;
    self.leftButton.alpha = 1.0;
    self.rightButton.alpha = 1.0;
    self.leftButton.frame = CGRectMake(0, 0, 40, 40);
    self.rightButton.frame = CGRectMake(60, 0, 40, 40);
}
-(void)zeroState
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    testBtn.alpha = 1.0;
    self.myLab.alpha = 0.0;
    self.leftButton.alpha = 0.0;
    self.rightButton.alpha = 0.0;
    self.leftButton.frame = CGRectMake(30, 0, 40, 40);
    self.rightButton.frame = CGRectMake(30, 0, 40, 40);
    [UIView commitAnimations];
}

@end
