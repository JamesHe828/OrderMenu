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


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 80)];
        bgView.userInteractionEnabled = YES;
        self.backgroundImageView = bgView;
        [self addSubview:bgView];
        
        UIImageView * leftView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 80, 60)];
        self.leftImageView = leftView;
        [bgView addSubview:leftView];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, 100, 35)];
        title.numberOfLines = 2;
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:16];
        self.titleLab = title;
        [bgView addSubview:title];
        
        UILabel * price = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 70, 20)];
        price.font = [UIFont systemFontOfSize:12];
        price.textColor = [UIColor redColor];
        price.backgroundColor = [UIColor clearColor];
        self.priceLab = price;
        [bgView addSubview:price];
        

        DishClickView * clickView = [[DishClickView alloc] initWithFrame:CGRectMake(140, 0, 90, 40) andNumber:0];
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
        
        UIImageView * leftView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 80, 60)];
        self.leftImageView = leftView;
        [bgView addSubview:leftView];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, 100, 35)];
        title.numberOfLines = 2;
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:16];
        self.titleLab = title;
        [bgView addSubview:title];
        
        UILabel * price = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 60, 20)];
        price.font = [UIFont systemFontOfSize:12];
        price.textColor = [UIColor redColor];
        price.backgroundColor = [UIColor clearColor];
        self.priceLab = price;
        [bgView addSubview:price];
        
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
