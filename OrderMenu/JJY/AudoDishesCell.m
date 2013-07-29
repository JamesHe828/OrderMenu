//
//  AudoDishesCell.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-15.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "AudoDishesCell.h"

@implementation AudoDishesCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.dishesButton setBackgroundImage:[UIImage imageNamed:@"25.png"] forState:UIControlStateNormal];
    }
    return self;
}
@end
