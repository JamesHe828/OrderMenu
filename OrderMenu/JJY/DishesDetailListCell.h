//
//  DishesDetailListCell.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-10.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishesSelectedButton.h"
#import "DishClickView.h"

@protocol DishesDetailListCellDelegate;

@interface DishesDetailListCell : UITableViewCell
@property (nonatomic,strong) UIImageView * backgroundImageView;
@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UILabel * priceLab;
@property (nonatomic,strong) DishesSelectedButton * dishesButton;
@property (nonatomic,strong) DishClickView * dishView;
@property (nonatomic,assign)id<DishesDetailListCellDelegate>delegate;
@property (nonatomic,strong) UILabel * historypriceLab;
@property (nonatomic,assign) double price;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDotNumber:(int)aDotNumber;
@end

@protocol DishesDetailListCellDelegate <NSObject>
@optional
-(void)leftButtonClickEvent:(UIButton *)aButton;
-(void)rightButtonClickEvent:(UIButton *)aButton;
-(void)bigButtonClickEvent:(UIButton *)aButton;

@end