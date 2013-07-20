//
//  ShareViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-8.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
@interface ShareViewController : UIViewController<UITextViewDelegate,WXApiDelegate>
{
    UITextView     *aTextView;
    UIImageView    *shareImage;
}
@property(nonatomic,retain)UITextView      *aTextView;
@property(nonatomic,retain)UIImageView     *shareImage;
@end
