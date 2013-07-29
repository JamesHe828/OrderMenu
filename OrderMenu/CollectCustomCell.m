//
//  CollectCustomCell.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-16.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "CollectCustomCell.h"

@implementation CollectCustomCell
@synthesize lab=_lab;
@synthesize lab2=_lab2;
@synthesize timeLab=_timeLab;
@synthesize imag=_imag;
@synthesize abtn=_abtn;
@synthesize bbtn=_bbtn;
@synthesize renjunLab=_renjunLab;
@synthesize deletaBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
