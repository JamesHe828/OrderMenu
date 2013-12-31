//
//  OrderListCell.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-19.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "OrderListCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation OrderListCell
@synthesize leftImageView;
@synthesize orderNumberLab;
@synthesize orderTimeLab;
@synthesize resultAdressLab;
@synthesize resultNameLab;
@synthesize deleteBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * imgeview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 60, 60)];
        imgeview.layer.borderWidth = 1;
        imgeview.layer.borderColor = [UIColor grayColor].CGColor;
        imgeview.layer.cornerRadius = 8;
        self.leftImageView = imgeview;
        [self addSubview:imgeview];
        
        UILabel * nameLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 6, 180, 20)];
        nameLab.font = [UIFont systemFontOfSize:14];
        self.resultNameLab = nameLab;
        nameLab.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLab];
        
        UILabel * orderLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 26, 90, 15)];
        orderLab.textColor = [UIColor blueColor];
        orderLab.font = [UIFont systemFontOfSize:8];
        orderLab.backgroundColor = [UIColor clearColor];
        self.orderNumberLab = orderLab;
        [self addSubview:orderLab];
        
        UIImageView * timeIV = [[UIImageView alloc] initWithFrame:CGRectMake(155, 29, 8, 8)];
        self.timeImageView = timeIV;
        timeIV.image = [UIImage imageNamed:@"时间图标.png"];
        [self addSubview:timeIV];
        
        UILabel * timelab = [[UILabel alloc] initWithFrame:CGRectMake(163, 26, 92, 15)];
        timelab.textColor = [UIColor grayColor];
        timelab.backgroundColor = [UIColor clearColor];
        timelab.font = [UIFont systemFontOfSize:8];
        self.orderTimeLab = timelab;
        [self addSubview:timelab];
        
        UIImageView * imageAdress = [[UIImageView alloc] initWithFrame:CGRectMake(70, 48, 14, 14)];
        imageAdress.image = [UIImage imageNamed:@"位置.png"];
        [self addSubview:imageAdress];
        
        UILabel * adressLab = [[UILabel alloc] initWithFrame:CGRectMake(82, 41, 240, 30)];
        adressLab.numberOfLines = 2;
        self.resultAdressLab = adressLab;
        adressLab.textColor = [UIColor grayColor];
        adressLab.font = [UIFont systemFontOfSize:12];
        adressLab.backgroundColor = [UIColor clearColor];
        [self addSubview:adressLab];
        
//        DishesSelectedButton * btn = [[DishesSelectedButton alloc] initWithFrame:CGRectMake(270, 25, 30, 30)];
//        self.deleteBtn = btn;
//      //  [btn setBackgroundImage:[UIImage imageNamed:@"detele.png"] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:10];
//        btn.titleLabel.textColor = [UIColor whiteColor];
//        [self addSubview:btn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
