//
//  CustomCell.h
//  iArchiscape
//
//  Created by 5dscape on 13-3-28.
//  Copyright (c) 2013年 5dscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
{
    IBOutlet UILabel       *_lab;
    IBOutlet UILabel       *_lab2;
    IBOutlet UILabel       *_timeLab;
    IBOutlet UIImageView   *_imag;
    IBOutlet UIButton      *_abtn;
    IBOutlet UIButton      *_bbtn;
    IBOutlet UILabel       *_renjunLab;
    IBOutlet UILabel       *_dazheLab,*_huodongLab,*_waimaiLab,*_jiamengLab,*_liansuoLab;
    IBOutlet UIImageView   *aimage;
}
@property(nonatomic,retain)IBOutlet UILabel       *lab;
@property(nonatomic,retain)IBOutlet UILabel       *lab2;
@property(nonatomic,retain)IBOutlet UILabel       *timeLab;
@property(nonatomic,retain)IBOutlet UILabel       *renjunLab;
@property(nonatomic,retain)IBOutlet UIImageView   *imag;
@property(nonatomic,retain)IBOutlet UIButton      *abtn;
@property(nonatomic,retain)IBOutlet UIButton      *bbtn;
@property(nonatomic,retain)IBOutlet UILabel       *dazheLab,*huodongLab,*waimaiLab,*jiamengLab,*liansuoLab;
@property(nonatomic,retain)IBOutlet UIImageView   *aimage;
@end
