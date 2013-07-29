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
-(void)btnClickEvent:(DishesSelectedButton *)aBtn;
@end

@implementation DishesDetailListCell
@synthesize backgroundImageView;
@synthesize leftImageView;
@synthesize titleLab;
@synthesize priceLab;
@synthesize dishesButton;


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
        
        UILabel * price = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 100, 20)];
        price.font = [UIFont systemFontOfSize:15];
        price.textColor = [UIColor redColor];
        price.backgroundColor = [UIColor clearColor];
        self.priceLab = price;
        [bgView addSubview:price];
        
        DishesSelectedButton * btn = [[DishesSelectedButton alloc] initWithFrame:CGRectMake(190, 25, 30, 30)];
        self.dishesButton = btn;
        [btn setBackgroundImage:[UIImage imageNamed:@"8.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 3;
        [bgView addSubview:btn];
    }
    return self;
}
-(void)btnClickEvent:(DishesSelectedButton *)aBtn
{
    if (aBtn.isSelect)
    {
        aBtn.isSelect = NO;
        [aBtn setBackgroundImage:[UIImage imageNamed:@"8.png"] forState:UIControlStateNormal];
    }
    else
    {
        aBtn.isSelect = YES;
        [aBtn setBackgroundImage:[UIImage imageNamed:@"7.png"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
