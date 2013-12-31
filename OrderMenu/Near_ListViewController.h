//
//  Near_ListViewController.h
//  OrderMenu
//
//  Created by tiankong360 on 13-11-23.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface Near_ListViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate>
{
    NSMutableArray *ary;
    UITableView    *aTableView;
    MKMapView      *mapView;
    CLLocationManager *locationManager;
}
@property(nonatomic,retain)NSMutableArray *ary;
@end
