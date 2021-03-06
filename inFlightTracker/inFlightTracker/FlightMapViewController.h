//
//  FlightMapViewController.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flight.h"

@interface FlightMapViewController : UIViewController<MKMapViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Flight *flight;
@property (nonatomic) double timePast;
@end
