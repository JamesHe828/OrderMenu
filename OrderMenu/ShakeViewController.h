//
//  ShakeViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-29.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
@interface ShakeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>
{
    UITableView   *aTableView;
    NSMutableArray *ary;
    int           p;
    AVAudioPlayer *player;
    UIImageView   *upImage;
    UIImageView   *downImage;
    SystemSoundID soundID;
    UIView        *aView;

}
@property(nonatomic,retain)UITableView   *aTableView;
@property(nonatomic,retain)NSMutableArray       *ary;
@end
