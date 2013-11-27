//
//  SavedFlightTVC.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Flight.h"

@interface SavedFlightTVC : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *context;
@end
