//
//  FlightPathViewController.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightDatabase.h"
#import "Flight.h"
#import "FlightPath.h"
#import "CoreDataTableViewController.h"
#import "FlightDetailTBC.h"

@interface FlightPathViewController : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Flight *flight;
@end
