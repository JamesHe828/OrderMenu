//
//  FeedbackViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-8.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
@interface FeedbackViewController : UIViewController<UITextViewDelegate>
{
    UIPlaceHolderTextView *aTextView;
    UITextField           *atextField;
    UIView                *backView;
    int                   p;
}
@property(nonatomic,retain)UIPlaceHolderTextView *aTextView;
@property(nonatomic,retain)UITextField           *atextField;
@property(nonatomic,retain)UIView                *backView;
@end
