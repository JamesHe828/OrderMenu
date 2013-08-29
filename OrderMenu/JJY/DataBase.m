//
//  DataBase.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-13.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DataBase.h"

@interface DataBase()
+(BOOL)isExistTableDianCai;
+(BOOL)isExistProID:(int)aProId;
+(BOOL)isExistTellNumber:(NSString *)aTellNumber;
@end

@implementation DataBase
+(FMDatabase *)ShareDataBase
{
    NSString * doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * dbPath = [doucumentPath stringByAppendingPathComponent:@"diancai.db"];
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    NSString * createTB = @"create table orderMenu(proID int,Menuid int,proName nvarchar(50),price double,proImage varchar(50),number int)";
    BOOL result = [db executeUpdate:createTB];
    if (result)
    {
        NSLog(@"创建表orderMenu成功");
    }
    
    NSString * createTBIphone = @"create table tellMenu(tellNumber varchar(50) primary key)";
    BOOL result1 = [db executeUpdate:createTBIphone];
    if (result1)
    {
        NSLog(@"创建表tellMenu成功");
    }
    
    NSString * createNoSaveTB = @"create table orderNoSaveMenu(orderId int PRIMARY KEY,resultId int,resultName nvarchar(50),proImage varchar(50),orderTime varchar(50),adress nvarchar(100),tellNumber varchar(50))";
    BOOL result3 = [db executeUpdate:createNoSaveTB];
    if (result3)
    {
        NSLog(@"创建表orderNoSaveMenu成功");
    }

    
    NSString * createSaveTB = @"create table SaveOrderMenu(proID int,proName nvarchar(50),price double,proImage varchar(50),number int,orderId int)";
    BOOL result2 = [db executeUpdate:createSaveTB];
    if (result2)
    {
        NSLog(@"创建表SaveOrderMenu成功");
    }
    

    [db close];
    return db;
}
#pragma mark - 判断随机点菜的菜单是否存在
+(BOOL)isExistTableDianCai
{
    FMDatabase * db = [DataBase ShareDataBase];
    NSString * sql = @"SELECT COUNT(*) as count FROM diancai.db WHERE type='table' and name= 'orderMenu'";
    FMResultSet * rs = [db executeQuery:sql];
    int result = 0;
    while ([rs next])
    {
        result = [rs intForColumn:@"count"];
    }
    if (result == 0)
    {
        return NO;
    }
    return YES;
}
#pragma mark - 清楚orderMenu
+(void)clearOrderMenu
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * deleteSql = @"delete from orderMenu where 1=1";
    BOOL result = [db executeUpdate:deleteSql];
    if (result)
    {
        NSLog(@"清除orderMenu成功");
    }
    else
    {
        NSLog(@"清除orderMenu失败");
    }
    [db close];
}
#pragma mark - 向orderMenu中插入数据
+(void)insertProID:(int)aProID menuid:(int)aMenuId proName:(NSString *)aName price:(double)aPrice image:(NSString *)aImage andNumber:(int)aNumber
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"insert into orderMenu(proID,Menuid,proName,price,proImage,number) values('%d','%d','%@','%g','%@','%d')",aProID,aMenuId,aName,aPrice,aImage,aNumber];
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
        NSLog(@"插入成功");
    }
    else
    {
        NSLog(@"插入失败");
    }
    [db close];
}
#pragma mark - 更改当前点菜的份数
+(void)UpdateDotNumber:(int)aProid currDotNumber:(int)aDotNumber
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"update orderMenu set number='%d' where proID = '%d'",aDotNumber,aProid];
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
        NSLog(@"更改成功");
    }
    else
    {
        NSLog(@"更改失败");
    }
    [db close];
}

