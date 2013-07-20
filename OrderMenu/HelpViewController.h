//
//  HelpViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-8.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UIScrollViewDelegate>
{
    UIPageControl *pageC;
    int    currentHelppage;
    
}
@property(nonatomic,retain)UIPageControl *pageC;
@property (nonatomic, retain) NSArray *helpData ;
@end
