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
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface FlightMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *flightMap;
@end

@implementation FlightMapViewController

- (void)awakeFromNib
{

}

- (IBAction)takePhoto:(id)sender {
    NSLog(@"takePhoto");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSMutableDictionary *imageMetaData = [NSMutableDictionary dictionary];
    [imageMetaData setDictionary:[[info objectForKey:UIImagePickerControllerMediaMetadata] copy]];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    FlightPath *p = [self getCurrentPosition:self.timePast ForFlight:self.flight];
    if(p){
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        CLLocation *pCl=[[CLLocation alloc]initWithLatitude:[p.latitude doubleValue] longitude: [p.longitude doubleValue]];
        [imageMetaData setObject:[self updateExif:pCl] forKey:(NSString*)kCGImagePropertyGPSDictionary];
        [library writeImageToSavedPhotosAlbum:image.CGImage metadata:imageMetaData completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error == nil) {
                NSLog(@"Image saved.");
            } else {
                NSLog(@"Error saving image.");
            }}];
    }

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) viewWillAppear: (BOOL) animated {
    FlightDetailTBC *tbc=(FlightDetailTBC *)self.tabBarController;
    self.flight=tbc.flight;
    self.context = tbc.context;
    self.timePast=tbc.timePast;
    [self createPinsForFlight:self.flight];
    [self drawCurrentPosition:tbc.timePast ForFlight:self.flight];
}

-(FlightPath *)getCurrentPosition:(double)timePast ForFlight:(Flight *)flight{
    NSSet *paths=flight.path;
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]];
    
    NSArray *sortedPath = [[paths allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    for (NSInteger index = 0; index < [paths count]; index++) {
        FlightPath *p = [sortedPath objectAtIndex:index];
        if([p.timestamp doubleValue]>=timePast/3600/24){
            return p;
        }
    }
    return nil;
}

-(void)drawCurrentPosition:(double)timePast ForFlight:(Flight *)flight{
    FlightPath *p = [self getCurrentPosition:timePast ForFlight:flight];
    if(p){
            CLLocationCoordinate2D pCoor=CLLocationCoordinate2DMake([p.latitude doubleValue], [p.longitude doubleValue]);
            AirportPin *pPin=[[AirportPin alloc]initWithCoordinates:pCoor placeName:@"Current Position" description:@""];
            [self.flightMap addAnnotation:pPin];
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



-(NSMutableDictionary *)updateExif:(CLLocation *)currentLocation{
    
    
    NSMutableDictionary* locDict = [[NSMutableDictionary alloc] init];
    
    
    CLLocationDegrees exifLatitude = currentLocation.coordinate.latitude;
    CLLocationDegrees exifLongitude = currentLocation.coordinate.longitude;
    
    [locDict setObject:currentLocation.timestamp forKey:(NSString*)kCGImagePropertyGPSTimeStamp];
    
    if (exifLatitude <0.0){
        exifLatitude = exifLatitude*(-1);
        [locDict setObject:@"S" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    }else{
        [locDict setObject:@"N" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    }
    [locDict setObject:[NSNumber numberWithFloat:exifLatitude] forKey:(NSString*)kCGImagePropertyGPSLatitude];
    
    if (exifLongitude <0.0){
        exifLongitude=exifLongitude*(-1);
        [locDict setObject:@"W" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    }else{
        [locDict setObject:@"E" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    }
    [locDict setObject:[NSNumber numberWithFloat:exifLongitude] forKey:(NSString*) kCGImagePropertyGPSLongitude];
    
    
    return locDict;
}

@end
