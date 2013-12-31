//
//  DishesDetailListCell.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-10.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DishesDetailListCell.h"
#import <QuartzCore/QuartzCore.h>


@interface DishesDetailListCell()
-(void)leftClick:(UIButton *)aLeft;
-(void)rightClick:(UIButton *)aRight;
-(void)bigClick:(UIButton *)aBig;
@end

@implementation DishesDetailListCell
@synthesize backgroundImageView;
@synthesize leftImageView;
@synthesize titleLab;
@synthesize priceLab;
@synthesize dishesButton;
@synthesize dishView;
@synthesize delegate;
@synthesize historypriceLab;
@synthesize price;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 80)];
        bgView.userInteractionEnabled = YES;
        self.backgroundImageView = bgView;
        [self addSubview:bgView];
        
        UIImageView * leftView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 60, 60)];
        self.leftImageView = leftView;
        [bgView addSubview:leftView];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 150, 31)];
        title.numberOfLines = 2;
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:15];
        self.titleLab = title;
        [bgView addSubview:title];
        
        UILabel * price13 = [[UILabel alloc] initWithFrame:CGRectMake(70, 46, 80, 13)];
        price13.font = [UIFont systemFontOfSize:10];
        price13.textColor = [UIColor redColor];
        price13.backgroundColor = [UIColor clearColor];
        self.priceLab = price13;
        [bgView addSubview:price13];
        
        UILabel * price14 = [[UILabel alloc] initWithFrame:CGRectMake(70, 59, 80, 15)];
        price14.font = [UIFont systemFontOfSize:10];
        price14.textColor = [UIColor redColor];
        price14.backgroundColor = [UIColor clearColor];
        self.historypriceLab = price14;
        [bgView addSubview:price14];
        
        
        DishClickView * clickView = [[DishClickView alloc] initWithFrame:CGRectMake(140, 35, 90, 40) andNumber:0];
        self.dishView = clickView;
        [bgView addSubview:clickView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDotNumber:(int)aDotNumber
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 80)];
        bgView.userInteractionEnabled = YES;
        self.backgroundImageView = bgView;
        [self addSubview:bgView];
        
        UIImageView * leftView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 60, 60)];
        self.leftImageView = leftView;
        [bgView addSubview:leftView];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 150, 31)];
        title.numberOfLines = 2;
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:15];
        self.titleLab = title;
        [bgView addSubview:title];
        
        UILabel * price13 = [[UILabel alloc] initWithFrame:CGRectMake(70, 46, 80, 13)];
        price13.font = [UIFont systemFontOfSize:10];
        price13.textColor = [UIColor redColor];
        price13.backgroundColor = [UIColor clearColor];
        self.priceLab = price13;
        [bgView addSubview:price13];
        
        UILabel * price14 = [[UILabel alloc] initWithFrame:CGRectMake(70, 59, 80, 15)];
        price14.font = [UIFont systemFontOfSize:10];
        price14.textColor = [UIColor redColor];
        price14.backgroundColor = [UIColor clearColor];
        self.historypriceLab = price14;
        [bgView addSubview:price14];
        
        
        DishClickView * clickView = [[DishClickView alloc] initWithFrame:CGRectMake(140, 35, 90, 40) andNumber:aDotNumber];
        self.dishView = clickView;
        [bgView addSubview:clickView];
    }
    return self;
}


-(void)leftClick:(UIButton *)aLeft
{
    [self.delegate leftButtonClickEvent:aLeft];
}

-(void)rightClick:(UIButton *)aRight
{
    [self.delegate rightButtonClickEvent:aRight];
}

-(void)bigClick:(UIButton *)aBig
{
    [self.delegate bigButtonClickEvent:aBig];
}
@end
