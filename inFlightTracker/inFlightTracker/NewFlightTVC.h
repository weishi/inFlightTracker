//
//  NewFlightTVC.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flight.h"
#import "Flight+Create.h"

@interface NewFlightTVC : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *context;
@end
