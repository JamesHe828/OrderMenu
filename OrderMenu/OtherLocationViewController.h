//
//  OtherLocationViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-11-26.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISRTextView.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlySpeechUser.h"
#define APPID       @"52958bfb"
#define USERWORDS   @"{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"科大讯飞\",\"云平台\",\"用户词条1\",\"开始上传词条\"]}]}"

#define PARAMS @"sub=iat,dtt=userword"
#define NAME @"userwords"

#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
@interface OtherLocationViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,IFlyDataUploaderDelegate,IFlySpeechUserDelegate,IFlyRecognizerViewDelegate>
{
    UISearchBar        *aSearchBar;
    NSMutableArray     *ary;
    UITableView        *aTableView;
    UILabel            *alab;
    //语音云
    UIAlertView         *_alertView;
    ISRTextView         *_isrTextView;
    
    UIButton            *_loginButton;
    UIButton            *_uploadButton;
    
    IFlyDataUploader    *_uploader;
    
    IFlyRecognizerView              *_iFlyRecognizerView;
    NSString                        *_grammarID;
    NSString                        *_ent;
}
@end
