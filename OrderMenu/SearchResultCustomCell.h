//
//  SearchResultCustomCell.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-12.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCustomCell : UITableViewCell
{
        IBOutlet UILabel       *_lab;
        IBOutlet UILabel       *_lab2;
        IBOutlet UILabel       *_timeLab;
        IBOutlet UIImageView   *_imag;
        IBOutlet UIButton      *_abtn;
        IBOutlet UIButton      *_bbtn;
        IBOutlet UILabel       *_renjunLab;
        IBOutlet UILabel       *_dazheLab,*_huodongLab,*_waimaiLab,*_jiamengLab,*_liansuoLab;
}
@property(nonatomic,retain)IBOutlet UILabel       *lab;
@property(nonatomic,retain)IBOutlet UILabel       *lab2;
@property(nonatomic,retain)IBOutlet UILabel       *timeLab;
@property(nonatomic,retain)IBOutlet UILabel       *renjunLab;
@property(nonatomic,retain)IBOutlet UIImageView   *imag;
@property(nonatomic,retain)IBOutlet UIButton      *abtn;
@property(nonatomic,retain)IBOutlet UIButton      *bbtn;
@property(nonatomic,retain)IBOutlet UILabel       *dazheLab,*huodongLab,*waimaiLab,*jiamengLab,*liansuoLab;
@end
