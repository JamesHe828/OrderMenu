//
//  OrderListCell.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-19.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishesSelectedButton.h"

@interface OrderListCell : UITableViewCell
@property (nonatomic,strong)UIImageView * leftImageView;
@property (nonatomic,strong)UILabel * orderNumberLab;
@property (nonatomic,strong)UILabel * orderTimeLab;
@property (nonatomic,strong)UILabel * resultAdressLab;
@property (nonatomic,strong)UILabel * resultNameLab;
@property (nonatomic,strong)DishesSelectedButton * deleteBtn;
@end
