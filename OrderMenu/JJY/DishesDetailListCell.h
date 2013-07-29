//
//  DishesDetailListCell.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-10.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishesSelectedButton.h"

@interface DishesDetailListCell : UITableViewCell
@property (nonatomic,strong) UIImageView * backgroundImageView;
@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UILabel * priceLab;
@property (nonatomic,strong) DishesSelectedButton * dishesButton;
@end