#pragma mark - 删除指定id的菜
+(void)deleteProID:(int)aProID
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"delete from orderMenu where proID='%d'",aProID];
    NSLog(@"sql = %@",sql);
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
        NSLog(@"删除成功");
    }
    else
    {
        NSLog(@"删除失败");
    }
    [db close];
}
#pragma mark - 根据id选出所点的数量
+(NSMutableArray *)selectNumberFromProId:(int)aProid
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"select number,price from orderMenu where proID='%d'",aProid];
    FMResultSet * rs = [db executeQuery:sql];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    while([rs next])
    {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString * number = [rs stringForColumn:@"number"];
        NSString * price = [rs stringForColumn:@"price"];
        [dic setValue:number forKey:@"number"];
        [dic setValue:price forKey:@"price"];
        [arr addObject:dic];
    }
    [rs close];
    [db close];
    return arr;
}
#pragma mark - 选择出所有商品的id，并将拼接成字符串
+(NSString *)selectAllProId
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = @"select proID from orderMenu";
    FMResultSet * rs = [db executeQuery:sql];
    NSMutableString * mutableStr = [[NSMutableString alloc] initWithFormat:@""];
    while([rs next])
    {
        NSString * proID= [rs stringForColumn:@"proID"];
        [mutableStr appendFormat:@"%@,",proID];
    }
    NSString * str;
    if(mutableStr.length>0)
    {
      str = [mutableStr substringWithRange:NSMakeRange(0, mutableStr.length-1)];
    }
    [db close];
    return str;
}
#pragma mark - 选择出所有商品的id，并将拼接成字符串
+(NSMutableArray *)selectAllArrayProId
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = @"select proID from orderMenu";
    FMResultSet * rs = [db executeQuery:sql];
    NSMutableArray * mutableArr = [NSMutableArray arrayWithCapacity:0];
    while([rs next])
    {
        NSString * proID= [rs stringForColumn:@"proID"];
        [mutableArr addObject:proID];
    }
    [db close];
    return mutableArr;
}

+(NSMutableArray *)selectAllProduct
{
    NSMutableArray * mutableArr = [NSMutableArray arrayWithCapacity:0];
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    FMResultSet * rs = [db executeQueryWithFormat:@"select * from orderMenu"];
    while([rs next])
    {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        NSString * proid = [rs stringForColumn:@"proID"];
        NSString * Menuid = [rs stringForColumn:@"Menuid"];
        NSString * proName = [rs stringForColumn:@"proName"];
        NSString * price = [rs stringForColumn:@"price"];
        NSString * proImage = [rs stringForColumn:@"proImage"];
        NSString * number = [rs stringForColumn:@"number"];
        [dic setValue:proid forKey:@"ProID"];
        [dic setValue:Menuid forKey:@"Menuid"];
        [dic setValue:proName forKey:@"ProName"];
        [dic setValue:price forKey:@"prices"];
        [dic setValue:proImage forKey:@"ProductImg"];
        [dic setValue:number forKey:@"number"];
        [mutableArr addObject:dic];
    }
    [rs close];
    [db close];
    return mutableArr;
}


+(BOOL)isExistProID:(int)aProId
{
    NSString * sql = [NSString stringWithFormat:@"select count(*) as sum from orderMenu where proID = '%d'",aProId];
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    FMResultSet * rs = [db executeQuery:sql];
    int result = 0;
    if ([rs next])
    {
        result = [rs intForColumn:@"sum"];
    }
    if (result>0)
    {
        return YES;
    }
    [db close];
   return NO;
}
#pragma mark - 插入TellMenu
+(void)insertTellMenuTellNumber:(NSString *)aTellNumber
{
    if (![self isExistTellNumber:aTellNumber])
    {
        NSString * insertSql = [NSString stringWithFormat:@"insert into tellMenu(tellNumber) values('%@')",aTellNumber];
        FMDatabase * db = [DataBase ShareDataBase];
        [db open];
        if ([db executeUpdate:insertSql])
        {
            NSLog(@"插入成功");
        }
        [db close];
    }
}
+(BOOL)isExistTellNumber:(NSString *)aTellNumber
{
    NSString * sql = [NSString stringWithFormat:@"select count(*) as countNum from tellMenu where tellNumber='%@'",aTellNumber];
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    FMResultSet * rs = [db executeQuery:sql];
    int result = 0;
    while ([rs next])
    {
        result = [rs intForColumn:@"countNum"];
    }
    [rs close];
    [db close];
    if (result > 0)
    {
        return YES;
    }
    return NO;
}
#pragma mark - 返回所有的联系方式（供查询订单使用）
+(NSArray *)selectTellNumber
{
    NSString * sql = @"select tellNumber from tellMenu";
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    FMResultSet * rs = [db executeQuery:sql];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    while ([rs next])
    {
        NSString * str = [rs stringForColumn:@"tellNumber"];
        [arr addObject:str];
    }
    [rs close];
    [db close];
    return (NSArray *)arr;
}
#pragma mark - 保存菜单
+(BOOL)insertSaveProID:(int)aProID orderId:(int)orderId proName:(NSString *)aName price:(double)aPrice image:(NSString *)aImage andNumber:(int)aNumber
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"insert into SaveOrderMenu(proID,orderId,proName,price,proImage,number) values('%d','%d','%@','%g','%@','%d')",aProID,orderId,aName,aPrice,aImage,aNumber];
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    [db close];
}

