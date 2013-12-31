//
//  MapViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-11-12.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize locationManager;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    aImageView.image=[UIImage imageNamed:@"11"];
    [self.view addSubview:aImageView];
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
    lab.backgroundColor=[UIColor clearColor];
    lab.text=@"地图";
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:16.0];
    lab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab];
    UIButton *aBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.showsTouchWhenHighlighted=YES;
    aBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.view addSubview:aBtn];
    [aBtn addTarget:self action:@selector(back_Click) forControlEvents:UIControlEventTouchUpInside];
    //定位
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    [self.locationManager startUpdatingLocation];
    //地图
    mapView=[[MKMapView alloc] init];
    mapView.mapType =MKMapTypeStandard;
    mapView.showsUserLocation=YES;
    mapView.delegate=self;
    mapView.userLocation.title=@"您的位置";
    mapView.frame=CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-44);
    [self.view addSubview:mapView];
    routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
    routeView.userInteractionEnabled = NO;
    [mapView addSubview:routeView];
}
#pragma mark dingwei
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *str1= [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *str2 = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    NSLog(@"str1== %@,str2==%@",str1,str2);
   // MKCoordinateRegion
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
    //[mapView setRegion:viewRegion animated:YES];
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    [locationManager stopUpdatingLocation];
    manager.delegate = nil;
//   //添加大头针
//    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(39.915352,116.397105);
//    float zoomLevel = 0.02;
//    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
//    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
//    [self createAnnotationWithCoords:coords];
    // 画行进路线
//    CLLocation *location0 = [[CLLocation alloc] initWithLatitude:39.915352 longitude:116.397105];
//    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
//    NSArray *array = [NSArray arrayWithObjects:location0, location1, nil];
//    [self drawLineWithLocationArray:array];
}
- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [mapView setVisibleMapRect:[routeLine boundingMapRect]];
    [mapView addOverlay:routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

-(void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords
{
    MapLocation *annotation = [[MapLocation alloc] initWithCoordinate:coords];
    annotation.title = @"标题";
    annotation.subTitle = @"子标题";
    [mapView addAnnotation:annotation];
    
   
}
-(void)back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
