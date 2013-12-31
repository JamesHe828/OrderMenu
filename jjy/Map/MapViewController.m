//
//  MapViewController.m
//  
//
//  Created by Jian-Ye on 12-10-16.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "MapViewController.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#import "EateryViewController.h"
#import "DestAnnotionView.h"

#define span 1800

@interface MapViewController ()
{
    NSMutableArray *_annotationList;
    
    CalloutMapAnnotation *_calloutAnnotation;
	CalloutMapAnnotation *_previousdAnnotation;
    
    int dotClickAnnotion;
    
    DestAnnotionView *annoDes;
}
@property (nonatomic,strong) NSArray * arrayList;
-(void)setAnnotionsWithList:(NSArray *)list;

@end

@implementation MapViewController
@synthesize mapView=_mapView;
@synthesize delegate;
@synthesize arrayList;



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

    _annotationList = [[NSMutableArray alloc] init];
    [super viewDidLoad];
}

-(void)setAnnotionsWithList:(NSArray *)list
{
    NSLog(@"list = %@",list);
    self.arrayList = [NSArray arrayWithArray:list];
    for (int i=0;i<list.count;i++)
    {
         NSDictionary * dic = [list objectAtIndex:i];
        CLLocationDegrees latitude=[[dic objectForKey:@"Latitude"] doubleValue];
        CLLocationDegrees longitude=[[dic objectForKey:@"Longitude"] doubleValue];
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,span,span);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        [_mapView setRegion:adjustedRegion animated:YES];

        if ([[dic valueForKey:@"restname"] isEqualToString:@"当前位置"] || [[dic valueForKey:@"restname"] isEqualToString:@"指定位置"])
        {
            annoDes = [[DestAnnotionView alloc] initWithLatitude:region.center.latitude andLongitude:region.center.longitude];
            annoDes.title = [dic valueForKey:@"restname"];
            [_mapView addAnnotation:annoDes];
        }
        else
        {
            BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
            annotation.tagInt = i;
            [_mapView addAnnotation:annotation];
        }
       
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"%s",__FUNCTION__);
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]])
    {
//        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
//            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude)
//        {
//            return;
//        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            //_calloutAnnotation = nil;
        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc]
                               initWithLatitude:view.annotation.coordinate.latitude
                               andLongitude:view.annotation.coordinate.longitude];
        BasicMapAnnotation * annotion1 = (BasicMapAnnotation *)view.annotation;
        dotClickAnnotion = annotion1.tagInt;
        NSLog(@"dotClickAnnotion = %d",dotClickAnnotion);
        [mapView addAnnotation:_calloutAnnotation];
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
//       else{
//           if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)]){
//               [delegate customMKMapViewDidSelectedWithInfo:@"点击至之后你要在这干点啥"];
//           }
//    }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
     NSLog(@"%s",__FUNCTION__);
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationVifew class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutAnnotation];
            if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)]){
                [delegate customMKMapViewDidSelectedWithInfo:[self.arrayList objectAtIndex:dotClickAnnotion]];
            }
        }
    }
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:nil];
        JingDianMapCell  *cell;
        if (!annotationView) {
            annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:nil];
           cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
            NSLog(@"dot = %d",dotClickAnnotion);
            cell.L_name.text = [[self.arrayList objectAtIndex:dotClickAnnotion] valueForKey:@"restname"];
            cell.L_adress.text = [NSString stringWithFormat:@"距离%g米",[[[self.arrayList objectAtIndex:dotClickAnnotion] valueForKey:@"Distance"] doubleValue]];
            NSString * pathUrl =[NSString stringWithFormat:@"%@%@",ALL_URL,[[self.arrayList objectAtIndex:dotClickAnnotion] valueForKey:@"restimg"]];
            ASIHTTPRequest * requestImg = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:pathUrl]];
            [requestImg startAsynchronous];
            NSMutableData * reciveData12 = [NSMutableData dataWithCapacity:0];
            [requestImg setStartedBlock:^{
                cell.left_imageView.image = [UIImage imageNamed:@"no.png"];
            }];
            [requestImg setDataReceivedBlock:^(NSData *data) {
                [reciveData12 appendData:data];
            }];
            [requestImg setCompletionBlock:^{
                cell.left_imageView.image = [UIImage imageWithData:reciveData12];
            }];
//            [cell.left_imageView setImageWithURL:[NSURL URLWithString:pathUrl] placeholderImage:[UIImage imageNamed:@"no.png"]];
            NSLog(@"url = %@",pathUrl);
            [annotationView.contentView addSubview:cell];
        }
        return annotationView;
	}
    else if ([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
         MKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"pin.png"];
        }
		
		return annotationView;
    }
    else if ([annotation isKindOfClass:[DestAnnotionView class]])
    {
        MKAnnotationView * annocationView1 = [_mapView dequeueReusableAnnotationViewWithIdentifier:@"callAnno1"];
        if (annocationView1 == nil)
        {
            annocationView1 = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"callAnno1"];
        }
        annocationView1.image = [UIImage imageNamed:@"pin.png"];
        annocationView1.canShowCallout = YES;
        [self performSelector:@selector(showCallOut1) withObject:self afterDelay:0.1];
        return annocationView1;
    }
	return nil;
}
-(void)showCallOut1
{
    [_mapView selectAnnotation:annoDes animated:YES];
}
- (void)resetAnnitations:(NSArray *)data
{
    [_annotationList removeAllObjects];
    [_annotationList addObjectsFromArray:data];
    [self setAnnotionsWithList:_annotationList];
}
@end
