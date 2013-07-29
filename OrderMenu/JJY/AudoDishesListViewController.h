//
//  AudoDishesListViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-15.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DishesListViewController.h"

@class AudoResultViewController;

@interface AudoDishesListViewController : UIViewController
@property (nonatomic)int resultID;
@property (nonatomic,strong)IBOutlet UITableView * classTableView;
@property (nonatomic,strong)IBOutlet UITableView * productTableView;
@property (nonatomic,strong) AudoResultViewController * myViewController;
@end
