//
//  NSString+JsonString.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

NSUInteger DeviceSystemMajorVersion();
NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

#import "NSString+JsonString.h"
#import "JSONKit.h"
#import "JSON.h"

@implementation NSString (JsonString)

+(BOOL)IOS_7
{
    NSInteger currVersion = DeviceSystemMajorVersion();
    if (currVersion>=7)
    {
        return YES;
    }
    return NO;
}

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
        NSString * str1 = @"\\";
        NSString * str2 = @"\\\\";
        NSString * resultStr = [jsonStr stringByReplacingOccurrencesOfString:str1 withString:str2];
        NSString * resultStr1 = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString * resultStr2 = [resultStr1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSArray * arrResult = [resultStr2 objectFromJSONString];
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
+(NSDictionary *)getLatAndLongitToAdress:(NSString *)aAdress
{
    NSString * adressPath = [NSString stringWithFormat:@"中国河南郑州%@",aAdress];
    NSString * path1 = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",adressPath];
    NSString * resultPath =  [path1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest * requestAdress = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:resultPath]];
    [requestAdress startSynchronous];
    NSData * data1 = [requestAdress responseData];
    NSDictionary * arrResult = [data1 objectFromJSONData];
    NSArray * arr = [[[arrResult valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"];
    if (arr.count>0)
    {
        NSDictionary * dic = [arr objectAtIndex:0];
        return dic;
    }
    return Nil;
}
@end
