//
//  SearchResultViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-12.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray        *ary;
}
@property(nonatomic,retain)NSArray        *ary;
@end
