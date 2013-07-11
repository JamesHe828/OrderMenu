//
//  CustomCell.m
//  iArchiscape
//
//  Created by 5dscape on 13-3-28.
//  Copyright (c) 2013年 5dscape. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize lab=_lab;
@synthesize lab2=_lab2;
@synthesize timeLab=_timeLab;
@synthesize imag=_imag;
@synthesize abtn=_abtn;
@synthesize bbtn=_bbtn;
@synthesize renjunLab=_renjunLab;
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
