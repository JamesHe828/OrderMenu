//
//  WebService.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


@interface WebService : NSObject
+(ASIHTTPRequest *)classInterfaceConfig:(int)aResultID;
+(ASIHTTPRequest *)ProductListConfig:(NSString *)aClassId;
+(ASIHTTPRequest *)AudoProductListConfigResultId:(int)aResultID peopleNumber:(int)aPeopleNum;
+(ASIHTTPRequest *)sumbitOrderAllId:(NSString *)aAllId restId:(NSString *)aResultID contactNumber:(NSString *)aContactNum eatTime:(NSString *)aEatTime mark:(NSString *)aMark;
+(ASIHTTPRequest *)GetOrderList:(NSString *)aTellNumber;
+(ASIHTTPRequest *)DeleteOrderId:(int)orderId;
+(ASIHTTPRequest *)GetProductList:(int)orderId;
@end
