//
//  SearchResultCustomCell.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-12.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "SearchResultCustomCell.h"

@implementation SearchResultCustomCell
@synthesize lab=_lab;
@synthesize lab2=_lab2;
@synthesize timeLab=_timeLab;
@synthesize imag=_imag;
@synthesize abtn=_abtn;
@synthesize bbtn=_bbtn;
@synthesize renjunLab=_renjunLab;
@synthesize dazheLab=_dazheLab;
@synthesize huodongLab=_huodongLab,waimaiLab=_waimaiLab,jiamengLab=_jiamengLab,liansuoLab=_liansuoLab;
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