#pragma mark - 删除 保存的菜单
+(BOOL)deleteSaveProID:(int)aProID
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"delete from SaveOrderMenu where proID='%d'",aProID];
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    [db close];
}
#pragma mark - 删除 保存的菜单
+(BOOL)deleteSaveProID:(int)aProID andOrderId:(int)aOrderId
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"delete from SaveOrderMenu where proID='%d' and orderId='%d'",aProID,aOrderId];
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    [db close];
}
+(BOOL)deleteSaveOederFromOrderId:(int)aOrderId
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"delete from SaveOrderMenu where orderId='%d'",aOrderId];
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    [db close];
}

#pragma mark - 选出未提交商品列表 proID int primary key,proName nvarchar(50),price double,proImage varchar(50),number int,orderId int
+(NSMutableArray *)selecetAllNoSaveProduct:(NSString *)aOrderId
{
    NSString * sql = [NSString stringWithFormat:@"select * from SaveOrderMenu where orderId = '%@'",aOrderId];
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    FMResultSet * rs = [db executeQuery:sql];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    while ([rs next])
    {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString * proID = [rs stringForColumn:@"proID"];
        NSString * proName = [rs stringForColumn:@"proName"];
        NSString * price = [rs stringForColumn:@"price"];
        NSString * proImage = [rs stringForColumn:@"proImage"];
        NSString * number = [rs stringForColumn:@"number"];
        [dic setValue:proID forKey:@"proID"];
        [dic setValue:proName forKey:@"proName"];
        [dic setValue:price forKey:@"price"];
        [dic setValue:proImage forKey:@"proImage"];
        [dic setValue:number forKey:@"number"];
        [arr addObject:dic];
    }
    [rs close];
    [db close];
    return arr;
}
#pragma mark - 选出某一订单下，保存在本地的所点菜
+(NSMutableArray *)SelectAllSaveProId:(int)aOrderId
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
     NSString * sql = [NSString stringWithFormat:@"select proID from SaveOrderMenu where orderId='%d'",aOrderId];
    FMResultSet * rs = [db executeQuery:sql];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    while([rs next])
    {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
         NSString * proid = [rs stringForColumn:@"proID"];
        [dic setValue:proid forKey:@"proID"];
        [arr addObject:dic];
    }
    [rs close];
    [db close];
    return arr;
}
#pragma mark - 根据proid选出保存在本地的price和number
+(NSDictionary *)SelectNumberAndPriceByProID:(int)aProId
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"select number,price from SaveOrderMenu where proID='%d'",aProId];
    FMResultSet * rs = [db executeQuery:sql];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    while([rs next])
    {
        NSString * number = [rs stringForColumn:@"number"];
        NSString * price = [rs stringForColumn:@"price"];
        [dic setValue:number forKey:@"number"];
        [dic setValue:price forKey:@"price"];
    }
    [rs close];
    [db close];
    return dic;
}
+(NSDictionary *)SelectNumberAndPriceByProID:(int)aProId andOrderId:(int)aOrderId
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"select number,price from SaveOrderMenu where proID='%d' and orderId='%d'",aProId,aOrderId];
    NSLog(@"sql = %@",sql);
    FMResultSet * rs = [db executeQuery:sql];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    while([rs next])
    {
        NSString * number = [rs stringForColumn:@"number"];
        NSString * price = [rs stringForColumn:@"price"];
        [dic setValue:number forKey:@"number"];
        [dic setValue:price forKey:@"price"];
    }
    [rs close];
    [db close];
    return dic;
}
#pragma mark - 更改当前保存的数据
+(void)UpdateDotNumber:(int)aNumber andPriId:(int)aProId
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"update SaveOrderMenu set number='%d' where proID = '%d'",aNumber,aProId];
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
        NSLog(@"更改成功");
    }
    else
    {
        NSLog(@"更改失败");
    }
    [db close];
}
#pragma mark - 更改当前保存的数据
+(void)UpdateDotNumber:(int)aNumber andPriId:(int)aProId andOrderId:(int)aOrderId
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"update SaveOrderMenu set number='%d' where proID = '%d' and orderId = '%d'",aNumber,aProId,aOrderId];
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
        NSLog(@"更改成功");
    }
    else
    {
        NSLog(@"更改失败");
    }
    [db close];
}
#pragma mark - 选出保存菜的菜的所有id


