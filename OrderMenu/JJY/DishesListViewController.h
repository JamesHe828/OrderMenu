//
//  DishesListViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-10.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceView.h"

@interface DishesListViewController : UIViewController<PriceViewDelegate>
@property (nonatomic) int  resultID;
@property (nonatomic,strong)IBOutlet UITableView * classTableView;
@property (nonatomic,strong)IBOutlet UITableView * productTableView;
@end
