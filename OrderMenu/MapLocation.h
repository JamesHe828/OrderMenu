//
//  MapLocation.h
//  OrderMenu
//
//  Created by tiankong360 on 13-11-12.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapLocation : NSObject<MKAnnotation>
{
    NSString *streetAddress;
    NSString *city;
    NSString *state;
    NSString *zip;
    NSString *title;
    NSString *subTitle;

    CLLocationCoordinate2D coordinate;
}
-(id) initWithCoordinate:(CLLocationCoordinate2D) coords;  
@property (nonatomic, copy) NSString *streetAddress;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSString *subTitle;
@end
