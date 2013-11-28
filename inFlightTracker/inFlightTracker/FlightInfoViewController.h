//
//  FlightInfoViewController.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/28/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flight.h"

@interface FlightInfoViewController : UIViewController
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Flight *flight;
@end
