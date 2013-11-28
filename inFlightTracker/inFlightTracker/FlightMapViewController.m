//
//  FlightMapViewController.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "FlightMapViewController.h"
#import "FlightDetailTBC.h"
#import "FlightPath.h"
#import "AirportPin.h"

@interface FlightMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *flightMap;
@end

@implementation FlightMapViewController

- (void)awakeFromNib
{

}


-(void) viewWillAppear: (BOOL) animated {
    FlightDetailTBC *tbc=(FlightDetailTBC *)self.tabBarController;
    self.flight=tbc.flight;
    self.context = tbc.context;
    [self createPinsForFlight:self.flight];
    [self drawCurrentPosition:tbc.timePast ForFlight:self.flight];
}

-(void)drawCurrentPosition:(double)timePast ForFlight:(Flight *)flight{
    NSSet *paths=flight.path;
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]];
    
    NSArray *sortedPath = [[paths allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    for (NSInteger index = 0; index < [paths count]; index++) {
        FlightPath *p = [sortedPath objectAtIndex:index];
        if([p.timestamp doubleValue]>=timePast/3600/24){
            CLLocationCoordinate2D pCoor=CLLocationCoordinate2DMake([p.latitude doubleValue], [p.longitude doubleValue]);
            AirportPin *pPin=[[AirportPin alloc]initWithCoordinates:pCoor placeName:@"Current Position" description:@""];
            [self.flightMap addAnnotation:pPin];
            break;
        }
    }

}


-(void)createPinsForFlight:(Flight *)flight{
    NSSet *paths=flight.path;
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]];
    
    NSArray *sortedPath = [[paths allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    FlightPath *departure=[sortedPath firstObject];
    CLLocationCoordinate2D departureCoor=CLLocationCoordinate2DMake([departure.latitude doubleValue], [departure.longitude doubleValue]);
    AirportPin *departurePin=[[AirportPin alloc]initWithCoordinates:departureCoor placeName:@"Departure" description:@""];
    [self.flightMap addAnnotation:departurePin];
    
    FlightPath *arrival=[sortedPath lastObject];
    CLLocationCoordinate2D arrivalCoor=CLLocationCoordinate2DMake([arrival.latitude doubleValue], [arrival.longitude doubleValue]);
    AirportPin *arrivalPin=[[AirportPin alloc]initWithCoordinates:arrivalCoor placeName:@"Arrival" description:@""];
    [self.flightMap addAnnotation:arrivalPin];
    
    //Draw polyline
    NSInteger numberOfSteps = paths.count;
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        FlightPath *p = [sortedPath objectAtIndex:index];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([p.latitude doubleValue], [p.longitude doubleValue]);;
        
        coordinates[index] = coordinate;
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    //[self.flightMap addOverlay:polyLine];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.flightMap addOverlay:polyLine level:MKOverlayLevelAboveRoads];
    });
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        return routeRenderer;
    }
    else return nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.flightMap.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
