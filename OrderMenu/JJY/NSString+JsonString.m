//
//  NSString+JsonString.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "NSString+JsonString.h"
#import "JSONKit.h"

@implementation NSString (JsonString)
+(NSArray *)ConverfromData:(NSData *)aData name:(NSString *)aName
{
    NSString * str1 = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    NSString *separerstr=[NSString stringWithFormat:@"%@Result",aName];
    if ([str1 rangeOfString:separerstr].length>0)
    {
        NSArray *arr=[str1 componentsSeparatedByString:separerstr];
        //根据以字符串分割字符串
        NSString *jsonStr=[arr objectAtIndex:1];
        //去除没用的部分 得到json格式的部分
        jsonStr=[jsonStr substringWithRange:NSMakeRange(1, jsonStr.length-3)];
        NSArray * arrResult = [jsonStr objectFromJSONString];
        return arrResult;
    }
    return nil;
}
+(NSString *)ConverStringfromData:(NSData *)aData name:(NSString *)aName
{
    NSString * str1 = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    NSString *separerstr=[NSString stringWithFormat:@"%@Result",aName];
    if ([str1 rangeOfString:separerstr].length>0)
    {
        NSArray *arr=[str1 componentsSeparatedByString:separerstr];
        //根据以字符串分割字符串
        NSString *jsonStr=[arr objectAtIndex:1];
        //去除没用的部分 得到json格式的部分
        jsonStr=[jsonStr substringWithRange:NSMakeRange(1, jsonStr.length-3)];
        return jsonStr;
    }
    return nil;
}
@end