#pragma mark - 保存点菜的餐馆信息
+(NSString *)insertResultResultId:(int)aResultId resultName:(NSString *)aResultName proImage:(NSString *)aProImage orderTime:(NSString *)aOrderTime adress:(NSString *)aAdress tellNumber:(NSString *)aTellNumber
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    
    NSString * sql1 = @"select max(orderId) as resValue from orderNoSaveMenu";
    FMResultSet * rs = [db executeQuery:sql1];
    NSString * result1;
    while ([rs next])
    {
        result1 = [rs stringForColumn:@"resValue"];
    }
    NSString * str = [NSString stringWithFormat:@"%@",result1];
    if ([str isEqualToString:@"(null)"])
    {
        result1 = @"1";
    }
    else
    {
        result1 = [NSString stringWithFormat:@"%d",[result1 intValue]+1];
    }
    
    NSString * sql = [NSString stringWithFormat:@"insert into orderNoSaveMenu(resultId,resultName,proImage,orderTime,adress,orderId,tellNumber) values('%d','%@','%@','%@','%@','%d','%@')",aResultId,aResultName,aProImage,aOrderTime,aAdress,[result1 intValue],aTellNumber];
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
       //如果插入成功，让其返回订单id
        NSString * sql1 = @"select max(orderId) as resValue from orderNoSaveMenu";
        FMResultSet * rs = [db executeQuery:sql1];
        NSString * result;
        while ([rs next])
        {
            result = [rs stringForColumn:@"resValue"];
        }
        return result;
    }
    else
    {
        return @"null";
    }
    [db close];
}
#pragma mark - 选出所有的未提交的餐馆
+(NSMutableArray *)selectAllNoSaveResult
{
    NSString * sql = @"select * from orderNoSaveMenu";
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    FMResultSet * rs = [db executeQuery:sql];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    while ([rs next])
    {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString * orderId = [rs stringForColumn:@"orderId"];
        NSString * resultId = [rs stringForColumn:@"resultId"];
        NSString * resultName = [rs stringForColumn:@"resultName"];
        NSString * proImage = [rs stringForColumn:@"proImage"];
        NSString * orderTime = [rs stringForColumn:@"orderTime"];
        NSString * adress = [rs stringForColumn:@"adress"];
        NSString * tellNumber = [rs stringForColumn:@"tellNumber"];
        [dic setValue:orderId forKey:@"orderId"];
        [dic setValue:resultId forKey:@"resultId"];
        [dic setValue:resultName forKey:@"resultName"];
        [dic setValue:proImage forKey:@"proImage"];
        [dic setValue:orderTime forKey:@"orderTime"];
        [dic setValue:adress forKey:@"adress"];
        [dic setValue:tellNumber forKey:@"tellNumber"];
        [arr addObject:dic];
    }
    [rs close];
    [db close];
    return arr;
}
#pragma mark - 删除保存的订单
+(BOOL)deleteResultSave:(NSString *)aOrderId
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"delete from orderNoSaveMenu where orderId='%@'",aOrderId];
    BOOL isSuccess = [db executeUpdate:sql];
    if (isSuccess)
    {
        //删除此orderid下对应的菜
        NSString * sql1 = [NSString stringWithFormat:@"delete from SaveOrderMenu where orderId='%@'",aOrderId];
        BOOL isSuccess = [db executeUpdate:sql1];
        if (isSuccess)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
    [db close];
}
@end
