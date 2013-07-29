//
//  DishesClassCell.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-10.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DishesClassCell.h"

@implementation DishesClassCell
@synthesize backgroundImageView;
@synthesize textContentLab;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 84, 44)];
        imageview.image = [UIImage imageNamed:@"4.png"];
        self.backgroundImageView = imageview;
        [self addSubview:imageview];
        
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 80, 44)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:15];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.numberOfLines = 2;
        lab.textColor = [UIColor whiteColor];
        self.textContentLab = lab;
        [imageview addSubview:lab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
