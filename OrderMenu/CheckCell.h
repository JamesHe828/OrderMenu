//
//  CheckCell.h
//  OrderMenu
//
//  Created by tiankong360 on 13-8-5.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishClickView.h"

@interface CheckCell : UITableViewCell
@property (nonatomic,strong) UIImageView * bgImageView;
@property (nonatomic,strong) UILabel * labName;
@property (nonatomic,strong) UILabel * labPrice;
@property (nonatomic,strong) DishClickView * ClickView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDotNumber:(int)aDotNumber;
@end
