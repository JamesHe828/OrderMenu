//
//  DrawLineViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-11-20.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DrawLineViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BasicMapAnnotation.h"
#import "DestAnnotionView.h"
#import "JSONKit.h"

@interface DrawLineViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
{
    BasicMapAnnotation * anno;
    DestAnnotionView * annoDes;
    NSArray * locations1;
    
    CLLocation * currLocation;
    UIImageView * routeimageView;
}
@property (nonatomic,strong) IBOutlet UILabel * lab_title;
@property (nonatomic,strong) IBOutlet MKMapView * myMapView;
@property (nonatomic,strong) CLLocationManager * locationManager;

-(IBAction)backClick:(id)sender;
-(NSArray *)getPointsFrom:(CLLocationCoordinate2D)startPoint toEnd:(CLLocationCoordinate2D)destionPoint;
-(void)changeMemdo;
-(void)statWriteLine:(double)latitute1 andLongitute:(double)longitude1;
@end

@implementation DrawLineViewController
@synthesize lab_title,myMapView;
@synthesize locationManager;
@synthesize restName,lat,longit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
   }
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // self.lab_title.text = @"title name";
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager startUpdatingLocation];
    
    self.myMapView.delegate = self;
    [self.myMapView showsUserLocation];

   
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    CLLocation * newLocation = [locations lastObject];
    [self statWriteLine:newLocation.coordinate.latitude andLongitute:newLocation.coordinate.longitude];
}
-(void)statWriteLine:(double)latitute1 andLongitute:(double)longitude1
{
    //113.67290260  34.82373560
    NSLog(@"lat = %g========long=%g",latitute1,longitude1);
    currLocation = [[CLLocation alloc] initWithLatitude:latitute1 longitude:longitude1];
    MKCoordinateRegion region;
    region.center = currLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion adjustedRegion = [self.myMapView regionThatFits:region];
    [self.myMapView setRegion:adjustedRegion animated:YES];
    
    anno = [[BasicMapAnnotation alloc] initWithLatitude:currLocation.coordinate.latitude
                                           andLongitude:currLocation.coordinate.longitude];
    anno.title = @"当前位置";
    [self.myMapView addAnnotation:anno];
    
    annoDes = [[DestAnnotionView alloc] initWithLatitude:self.lat andLongitude:self.longit];
    annoDes.title = self.restName;
    [self.myMapView addAnnotation:annoDes];
    
    
    CLLocationCoordinate2D coordinates[2] = {{currLocation.coordinate.latitude, currLocation.coordinate.longitude}, {self.lat, self.longit}};
    locations1 = [self getPointsFrom:coordinates[0] toEnd:coordinates[1]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self changeMemdo];
}
-(void)changeMemdo
{
     [self drawLineWithLocationArray:locations1];
    [self updateRouteView:locations1];
    [routeimageView setNeedsDisplay];
}
- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = location.coordinate;
    }
    
    MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [self.myMapView setVisibleMapRect:[routeLine boundingMapRect]];
    [self.myMapView addOverlay:routeLine];
    free(coordinateArray);
    coordinateArray = NULL;
}

#pragma mark mapView delegate functions
-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //routeimageView.hidden = NO;
    NSLog(@"%s",__FUNCTION__);
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%s",__FUNCTION__);
    [self updateRouteView:locations1];
    // routeimageView.hidden = NO;
    [routeimageView setNeedsDisplay];
}


