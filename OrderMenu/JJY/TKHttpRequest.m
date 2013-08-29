//
//  TKHttpRequest.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "TKHttpRequest.h"

@interface TKHttpRequest()
@end

@implementation TKHttpRequest
/*
   设置缓存策略，并返回设置好的request
 */
+(ASIHTTPRequest *)RequestTKUrl:(NSString *)aUrl
{
    NSURL *url = [NSURL URLWithString:aUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:5.0];
    //获取全局变量
    ASIDownloadCache * cacheData = [self ShareCache];
    //设置缓存方式
    [request setDownloadCache:cacheData];
    //设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    return request;
}
/*
  下面的方法要在程序启动的适合调用
 */
static ASIDownloadCache * cache;  
+(ASIDownloadCache *)ShareCache
{
    if (cache == nil)
    {
        cache = [[ASIDownloadCache alloc] init];
        //设置缓存路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        [cache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
        [cache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy]; //如果本地有缓存 无论其过期与否，都要拿来使用
    }
    return cache;
}
/*
   清除缓存
 */
+(void)ClearCache
{
    ASIDownloadCache * cacheData = [self ShareCache];
    [cacheData clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy]; //清空缓存。ASICachePermanentlyCacheStoragePolicy代表永久保存的缓存
}
@end
