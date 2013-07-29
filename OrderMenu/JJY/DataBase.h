//
//  DataBase.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-13.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBase : NSObject
+(FMDatabase *)ShareDataBase;
+(void)clearOrderMenu;
+(void)insertProID:(int)aProID menuid:(int)aMenuId proName:(NSString *)aName price:(double)aPrice image:(NSString *)aImage;
+(void)deleteProID:(int)aProID;
+(NSString *)selectAllProId;
+(NSMutableArray *)selectAllProduct;
+(void)insertTellMenuTellNumber:(NSString *)aTellNumber;
+(NSArray *)selectTellNumber;
@end