-(NSArray *)getPointsFrom:(CLLocationCoordinate2D)startPoint toEnd:(CLLocationCoordinate2D)destionPoint
{
    NSString * start = [NSString stringWithFormat:@"%f,%f",startPoint.latitude,startPoint.longitude];
    NSString * end = [NSString stringWithFormat:@"%f,%f",destionPoint.latitude,destionPoint.longitude];
    NSString * path = [NSString stringWithFormat:@"http://maps.google.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true",start,end];
    ASIHTTPRequest * request1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];
    [request1 startSynchronous];
    NSString * data1 = [request1 responseString];
    NSDictionary * dic = [data1 objectFromJSONString];
    NSArray * dicRouts = [dic valueForKey:@"routes"];
    NSDictionary * legs = [dicRouts objectAtIndex:0];
    NSDictionary * temp = [legs objectForKey:@"overview_polyline"];
    NSMutableString * endpoints = (NSMutableString *)[temp objectForKey:@"points"];
    NSArray * arr = (NSArray *)[self decodePolyLine:endpoints];
    return arr;
}
-(NSMutableArray *)decodePolyLine:(NSMutableString *)encoded
{
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray * array1 = [[NSMutableArray alloc] init];
    NSInteger lat1 = 0;
    NSInteger lng = 0;
    while (index<len)
    {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++]-63;
            result |= (b & 0x1f)<<shift;
            shift += 5;
        } while (b>=0x20);
        NSInteger dlat = ((result & 1)?~(result>>1):(result>>1));
        lat1 += dlat;
        shift = 0;
        result = 0;
        do {
            b=[encoded characterAtIndex:index++]-63;
            result |= (b & 0x1f)<<shift;
            shift += 5;
        } while (b>=0x20);
        NSInteger dlng = ((result & 1)?~(result>>1):(result>>1));
        lng += dlng;
        NSNumber * latitude = [[NSNumber alloc] initWithFloat:lat1*1e-5];
        NSNumber * longitude = [[NSNumber alloc] initWithFloat:lng*1e-5];
        CLLocation * loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array1 addObject:loc];
    }
    NSLog(@"array1 = %@",array1);
    return array1;
}

-(void)updateRouteView:(NSArray *)routs
{
    CGContextRef context = CGBitmapContextCreate(nil, routeimageView.frame.size.width, routeimageView.frame.size.height, 8, 4*routeimageView.frame.size.width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.0);
    CGContextSetLineWidth(context, 6.0);
    for (int i=0; i<routs.count; i++)
    {
        CLLocation * location = [routs objectAtIndex:i];
        CGPoint point = [self.myMapView convertCoordinate:location.coordinate toPointToView:routeimageView];
        if (i==0)
        {
            CGContextMoveToPoint(context, point.x, routeimageView.frame.size.height-point.y);
        }
        else
        {
            CGContextAddLineToPoint(context, point.x, routeimageView.frame.size.height-point.y);
        }
        CGContextStrokePath(context);
        CGImageRef image = CGBitmapContextCreateImage(context);
        UIImage * image1 = [UIImage imageWithCGImage:image];
        
        routeimageView.image = image1;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        MKAnnotationView * annocationView = [self.myMapView dequeueReusableAnnotationViewWithIdentifier:@"callAnno"];
        if (annocationView == nil)
        {
            annocationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"callAnno"];
        }
        annocationView.image = [UIImage imageNamed:@"pin.png"];
        annocationView.canShowCallout = YES;
       // annocationView.selected = YES;
       // [self.myMapView selectAnnotation:annocationView.annotation animated:YES];
        [self performSelector:@selector(showCallOut) withObject:self afterDelay:0.1];
        return annocationView;
    }
    if ([annotation isKindOfClass:[DestAnnotionView class]])
    {
        MKAnnotationView * annocationView1 = [self.myMapView dequeueReusableAnnotationViewWithIdentifier:@"callAnno1"];
        if (annocationView1 == nil)
        {
            annocationView1 = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"callAnno1"];
        }
        annocationView1.image = [UIImage imageNamed:@"pin.png"];
        annocationView1.canShowCallout = YES;
        //annocationView1.selected = YES;
       // [self performSelector:@selector(showCallOut1) withObject:self afterDelay:0.1];
        return annocationView1;
    }
    return nil;
}
-(void)showCallOut
{
    [self.myMapView selectAnnotation:anno animated:YES];
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    NSLog(@"%s",__FUNCTION__);
    MKPolylineView *view = [[MKPolylineView alloc] initWithOverlay:overlay];
    view.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    NSArray *pattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt: 10], nil];
    view.lineDashPattern = pattern;
    view.lineWidth = 3;
    return view;
}

@end
