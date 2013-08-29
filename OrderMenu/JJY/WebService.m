//
//  WebService.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "WebService.h"
#import "TKHttpRequest.h"

@implementation WebService
#pragma mark - 获取菜系分类
+(ASIHTTPRequest *)classInterfaceConfig:(int)aResultID
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:CLASS_URL];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <GetList xmlns=\"http://tempuri.org/\">\
                       <id>%d</id>\
                       </GetList>\
                       </soap:Body>\
                       </soap:Envelope>",aResultID];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetList"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    return request;
}
#pragma mark - 获取分类下面对应的菜列表
+(ASIHTTPRequest *)ProductListConfig:(NSString *)aClassId
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:PRODUCT_URL];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <ProductList xmlns=\"http://tempuri.org/\">\
                       <id>%d</id>\
                       </ProductList>\
                       </soap:Body>\
                       </soap:Envelope>",[aClassId intValue]];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/ProductList"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    return request;
}
#pragma mark - 根据人数随机推荐菜
+(ASIHTTPRequest *)AudoProductListConfigResultId:(int)aResultID peopleNumber:(int)aPeopleNum
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:PRODUCT_URL];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <ListForSearch xmlns=\"http://tempuri.org/\">\
                       <restid>%d</restid>\
                       <peopleNum>%d</peopleNum>\
                       </ListForSearch>\
                       </soap:Body>\
                       </soap:Envelope>",aResultID,aPeopleNum];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/ListForSearch"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    return request;
}
+(ASIHTTPRequest *)AudoProductListConfigResultId:(int)aResultID peopleNumber:(int)aPeopleNum andMenuId:(int)aMenuId
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:PRODUCT_URL];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <ListForNext xmlns=\"http://tempuri.org/\">\
                       <restid>%d</restid>\
                       <peopleNum>%d</peopleNum>\
                       <menutid>%d</menutid>\
                       </ListForNext>\
                       </soap:Body>\
                       </soap:Envelope>",aResultID,aPeopleNum,aMenuId];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/ListForNext"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    return request;
}
#pragma mark - 提交订单
+(ASIHTTPRequest *)sumbitOrderAllId:(NSString *)aAllId restId:(NSString *)aResultID contactNumber:(NSString *)aContactNum eatTime:(NSString *)aEatTime mark:(NSString *)aMark andNumberS:(NSString *)aNumbers
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:ORDER_URL];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <Add xmlns=\"http://tempuri.org/\">\
                       <proid>%@</proid>\
                       <restid>%d</restid>\
                       <contactNum>%@</contactNum>\
                       <eatTime>%@</eatTime>\
                       <mark>%@</mark>\
                       <copies>%@</copies>\
                       </Add>\
                       </soap:Body>\
                       </soap:Envelope>",aAllId,[aResultID intValue],aContactNum,aEatTime,aMark,aNumbers];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/Add"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    return request;
}
#pragma mark - 获取我的订单列表
+(ASIHTTPRequest *)GetOrderList:(NSString *)aTellNumber
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:ORDER_URL];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <GetInfo xmlns=\"http://tempuri.org/\">\
                       <tel>%@</tel>\
                       </GetInfo>\
                       </soap:Body>\
                       </soap:Envelope>",aTellNumber];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetInfo"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    return request;
}
+(ASIHTTPRequest *)DeleteOrderId:(int)orderId
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:ORDER_URL];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <Del xmlns=\"http://tempuri.org/\">\
                       <id>%d</id>\
                       </Del>\
                       </soap:Body>\
                       </soap:Envelope>",orderId];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/Del"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    return request;
}
+(ASIHTTPRequest *)GetProductList:(int)orderId
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:ORDER_URL];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <GetProductList xmlns=\"http://tempuri.org/\">\
                       <id>%d</id>\
                       </GetProductList>\
                       </soap:Body>\
                       </soap:Envelope>",orderId];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetProductList"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    return request;
}
+(ASIHTTPRequest *)AddDisesToOrderId:(int)aOrderId idList:(NSString *)aIdList copies:(NSString *)aCopies
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:ORDER_URL];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <AddToOrderInfo xmlns=\"http://tempuri.org/\">\
                       <orderid>%d</orderid>\
                       <idlist>%@</idlist>\
                       <copies>%@</copies>\
                       </AddToOrderInfo>\
                       </soap:Body>\
                       </soap:Envelope>",aOrderId,aIdList,aCopies];
    [request addRequestHeader:@"Host" value:@"interface.hcgjzs.com"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/AddToOrderInfo"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    return request;
}
@end
