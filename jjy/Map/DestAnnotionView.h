//
//  DestAnnotionView.h
//  OrderMenu
//
//  Created by tiankong360 on 13-11-20.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DestAnnotionView : NSObject<MKAnnotation>
{
 	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
	NSString *_title;
}
@property (nonatomic,copy) NSString * title;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

@end
