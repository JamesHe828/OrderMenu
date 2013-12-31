//
//  DispalayMapViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-11-18.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DispalayMapViewController.h"
#import "MapViewController.h"
#import "TKHttpRequest.h"
#import "DetailViewController.h"
#import "Near_ListViewController.h"
#import "OtherLocationViewController.h"

@interface DispalayMapViewController ()<MapViewControllerDidSelectDelegate,CLLocationManagerDelegate>
{
 MapViewController *_mapViewController;
    CLLocationManager * locationManager;
}
-(IBAction)backClick:(id)sender;
-(void)addAnnotationView;
@end

@implementation DispalayMapViewController
@synthesize isOtherLocation;
@synthesize dataArr;
@synthesize listAry;
-(IBAction)backClick:(id)sender
{
    Near_ListViewController *nearVC=[[Near_ListViewController alloc] init];
    nearVC.ary=listAry;
    nearVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nearVC animated:YES];
}
-(IBAction)otherLocation:(id)sender
{
    OtherLocationViewController *otherVC=[[OtherLocationViewController alloc] init];
    otherVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:otherVC animated:YES];
}
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
    self.navigationController.navigationBar.hidden=YES;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [MyAlert ShowAlertMessage:@"没有开启定位。" title:@"提示"];
    }
    if (isOtherLocation)
    {
        [self addAnnotationView];
    }
    else
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 1000.0f;
        [locationManager startUpdatingLocation];
    }
}
-(void)addAnnotationView
{
    if (IPhone5)
    {
        _mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    }
    else
    {
        _mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController4" bundle:nil];
    }
    UIButton *bbbttn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    bbbttn.frame=CGRectMake(200, 300, 50, 50);
    [bbbttn setTitle:@"123" forState:UIControlStateNormal];
    [_mapViewController.view  bringSubviewToFront:bbbttn];
    [_mapViewController.view addSubview:bbbttn];
    _mapViewController.delegate = self;
    [self.view addSubview:_mapViewController.view];
    [_mapViewController.view setFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44.0)];
    [_mapViewController resetAnnitations:self.dataArr];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * newLocation = [locations lastObject];
    NSString *str1= [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *str2 = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    NSLog(@"str1== %@---------------------str2==%@",str1,str2);
    [manager stopUpdatingLocation];
    [self restaurantListRequest:(double)newLocation.coordinate.latitude longitude:(double)newLocation.coordinate.longitude];
    //[self restaurantListRequest:34.825393 longitude:113.688249];
}
-(void)restaurantListRequest:(double)latitude longitude:(double)longitude
{
    ASIHTTPRequest *request=[TKHttpRequest RequestTKUrl:[NSString stringWithFormat:@"http://%@/OM_Interface/Restaurant.asmx?op=ListForSearch",Domain_Name]];
    NSString *postStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                       <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                       <soap:Body>\
                       <getRestListByLL xmlns=\"http://tempuri.org/\">\
                       <longitude>%g</longitude>\
                       <latitude>%g</latitude>\
                       </getRestListByLL>\
                       </soap:Body>\
                       </soap:Envelope>",longitude,latitude];
    [request addRequestHeader:@"Host" value:Domain_Name];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",postStr.length]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/getRestListByLL"];
    [request setPostBody:(NSMutableData *)[postStr dataUsingEncoding:4]];
    [request startAsynchronous];
    NSMutableData * reciveData = [NSMutableData dataWithCapacity:0];
    [request setStartedBlock:^{
        [MyActivceView startAnimatedInView:self.view];
    }];
    [request setDataReceivedBlock:^(NSData *data) {
        [reciveData appendData:data];
    }];
    __block NSArray * arr;
  //  __block NSMutableArray * dataArr1 = [NSMutableArray arrayWithCapacity:0];
    [request setCompletionBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        arr = [NSString ConverfromData:reciveData name:@"getRestListByLL"];
        if (arr.count>0)
        {
            if (IPhone5)
            {
                _mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
            }
            else
            {
                _mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController4" bundle:nil];
            }
            
            _mapViewController.delegate = self;
            [self.view addSubview:_mapViewController.view];
            [_mapViewController.view setFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44.0)];
            
            //把当前位置加上去
            NSMutableDictionary * dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic2 setValue:[NSString stringWithFormat:@"%g",locationManager.location.coordinate.latitude] forKey:@"Latitude"];
            [dic2 setValue:[NSString stringWithFormat:@"%g",locationManager.location.coordinate.longitude] forKey:@"Longitude"];
            [dic2 setValue:@"当前位置" forKey:@"restname"];
            listAry=[NSMutableArray arrayWithArray:arr];
            NSLog(@"--=--=-= %@",listAry);
            NSMutableArray * tempArr = [NSMutableArray arrayWithArray:arr];
            [tempArr addObject:dic2];
            [_mapViewController resetAnnitations:tempArr];

        }
        else
        {
            [MyAlert ShowAlertMessage:@"附近无餐馆！" title:@"提示"];
        }
    }];
    [request setFailedBlock:^{
        [MyActivceView stopAnimatedInView:self.view];
        [MyAlert ShowAlertMessage:@"网络不给力。" title:@"提示"];
    }];
}

- (void)customMKMapViewDidSelectedWithInfo:(id)info
{
    NSLog(@"%@========",info);
    NSDictionary * dicTemp = (NSDictionary *)info;
    DetailViewController *detailVC=[[DetailViewController alloc] init];
    detailVC.resInfoArr = (NSMutableArray *)dicTemp;
    detailVC.pID=[dicTemp valueForKey:@"id"];
    detailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
