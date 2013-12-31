//
//  ShareViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-8.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareContentViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
@protocol sendMsgToWeChatViewDelegate <NSObject>
- (void) sendAppExtendContent;
- (void) changeScene:(NSInteger)scene;
@end
@interface ShareViewController : UIViewController<UITextViewDelegate,UIWebViewDelegate,WXApiDelegate,sendMsgToWeChatViewDelegate>
{
    UITextView     *aTextView;
    UIImageView    *shareImage;
    UIView *authorizationView;
    int            p;
    UIView         *background;
    UIView         *backGroundView;
    ShareContentViewController *shareVC;
    enum WXScene _scene;
}
@property(nonatomic,retain)UITextView      *aTextView;
@property(nonatomic,retain)UIImageView     *shareImage;
@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate> delegate;
@end
