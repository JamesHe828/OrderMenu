//
//  MapLocation.m
//  OrderMenu
//
//  Created by tiankong360 on 13-11-12.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation
@synthesize streetAddress,city,state,zip;
@synthesize coordinate;
@synthesize title,subTitle;
//- (NSString *)title {
//    return @"您的位置!";
//}
//- (NSString *)subtitle {
//    
//    NSMutableString *ret = [NSMutableString string];
//    if (streetAddress)
//        [ret appendString:streetAddress];
//    if (streetAddress && (city || state || zip))
//        [ret appendString:@" • "];
//    if (city)
//        [ret appendString:city];
//    if (city && state)
//        [ret appendString:@", "];
//    if (state)
//        [ret appendString:state];
//    if (zip)
//        [ret appendFormat:@", %@", zip];
//    
//    return ret;
//}
//#pragma mark -
//#pragma mark NSCoding Methods
//- (void) encodeWithCoder: (NSCoder *)encoder {
//    [encoder encodeObject: [self streetAddress] forKey: @"streetAddress"];
//    [encoder encodeObject: [self city] forKey: @"city"];
//    [encoder encodeObject: [self state] forKey: @"state"];
//    [encoder encodeObject: [self zip] forKey: @"zip"];
//}
//- (id) initWithCoder: (NSCoder *)decoder  {
//    if (self = [super init]) {
//        [self setStreetAddress: [decoder decodeObjectForKey: @"streetAddress"]];
//        [self setCity: [decoder decodeObjectForKey: @"city"]];
//        [self setState: [decoder decodeObjectForKey: @"state"]];
//        [self setZip: [decoder decodeObjectForKey: @"zip"]];
//    }
//    return self;
//}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coords
{
    if (self = [super init])
    {
        coordinate = coords;
    }
    return self;
}
@end
