//
//  TKHttpRequest.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface TKHttpRequest : NSObject
+(ASIHTTPRequest *)RequestTKUrl:(NSString *)aUrl;
+(ASIDownloadCache *)ShareCache;
+(void)ClearCache;
@end
