//
//  DetailViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-4.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
     UITableView   *aTableView;
     UILabel       *numLab;
}

@property(nonatomic,retain)UITableView   *aTableView;
@property(nonatomic,retain)UILabel       *numLab;
@end
