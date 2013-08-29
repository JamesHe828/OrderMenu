//
//  JJYGloble.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-10.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#ifndef OrderMenu_JJYGloble_h
#define OrderMenu_JJYGloble_h

//判断是否是iPhone5
#define IPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是PAD
#define IPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad?YES:NO)

#import "MyAlert.h"
#import "MyActivceView.h"
#import "WebService.h"
#import "NSString+JsonString.h"
#import "UIImageView+WebCache.h"

#pragma mark - 接口
#define CLASS_URL @"http://interface.hcgjzs.com/OM_Interface/Cuisines.asmx"
#define CLASS_NAME @"GetList"  //获取某一餐馆的菜系分类列表
#define PRODUCT_URL @"http://interface.hcgjzs.com/OM_Interface/Product.asmx"

#define CHANGE_ONE @"ListForNext"
#define PRODUCT_NAME @"ProductList"  //根据分类id，获取对应id的菜列表
#define ALL_URL @"http://interface.hcgjzs.com"
#define AUDO_PRODUCT_NAME @"ListForSearch"
#define ORDER_URL @"http://interface.hcgjzs.com/OM_Interface/Order.asmx"
#define ORDER_NAME @"Add"
#define ORDER_DELETE @"Del"
#define ORDER_GETPRODUCT @"GetProductList"
#define ORDER_GETORDERLIST @"GetInfo"

#pragma mark - 全局常量
#define ALL_NO_IMAGE @"no.png"

#define APP_KEY @"801390282"
#define APP_SECRET @"a5ceec3dd776e4046b52c4ba4e271354"
#define APP_REQUEST_URL @"http://www.tiankong360.com"

#endif
