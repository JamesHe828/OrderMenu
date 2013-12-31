//
//  DestAnnotionView.m
//  OrderMenu
//
//  Created by tiankong360 on 13-11-20.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DestAnnotionView.h"

@implementation DestAnnotionView
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude {
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
	}
	return self;
}
- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}
@end
