//
//  MapViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-11-12.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapLocation.h"
@interface MapViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    MKMapView         *mapView;
    MKPolyline        *routeLine;
    MKPolylineView    *routeLineView;
    UIImageView       *routeView;
}
@property(nonatomic,retain)CLLocationManager  *locationManager;
@end
