//
//  OrderDetailViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-19.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController
@property (nonatomic,strong)NSDictionary * restDic;
@property (nonatomic)int segmentIndex;
@property (nonatomic,strong)NSString * saveOrderId;
@property (nonatomic,strong)NSString * resultID;
@property (nonatomic,strong)NSString * numberStrs;
-(void)refreshAddDishesTableview;
@end
