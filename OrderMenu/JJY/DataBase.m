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
    
    NSString * createTB = @"create table orderMenu(proID int primary key,Menuid int,proName nvarchar(50),price double,proImage varchar(50))";
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
+(void)insertProID:(int)aProID menuid:(int)aMenuId proName:(NSString *)aName price:(double)aPrice image:(NSString *)aImage
{
    FMDatabase * db = [DataBase ShareDataBase];
    [db open];
    NSString * sql = [NSString stringWithFormat:@"insert into orderMenu(proID,Menuid,proName,price,proImage) values('%d','%d','%@','%g','%@')",aProID,aMenuId,aName,aPrice,aImage];
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
        [dic setValue:proid forKey:@"ProID"];
        [dic setValue:Menuid forKey:@"Menuid"];
        [dic setValue:proName forKey:@"ProName"];
        [dic setValue:price forKey:@"prices"];
        [dic setValue:proImage forKey:@"ProductImg"];
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
@end
